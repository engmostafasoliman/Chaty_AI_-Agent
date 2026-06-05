import 'package:chaty_ai_agent/core/error/app_exception.dart';
import 'package:chaty_ai_agent/core/result/api_result.dart';
import 'package:chaty_ai_agent/features/chat/data/models/chat_message_model.dart';
import 'package:chaty_ai_agent/features/chat/data/repositories/gemini_chat_repository_impl.dart';
import 'package:chaty_ai_agent/features/chat/data/services/gemini_chat_service.dart';
import 'package:chaty_ai_agent/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGeminiChatService extends Mock implements GeminiChatService {}

void main() {
  late MockGeminiChatService mockService;
  late GeminiChatRepositoryImpl repository;

  setUp(() {
    mockService = MockGeminiChatService();
    repository = GeminiChatRepositoryImpl(mockService);
  });

  const tMessages = [
    ChatMessage(role: 'user', text: 'Explain how AI works'),
  ];

  const tResponseModel = ChatMessageModel(
    role: 'model',
    parts: [ChatPart(text: 'AI works by recognizing patterns.')],
  );

  group('sendMessage', () {
    test('returns ApiSuccess with ChatMessage on service success', () async {
      when(() => mockService.sendMessages(any()))
          .thenAnswer((_) async => tResponseModel);

      final result = await repository.sendMessage(tMessages);

      expect(result, isA<ApiSuccess<ChatMessage>>());
      final success = result as ApiSuccess<ChatMessage>;
      expect(success.data.role, 'model');
      expect(success.data.text, 'AI works by recognizing patterns.');
    });

    test('returns ApiFailure with humanized message on NoInternetException',
        () async {
      when(() => mockService.sendMessages(any()))
          .thenThrow(const NoInternetException());

      final result = await repository.sendMessage(tMessages);

      expect(result, isA<ApiFailure<ChatMessage>>());
      final failure = result as ApiFailure<ChatMessage>;
      expect(failure.message, contains('No internet connection'));
    });

    test('returns ApiFailure with humanized message on RateLimitException',
        () async {
      when(() => mockService.sendMessages(any()))
          .thenThrow(const RateLimitException());

      final result = await repository.sendMessage(tMessages);

      final failure = result as ApiFailure<ChatMessage>;
      expect(failure.message, contains('too fast'));
    });

    test('returns ApiFailure with humanized message on ServerException',
        () async {
      when(() => mockService.sendMessages(any()))
          .thenThrow(const ServerException(503));

      final result = await repository.sendMessage(tMessages);

      final failure = result as ApiFailure<ChatMessage>;
      expect(failure.message, contains('AI service is having trouble'));
    });

    test('returns ApiFailure with generic message on unknown error', () async {
      when(() => mockService.sendMessages(any()))
          .thenThrow(Exception('unknown'));

      final result = await repository.sendMessage(tMessages);

      final failure = result as ApiFailure<ChatMessage>;
      expect(failure.message, contains('Something went wrong'));
    });

    test('passes correct number of messages to service', () async {
      when(() => mockService.sendMessages(any()))
          .thenAnswer((_) async => tResponseModel);

      await repository.sendMessage(tMessages);

      final captured =
          verify(() => mockService.sendMessages(captureAny())).captured;
      final sentModels = captured.first as List<ChatMessageModel>;
      expect(sentModels.length, 1);
      expect(sentModels.first.role, 'user');
      expect(sentModels.first.parts.first.text, 'Explain how AI works');
    });
  });
}
