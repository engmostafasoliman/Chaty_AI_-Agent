import '../../../../core/result/api_result.dart';
import '../entities/repo_entity.dart';
import '../repositories/repo_repository.dart';

class GetRepoDetailUseCase {
  final RepoRepository _repository;
  const GetRepoDetailUseCase(this._repository);

  Future<ApiResult<RepoEntity>> call(String id) => _repository.getRepoById(id);
}
