import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/mahasiswa_repository_impl.dart';
import 'mahasiswa_event.dart';
import 'mahasiswa_state.dart';

class MahasiswaBloc extends Bloc<MahasiswaEvent, MahasiswaState> {
  final MahasiswaRepositoryImpl _repository;

  MahasiswaBloc(this._repository) : super(MahasiswaInitial()) {
    on<FetchHistoryPendidikanRequested>((event, emit) async {
      emit(HistoryPendidikanLoading());
      final result = await _repository.getHistoryPendidikan();
      result.fold(
        (failure) => emit(HistoryPendidikanFailure(failure)),
        (history) => emit(HistoryPendidikanLoaded(history)),
      );
    });

    on<FetchNilaiRequested>((event, emit) async {
      emit(NilaiLoading());
      final result = await _repository.getNilai();
      result.fold(
        (failure) => emit(NilaiFailure(failure)),
        (nilai) => emit(NilaiLoaded(nilai)),
      );
    });

    on<FetchTranskripRequested>((event, emit) async {
      emit(TranskripLoading());
      final result = await _repository.getTranskrip();
      result.fold(
        (failure) => emit(TranskripFailure(failure)),
        (transkrip) => emit(TranskripLoaded(transkrip)),
      );
    });
  }
}
