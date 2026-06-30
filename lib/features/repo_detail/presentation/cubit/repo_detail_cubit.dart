import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/api_result.dart';
import '../../../repo_list/domain/usecases/generate_summary_usecase.dart';
import '../../../repo_list/domain/usecases/get_repo_detail_usecase.dart';
import 'repo_detail_state.dart';

class RepoDetailCubit extends Cubit<RepoDetailState> {
  final GetRepoDetailUseCase _getDetail;
  final GenerateSummaryUseCase _generateSummary;

  RepoDetailCubit(this._getDetail, this._generateSummary)
      : super(const RepoDetailInitial());

  Future<void> load(String repoId) async {
    emit(const RepoDetailLoading());
    final result = await _getDetail(repoId);
    switch (result) {
      case ApiSuccess(:final data):
        emit(RepoDetailLoaded(data));
      case ApiFailure(:final message):
        emit(RepoDetailError(message));
    }
  }

  Future<void> generateSummary() async {
    final current = state;
    if (current is! RepoDetailLoaded) return;
    emit(RepoDetailGenerating(current.repo));
    final result = await _generateSummary(current.repo.id);
    switch (result) {
      case ApiSuccess(:final data):
        emit(RepoDetailLoaded(current.repo.withSummary(data)));
      case ApiFailure(:final message):
        emit(RepoDetailError(message));
    }
  }

  Future<void> regenerateSummary() async {
    final current = state;
    if (current is! RepoDetailLoaded) return;
    emit(RepoDetailGenerating(current.repo));
    final result = await _generateSummary(current.repo.id, force: true);
    switch (result) {
      case ApiSuccess(:final data):
        emit(RepoDetailLoaded(current.repo.withSummary(data)));
      case ApiFailure():
        emit(RepoDetailLoaded(current.repo));
    }
  }
}
