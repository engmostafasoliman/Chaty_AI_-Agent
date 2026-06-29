import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

import '../../../profile/domain/entities/user_entity.dart';

class FirebaseAuthDataSource {
  static const _callbackScheme =
      'app-1-336914432908-ios-56c4911e793be08a78cca9';

  final FirebaseAuth _auth;
  final FlutterSecureStorage _storage;

  FirebaseAuthDataSource({
    FirebaseAuth? auth,
    FlutterSecureStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? const FlutterSecureStorage();

  Future<UserEntity> signInWithGitHub() async {
    const clientId = String.fromEnvironment('GITHUB_CLIENT_ID');
    const clientSecret = String.fromEnvironment('GITHUB_CLIENT_SECRET');

    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw Exception(
        'Run with --dart-define=GITHUB_CLIENT_ID=... --dart-define=GITHUB_CLIENT_SECRET=...',
      );
    }

    // Step 1: Open GitHub OAuth page; waits for callback to custom scheme
    final result = await FlutterWebAuth2.authenticate(
      url: 'https://github.com/login/oauth/authorize'
          '?client_id=$clientId'
          '&scope=read:user%20public_repo',
      callbackUrlScheme: _callbackScheme,
    );

    // Step 2: Extract authorization code
    final code = Uri.parse(result).queryParameters['code'];
    if (code == null) throw Exception('OAuth failed: no code in callback');

    // Step 3: Exchange code for access token
    final tokenResponse = await http.post(
      Uri.parse('https://github.com/login/oauth/access_token'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'client_id=$clientId&client_secret=$clientSecret&code=$code',
    );

    if (tokenResponse.statusCode != 200) {
      throw Exception('Token exchange failed: ${tokenResponse.statusCode}');
    }

    final tokenData = jsonDecode(tokenResponse.body) as Map<String, dynamic>;
    final token = tokenData['access_token'] as String?;
    if (token == null) {
      final error = tokenData['error_description'] ??
          tokenData['error'] ??
          'Unknown error';
      throw Exception('No access token: $error');
    }

    // Step 4: Sign into Firebase using the GitHub token
    final credential = GithubAuthProvider.credential(token);
    await _auth.signInWithCredential(credential);

    // Step 5: Persist token for GitHub API calls
    await _storage.write(key: 'github_access_token', value: token);

    // Step 6: Return user entity from GitHub profile
    return _buildUserEntity(token);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _storage.delete(key: 'github_access_token');
  }

  User? get currentFirebaseUser => _auth.currentUser;

  Future<String?> get accessToken => _storage.read(key: 'github_access_token');

  Future<UserEntity> _buildUserEntity(String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('GitHub API error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final name = (json['name'] as String?)?.isNotEmpty == true
        ? json['name'] as String
        : json['login'] as String? ?? '';

    return UserEntity(
      name: name,
      handle: json['login'] as String? ?? '',
      initials: _initials(name),
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String? ?? '',
      location: json['location'] as String? ?? '',
      company: json['company'] as String? ?? '',
      joined: _formatDate(json['created_at'] as String?),
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      publicRepos: json['public_repos'] as int? ?? 0,
      stars: 0,
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return 'Joined ${months[dt.month - 1]} ${dt.year}';
  }
}
