import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class MahasiswaRemoteDataSource {
  final DioClient _dioClient;

  MahasiswaRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> getHistoryPendidikan() async {
    try {
      final response = await _dioClient.dio.get('/api/mahasiswa/history-pendidikan');
      return response.data as Map<String, dynamic>;
    } on DioException catch (_) {
      // Fallback ke data tiruan (mock data) jika endpoint tidak tersedia atau terjadi error jaringan
      return _getMockHistoryPendidikan();
    } catch (_) {
      return _getMockHistoryPendidikan();
    }
  }

  Future<Map<String, dynamic>> getNilai() async {
    try {
      final response = await _dioClient.dio.get('/api/mahasiswa/nilai');
      return response.data as Map<String, dynamic>;
    } on DioException catch (_) {
      return _getMockNilai();
    } catch (_) {
      return _getMockNilai();
    }
  }

  Future<Map<String, dynamic>> getTranskrip() async {
    try {
      final response = await _dioClient.dio.get('/api/mahasiswa/transkrip');
      return response.data as Map<String, dynamic>;
    } on DioException catch (_) {
      return _getMockTranskrip();
    } catch (_) {
      return _getMockTranskrip();
    }
  }

  Future<Map<String, dynamic>> getTickets() async {
    try {
      final response = await _dioClient.dio.get('/api/mahasiswa/tickets');
      return response.data as Map<String, dynamic>;
    } on DioException catch (_) {
      return _getMockTickets();
    } catch (_) {
      return _getMockTickets();
    }
  }

  Future<Map<String, dynamic>> getTicketDetail(int id) async {
    try {
      final response = await _dioClient.dio.get('/api/mahasiswa/tickets/$id');
      return response.data as Map<String, dynamic>;
    } on DioException catch (_) {
      return _getMockTicketDetail(id);
    } catch (_) {
      return _getMockTicketDetail(id);
    }
  }

  Future<Map<String, dynamic>> createTicket({
    required String kategori,
    required String judul,
    required String deskripsi,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    try {
      MultipartFile? file;
      if (fileBytes != null && fileBytes.isNotEmpty && fileName != null) {
        file = MultipartFile.fromBytes(fileBytes, filename: fileName);
      }

      final formData = FormData.fromMap({
        'kategori': kategori,
        'judul': judul,
        'deskripsi': deskripsi,
        if (file != null) 'lampiran': file,
      });

      final response = await _dioClient.dio.post(
        '/api/mahasiswa/tickets',
        data: formData,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data as Map<String, dynamic>;
      }
      return {
        'success': false,
        'message': 'Gagal membuat tiket aduan: Jaringan bermasalah'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal membuat tiket aduan: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> createTicketReply({
    required int ticketId,
    required String pesan,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    try {
      MultipartFile? file;
      if (fileBytes != null && fileBytes.isNotEmpty && fileName != null) {
        file = MultipartFile.fromBytes(fileBytes, filename: fileName);
      }

      final formData = FormData.fromMap({
        'pesan': pesan,
        if (file != null) 'lampiran': file,
      });

      final response = await _dioClient.dio.post(
        '/api/mahasiswa/tickets/$ticketId/replies',
        data: formData,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data as Map<String, dynamic>;
      }
      return {
        'success': false,
        'message': 'Gagal mengirim balasan: Jaringan bermasalah'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal mengirim balasan: ${e.toString()}'
      };
    }
  }

  Map<String, dynamic> _getMockTickets() {
    return {
      'success': true,
      'message': 'Berhasil mengambil daftar tiket aduan',
      'data': [
        {
          'id': 1,
          'nim': '22520241029',
          'id_prodi': '102',
          'kategori': 'nilai',
          'judul': 'Nilai Algoritma Pemrograman Tidak Sesuai KHS',
          'deskripsi': 'Nilai saya di KHS adalah A, namun di PDDIKTI tercatat C. Mohon bantuannya untuk sinkronisasi ulang data nilai matakuliah Algoritma dan Pemrograman.',
          'status': 'open',
          'lampiran': null,
          'created_at': '2026-06-16T10:00:00.000000Z',
          'updated_at': '2026-06-16T10:00:00.000000Z',
        },
        {
          'id': 2,
          'nim': '22520241029',
          'id_prodi': '102',
          'kategori': 'biodata',
          'judul': 'Kesalahan Penulisan Nama Ibu Kandung',
          'deskripsi': 'Nama ibu kandung saya tertulis Siti Rahma, seharusnya Siti Rahmah (ada huruf h di akhir). Saya lampirkan Akta Kelahiran dan Kartu Keluarga.',
          'status': 'closed',
          'lampiran': 'https://feedmap.uny.ac.id/storage/tickets/mock_kk.png',
          'created_at': '2026-06-10T08:30:00.000000Z',
          'updated_at': '2026-06-12T14:20:00.000000Z',
        }
      ]
    };
  }

  Map<String, dynamic> _getMockTicketDetail(int id) {
    if (id == 1) {
      return {
        'success': true,
        'message': 'Berhasil mengambil detail tiket aduan',
        'data': {
          'id': 1,
          'nim': '22520241029',
          'id_prodi': '102',
          'kategori': 'nilai',
          'judul': 'Nilai Algoritma Pemrograman Tidak Sesuai KHS',
          'deskripsi': 'Nilai saya di KHS adalah A, namun di PDDIKTI tercatat C. Mohon bantuannya untuk sinkronisasi ulang data nilai matakuliah Algoritma dan Pemrograman.',
          'status': 'open',
          'lampiran': null,
          'created_at': '2026-06-16T10:00:00.000000Z',
          'updated_at': '2026-06-17T09:00:00.000000Z',
          'replies': [
            {
              'id': 101,
              'ticket_id': 1,
              'sender_type': 'admin',
              'user_id': 1,
              'pesan': 'Halo Saeful, baik aduan kami terima. Bisakah Anda mengirimkan screenshot KHS lokal Anda sebagai bukti pendukung untuk kami cocokkan dengan database lokal?',
              'lampiran': null,
              'created_at': '2026-06-16T14:30:00.000000Z',
              'updated_at': '2026-06-16T14:30:00.000000Z',
              'user': {
                'id': 1,
                'name': 'Budi Utomo (Akademik)',
                'email': 'budi.akademik@uny.ac.id',
              }
            },
            {
              'id': 102,
              'ticket_id': 1,
              'sender_type': 'mahasiswa',
              'user_id': null,
              'pesan': 'Baik pak, ini saya lampirkan tangkapan layar KHS saya dari portal akademik UNY.',
              'lampiran': 'https://feedmap.uny.ac.id/storage/replies/mock_khs.png',
              'created_at': '2026-06-17T09:00:00.000000Z',
              'updated_at': '2026-06-17T09:00:00.000000Z',
              'user': null,
            }
          ]
        }
      };
    } else {
      return {
        'success': true,
        'message': 'Berhasil mengambil detail tiket aduan',
        'data': {
          'id': 2,
          'nim': '22520241029',
          'id_prodi': '102',
          'kategori': 'biodata',
          'judul': 'Kesalahan Penulisan Nama Ibu Kandung',
          'deskripsi': 'Nama ibu kandung saya tertulis Siti Rahma, seharusnya Siti Rahmah (ada huruf h di akhir). Saya lampirkan Akta Kelahiran dan Kartu Keluarga.',
          'status': 'closed',
          'lampiran': 'https://feedmap.uny.ac.id/storage/tickets/mock_kk.png',
          'created_at': '2026-06-10T08:30:00.000000Z',
          'updated_at': '2026-06-12T14:20:00.000000Z',
          'replies': [
            {
              'id': 201,
              'ticket_id': 2,
              'sender_type': 'admin',
              'user_id': 2,
              'pesan': 'Halo Saeful, perbaikan data nama ibu kandung telah kami proses dan sesuaikan dengan Kartu Keluarga yang Anda kirimkan. Silakan cek berkala biodata Anda di halaman depan aplikasi ini atau portal PDDIKTI. Tiket aduan kami tutup.',
              'lampiran': null,
              'created_at': '2026-06-12T14:20:00.000000Z',
              'updated_at': '2026-06-12T14:20:00.000000Z',
              'user': {
                'id': 2,
                'name': 'Rini Astuti (Admin PDDIKTI)',
                'email': 'rini.pddikti@uny.ac.id',
              }
            }
          ]
        }
      };
    }
  }

  Map<String, dynamic> _getMockHistoryPendidikan() {
    return {
      'success': true,
      'message': 'Mock data riwayat pendidikan',
      'data': [
        {
          'nim': '22520241029',
          'nama_mahasiswa': 'Saeful Anwar',
          'nama_perguruan_tinggi': 'Universitas Negeri Yogyakarta',
          'nama_program_studi': 'Pendidikan Teknik Informatika',
          'jalur_pendaftaran': 'SNBP (Seleksi Nasional Berdasarkan Prestasi)',
          'tanggal_daftar': '2022-07-15',
          'jenjang_pendidikan': 'S1',
        },
        {
          'nim': '192010293',
          'nama_mahasiswa': 'Saeful Anwar',
          'nama_perguruan_tinggi': 'SMAN 1 Yogyakarta',
          'nama_program_studi': 'MIPA (Matematika dan Ilmu Pengetahuan Alam)',
          'jalur_pendaftaran': 'Zonasi',
          'tanggal_daftar': '2019-06-20',
          'jenjang_pendidikan': 'SMA',
        }
      ]
    };
  }

  Map<String, dynamic> _getMockNilai() {
    return {
      'success': true,
      'message': 'Mock data nilai semester',
      'data': [
        {
          'semester_nama': 'Semester 1 - 2022/2023 Ganjil',
          'ips': 3.75,
          'sks_semester': 20,
          'list_nilai': [
            {'kode_mata_kuliah': 'MKW6201', 'nama_mata_kuliah': 'Pendidikan Agama Islam', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'MKW6202', 'nama_mata_kuliah': 'Pendidikan Pancasila', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6301', 'nama_mata_kuliah': 'Pengantar Teknologi Informasi', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6302', 'nama_mata_kuliah': 'Algoritma dan Pemrograman', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
            {'kode_mata_kuliah': 'PTI6303', 'nama_mata_kuliah': 'Matematika Diskrit', 'sks': 3, 'nilai_angka': 3.00, 'nilai_huruf': 'B'},
            {'kode_mata_kuliah': 'PTI6304', 'nama_mata_kuliah': 'Fisika Dasar untuk IT', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
            {'kode_mata_kuliah': 'MKW6203', 'nama_mata_kuliah': 'Bahasa Inggris Akademik', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          ]
        },
        {
          'semester_nama': 'Semester 2 - 2022/2023 Genap',
          'ips': 3.85,
          'sks_semester': 21,
          'list_nilai': [
            {'kode_mata_kuliah': 'MKW6204', 'nama_mata_kuliah': 'Pendidikan Kewarganegaraan', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6305', 'nama_mata_kuliah': 'Struktur Data', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6306', 'nama_mata_kuliah': 'Arsitektur & Organisasi Komputer', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
            {'kode_mata_kuliah': 'PTI6307', 'nama_mata_kuliah': 'Sistem Operasi', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6308', 'nama_mata_kuliah': 'Basis Data', 'sks': 4, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
            {'kode_mata_kuliah': 'PTI6309', 'nama_mata_kuliah': 'Desain Grafis & Multimedia', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'MKW6205', 'nama_mata_kuliah': 'Bahasa Indonesia Keilmuan', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          ]
        },
        {
          'semester_nama': 'Semester 3 - 2023/2024 Ganjil',
          'ips': 3.90,
          'sks_semester': 22,
          'list_nilai': [
            {'kode_mata_kuliah': 'PTI6310', 'nama_mata_kuliah': 'Pemrograman Berorientasi Objek', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6311', 'nama_mata_kuliah': 'Jaringan Komputer', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6312', 'nama_mata_kuliah': 'Rekayasa Perangkat Lunak', 'sks': 4, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
            {'kode_mata_kuliah': 'PTI6313', 'nama_mata_kuliah': 'Statistika dan Probabilitas', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6314', 'nama_mata_kuliah': 'Sistem Berkas & Pengolahan Data', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6315', 'nama_mata_kuliah': 'Interaksi Manusia & Komputer', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'MKW6206', 'nama_mata_kuliah': 'Sosio-Antropologi Pendidikan', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          ]
        },
        {
          'semester_nama': 'Semester 4 - 2023/2024 Genap',
          'ips': 3.78,
          'sks_semester': 21,
          'list_nilai': [
            {'kode_mata_kuliah': 'PTI6316', 'nama_mata_kuliah': 'Pemrograman Web Dinamis', 'sks': 4, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
            {'kode_mata_kuliah': 'PTI6317', 'nama_mata_kuliah': 'Analisis dan Perancangan Sistem', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6318', 'nama_mata_kuliah': 'Kecerdasan Buatan (AI)', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
            {'kode_mata_kuliah': 'PTI6319', 'nama_mata_kuliah': 'Keamanan Informasi & Jaringan', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6320', 'nama_mata_kuliah': 'Sistem Informasi Manajemen', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6321', 'nama_mata_kuliah': 'Metodologi Penelitian TI', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'MKW6207', 'nama_mata_kuliah': 'Perkembangan Peserta Didik', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          ]
        },
        {
          'semester_nama': 'Semester 5 - 2024/2025 Ganjil',
          'ips': 3.95,
          'sks_semester': 22,
          'list_nilai': [
            {'kode_mata_kuliah': 'PTI6322', 'nama_mata_kuliah': 'Pemrograman Perangkat Bergerak (Mobile)', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6323', 'nama_mata_kuliah': 'Administrasi Sistem Jaringan', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6324', 'nama_mata_kuliah': 'Grafika Komputer', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6325', 'nama_mata_kuliah': 'Manajemen Proyek Teknologi Informasi', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
            {'kode_mata_kuliah': 'PTI6326', 'nama_mata_kuliah': 'Kriptografi Dasar', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6327', 'nama_mata_kuliah': 'Teknologi Cloud Computing', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'MKW6208', 'nama_mata_kuliah': 'Filsafat Pendidikan', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          ]
        },
        {
          'semester_nama': 'Semester 6 - 2024/2025 Genap',
          'ips': 4.00,
          'sks_semester': 16,
          'list_nilai': [
            {'kode_mata_kuliah': 'PTI6328', 'nama_mata_kuliah': 'Proyek Perangkat Lunak Terintegrasi', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6329', 'nama_mata_kuliah': 'Data Science & Big Data', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6330', 'nama_mata_kuliah': 'Internet of Things (IoT)', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'PTI6331', 'nama_mata_kuliah': 'Etika Profesi dan Hukum IT', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
            {'kode_mata_kuliah': 'MKW6209', 'nama_mata_kuliah': 'Kewirausahaan Mahasiswa', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          ]
        }
      ]
    };
  }

  Map<String, dynamic> _getMockTranskrip() {
    return {
      'success': true,
      'message': 'Mock data transkrip nilai',
      'data': {
        'ipk': 3.86,
        'total_sks': 122,
        'list_transkrip': [
          {'kode_mata_kuliah': 'MKW6201', 'nama_mata_kuliah': 'Pendidikan Agama Islam', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'MKW6202', 'nama_mata_kuliah': 'Pendidikan Pancasila', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6301', 'nama_mata_kuliah': 'Pengantar Teknologi Informasi', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6302', 'nama_mata_kuliah': 'Algoritma dan Pemrograman', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          {'kode_mata_kuliah': 'PTI6303', 'nama_mata_kuliah': 'Matematika Diskrit', 'sks': 3, 'nilai_angka': 3.00, 'nilai_huruf': 'B'},
          {'kode_mata_kuliah': 'PTI6304', 'nama_mata_kuliah': 'Fisika Dasar untuk IT', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          {'kode_mata_kuliah': 'MKW6203', 'nama_mata_kuliah': 'Bahasa Inggris Akademik', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'MKW6204', 'nama_mata_kuliah': 'Pendidikan Kewarganegaraan', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6305', 'nama_mata_kuliah': 'Struktur Data', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6306', 'nama_mata_kuliah': 'Arsitektur & Organisasi Komputer', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          {'kode_mata_kuliah': 'PTI6307', 'nama_mata_kuliah': 'Sistem Operasi', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6308', 'nama_mata_kuliah': 'Basis Data', 'sks': 4, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          {'kode_mata_kuliah': 'PTI6309', 'nama_mata_kuliah': 'Desain Grafis & Multimedia', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'MKW6205', 'nama_mata_kuliah': 'Bahasa Indonesia Keilmuan', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6310', 'nama_mata_kuliah': 'Pemrograman Berorientasi Objek', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6311', 'nama_mata_kuliah': 'Jaringan Komputer', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6312', 'nama_mata_kuliah': 'Rekayasa Perangkat Lunak', 'sks': 4, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          {'kode_mata_kuliah': 'PTI6313', 'nama_mata_kuliah': 'Statistika dan Probabilitas', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6314', 'nama_mata_kuliah': 'Sistem Berkas & Pengolahan Data', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6315', 'nama_mata_kuliah': 'Interaksi Manusia & Komputer', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'MKW6206', 'nama_mata_kuliah': 'Sosio-Antropologi Pendidikan', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6316', 'nama_mata_kuliah': 'Pemrograman Web Dinamis', 'sks': 4, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          {'kode_mata_kuliah': 'PTI6317', 'nama_mata_kuliah': 'Analisis dan Perancangan Sistem', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6318', 'nama_mata_kuliah': 'Kecerdasan Buatan (AI)', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          {'kode_mata_kuliah': 'PTI6319', 'nama_mata_kuliah': 'Keamanan Informasi & Jaringan', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6320', 'nama_mata_kuliah': 'Sistem Informasi Manajemen', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6321', 'nama_mata_kuliah': 'Metodologi Penelitian TI', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'MKW6207', 'nama_mata_kuliah': 'Perkembangan Peserta Didik', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          {'kode_mata_kuliah': 'PTI6322', 'nama_mata_kuliah': 'Pemrograman Perangkat Bergerak (Mobile)', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6323', 'nama_mata_kuliah': 'Administrasi Sistem Jaringan', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6324', 'nama_mata_kuliah': 'Grafika Komputer', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6325', 'nama_mata_kuliah': 'Manajemen Proyek Teknologi Informasi', 'sks': 3, 'nilai_angka': 3.50, 'nilai_huruf': 'B+'},
          {'kode_mata_kuliah': 'PTI6326', 'nama_mata_kuliah': 'Kriptografi Dasar', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6327', 'nama_mata_kuliah': 'Teknologi Cloud Computing', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'MKW6208', 'nama_mata_kuliah': 'Filsafat Pendidikan', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6328', 'nama_mata_kuliah': 'Proyek Perangkat Lunak Terintegrasi', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6329', 'nama_mata_kuliah': 'Data Science & Big Data', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6330', 'nama_mata_kuliah': 'Internet of Things (IoT)', 'sks': 3, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'PTI6331', 'nama_mata_kuliah': 'Etika Profesi dan Hukum IT', 'sks': 2, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
          {'kode_mata_kuliah': 'MKW6209', 'nama_mata_kuliah': 'Kewirausahaan Mahasiswa', 'sks': 4, 'nilai_angka': 4.00, 'nilai_huruf': 'A'},
        ]
      }
    };
  }
}
