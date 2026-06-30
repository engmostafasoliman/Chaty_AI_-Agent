import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/api_result.dart';
import '../../../repo_list/domain/usecases/generate_summary_usecase.dart';
import '../../../repo_list/domain/usecases/get_repo_detail_usecase.dart';
import '../../../settings/domain/repositories/settings_repository.dart';
import 'repo_detail_state.dart';

class RepoDetailCubit extends Cubit<RepoDetailState> {
  final GetRepoDetailUseCase _getDetail;
  final GenerateSummaryUseCase _generateSummary;
  final SettingsRepository _settingsRepo;

  RepoDetailCubit(this._getDetail, this._generateSummary, this._settingsRepo)
      : super(const RepoDetailInitial());

  Future<void> load(String repoId) async {
    emit(const RepoDetailLoading());
    final result = await _getDetail(repoId);
    switch (result) {
      case ApiSuccess(:final data):
        emit(RepoDetailLoaded(data));
        if (!data.summarized) {
          final settings = await _settingsRepo.load();
          if (settings.autoSummarize) await generateSummary();
        }
      case ApiFailure(:final message):
        emit(RepoDetailError(message));
      case ApiRateLimit():
        emit(const RepoDetailError('Service temporarily unavailable. Please try again.'));
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
      case ApiRateLimit():
        emit(const RepoDetailError('Service temporarily unavailable. Please try again.'));
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
      case ApiRateLimit():
        emit(RepoDetailLoaded(current.repo));
    }
  }
}
