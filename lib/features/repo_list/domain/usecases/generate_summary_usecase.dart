import '../../../../core/result/api_result.dart';
import '../entities/repo_summary_entity.dart';
import '../repositories/repo_repository.dart';

class GenerateSummaryUseCase {
  final RepoRepository _repository;
  const GenerateSummaryUseCase(this._repository);

  Future<ApiResult<RepoSummaryEntity>> call(String repoId, {bool force = false}) =>
      _repository.generateSummary(repoId, force: force);
}
