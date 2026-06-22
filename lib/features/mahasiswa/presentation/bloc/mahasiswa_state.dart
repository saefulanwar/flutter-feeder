import '../../data/models/mahasiswa_models.dart';

abstract class MahasiswaState {}

class MahasiswaInitial extends MahasiswaState {}

// History States
class HistoryPendidikanLoading extends MahasiswaState {}

class HistoryPendidikanLoaded extends MahasiswaState {
  final List<HistoryPendidikan> history;
  HistoryPendidikanLoaded(this.history);
}

class HistoryPendidikanFailure extends MahasiswaState {
  final String errorMessage;
  HistoryPendidikanFailure(this.errorMessage);
}

// Nilai States
class NilaiLoading extends MahasiswaState {}

class NilaiLoaded extends MahasiswaState {
  final List<SemesterGrades> nilaiSemester;
  NilaiLoaded(this.nilaiSemester);
}

class NilaiFailure extends MahasiswaState {
  final String errorMessage;
  NilaiFailure(this.errorMessage);
}

// Transkrip States
class TranskripLoading extends MahasiswaState {}

class TranskripLoaded extends MahasiswaState {
  final Transkrip transkrip;
  TranskripLoaded(this.transkrip);
}

class TranskripFailure extends MahasiswaState {
  final String errorMessage;
  TranskripFailure(this.errorMessage);
}
