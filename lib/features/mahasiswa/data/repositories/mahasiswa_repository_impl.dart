import 'package:either_dart/either.dart';
import '../datasources/mahasiswa_remote_data_source.dart';
import '../models/mahasiswa_models.dart';
import '../models/ticket_model.dart';

class MahasiswaRepositoryImpl {
  final MahasiswaRemoteDataSource _remoteDataSource;

  MahasiswaRepositoryImpl(this._remoteDataSource);

  Future<Either<String, List<HistoryPendidikan>>> getHistoryPendidikan() async {
    try {
      final response = await _remoteDataSource.getHistoryPendidikan();
      if (response['success'] == true && response['data'] != null) {
        final list = response['data'] as List;
        final history = list.map((e) => HistoryPendidikan.fromJson(e as Map<String, dynamic>)).toList();
        return Right(history);
      } else {
        return Left(response['message'] ?? 'Gagal mengambil data riwayat pendidikan');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<SemesterGrades>>> getNilai() async {
    try {
      final response = await _remoteDataSource.getNilai();
      if (response['success'] == true && response['data'] != null) {
        final list = response['data'] as List;
        if (list.isNotEmpty && list.first is Map && (list.first as Map).containsKey('list_nilai')) {
          final grades = list.map((e) => SemesterGrades.fromJson(e as Map<String, dynamic>)).toList();
          return Right(grades);
        } else {
          final grades = SemesterGrades.fromFlatJsonList(list);
          return Right(grades);
        }
      } else {
        return Left(response['message'] ?? 'Gagal mengambil data nilai');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Transkrip>> getTranskrip() async {
    try {
      final response = await _remoteDataSource.getTranskrip();
      if (response['success'] == true && response['data'] != null) {
        final transkrip = Transkrip.fromJson(response['data'] as Map<String, dynamic>);
        return Right(transkrip);
      } else {
        return Left(response['message'] ?? 'Gagal mengambil data transkrip nilai');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<TicketModel>>> getTickets() async {
    try {
      final response = await _remoteDataSource.getTickets();
      if (response['success'] == true && response['data'] != null) {
        final list = response['data'] as List;
        final tickets = list.map((e) => TicketModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(tickets);
      } else {
        return Left(response['message'] ?? 'Gagal mengambil daftar aduan');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, TicketModel>> getTicketDetail(int id) async {
    try {
      final response = await _remoteDataSource.getTicketDetail(id);
      if (response['success'] == true && response['data'] != null) {
        final ticket = TicketModel.fromJson(response['data'] as Map<String, dynamic>);
        return Right(ticket);
      } else {
        return Left(response['message'] ?? 'Gagal mengambil detail aduan');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, TicketModel>> createTicket({
    required String kategori,
    required String judul,
    required String deskripsi,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    try {
      final response = await _remoteDataSource.createTicket(
        kategori: kategori,
        judul: judul,
        deskripsi: deskripsi,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      if (response['success'] == true && response['data'] != null) {
        final ticket = TicketModel.fromJson(response['data'] as Map<String, dynamic>);
        return Right(ticket);
      } else {
        return Left(response['message'] ?? 'Gagal membuat aduan baru');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, TicketReplyModel>> createTicketReply({
    required int ticketId,
    required String pesan,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    try {
      final response = await _remoteDataSource.createTicketReply(
        ticketId: ticketId,
        pesan: pesan,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      if (response['success'] == true && response['data'] != null) {
        final reply = TicketReplyModel.fromJson(response['data'] as Map<String, dynamic>);
        return Right(reply);
      } else {
        return Left(response['message'] ?? 'Gagal mengirim balasan');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}

