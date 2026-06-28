import 'repo_summary_entity.dart';

class RepoEntity {
  final String id;
  final String name;
  final String owner;
  final String description;
  final String language;
  final int stars;
  final String updatedAgo;
  final String license;
  final String lastCommit;
  final bool summarized;
  final RepoSummaryEntity? summary;

  const RepoEntity({
    required this.id,
    required this.name,
    required this.owner,
    required this.description,
    required this.language,
    required this.stars,
    required this.updatedAgo,
    required this.license,
    required this.lastCommit,
    required this.summarized,
    this.summary,
  });

  RepoEntity withSummary(RepoSummaryEntity summary) => RepoEntity(
        id: id,
        name: name,
        owner: owner,
        description: description,
        language: language,
        stars: stars,
        updatedAgo: updatedAgo,
        license: license,
        lastCommit: lastCommit,
        summarized: true,
        summary: summary,
      );
}
