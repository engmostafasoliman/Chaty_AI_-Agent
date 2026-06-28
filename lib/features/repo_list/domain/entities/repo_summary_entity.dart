enum ConfidenceLevel { high, medium, low }

class RepoSummaryEntity {
  final String whatItDoes;
  final List<String> techStack;
  final List<String> strengths;
  final List<String> weaknesses;
  final ConfidenceLevel confidence;

  const RepoSummaryEntity({
    required this.whatItDoes,
    required this.techStack,
    required this.strengths,
    required this.weaknesses,
    required this.confidence,
  });
}
