import '../../domain/entities/repo_summary_entity.dart';

class RepoSummaryModel extends RepoSummaryEntity {
  const RepoSummaryModel({
    required super.whatItDoes,
    required super.techStack,
    required super.strengths,
    required super.weaknesses,
    required super.confidence,
  });

  factory RepoSummaryModel.fromJson(Map<String, dynamic> json) =>
      RepoSummaryModel(
        whatItDoes: json['whatItDoes'] as String,
        techStack: List<String>.from(json['techStack'] as List),
        strengths: List<String>.from(json['strengths'] as List),
        weaknesses: List<String>.from(json['weaknesses'] as List),
        confidence: ConfidenceLevel.values.firstWhere(
          (e) => e.name == json['confidence'],
          orElse: () => ConfidenceLevel.medium,
        ),
      );
}
