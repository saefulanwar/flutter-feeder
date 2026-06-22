class HistoryPendidikan {
  final String nim;
  final String namaMahasiswa;
  final String namaPerguruanTinggi;
  final String programStudi;
  final String jenisPendaftaran;
  final String tanggalDaftar;
  final String jenjangPendidikan;

  HistoryPendidikan({
    required this.nim,
    required this.namaMahasiswa,
    required this.namaPerguruanTinggi,
    required this.programStudi,
    required this.jenisPendaftaran,
    required this.tanggalDaftar,
    required this.jenjangPendidikan,
  });

  factory HistoryPendidikan.fromJson(Map<String, dynamic> json) {
    return HistoryPendidikan(
      nim: json['nim'] ?? '',
      namaMahasiswa: json['nama_mahasiswa'] ?? '',
      namaPerguruanTinggi: json['nama_perguruan_tinggi'] ?? '',
      programStudi: json['nama_program_studi'] ?? '',
      jenisPendaftaran: json['jalur_pendaftaran'] ?? json['jenis_pendaftaran'] ?? '',
      tanggalDaftar: json['tanggal_daftar'] ?? '',
      jenjangPendidikan: json['jenjang_pendidikan'] ?? 'S1',
    );
  }
}

class CourseGrade {
  final String kodeMatakuliah;
  final String namaMatakuliah;
  final int sks;
  final double nilaiAngka;
  final String nilaiHuruf;

  CourseGrade({
    required this.kodeMatakuliah,
    required this.namaMatakuliah,
    required this.sks,
    required this.nilaiAngka,
    required this.nilaiHuruf,
  });

  factory CourseGrade.fromJson(Map<String, dynamic> json) {
    return CourseGrade(
      kodeMatakuliah: json['kode_mata_kuliah'] ?? '',
      namaMatakuliah: json['nama_mata_kuliah'] ?? '',
      sks: json['sks'] is int ? json['sks'] : (json['sks'] != null ? int.tryParse(json['sks'].toString()) ?? 0 : 0),
      nilaiAngka: json['nilai_angka'] is num ? (json['nilai_angka'] as num).toDouble() : (json['nilai_angka'] != null ? double.tryParse(json['nilai_angka'].toString()) ?? 0.0 : 0.0),
      nilaiHuruf: json['nilai_huruf'] ?? '',
    );
  }
}

class SemesterGrades {
  final String semesterNama;
  final double ips;
  final int sksSemester;
  final List<CourseGrade> listNilai;

  SemesterGrades({
    required this.semesterNama,
    required this.ips,
    required this.sksSemester,
    required this.listNilai,
  });

  factory SemesterGrades.fromJson(Map<String, dynamic> json) {
    var list = json['list_nilai'] as List?;
    List<CourseGrade> grades = list != null
        ? list.map((i) => CourseGrade.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return SemesterGrades(
      semesterNama: json['semester_nama'] ?? '',
      ips: json['ips'] is num ? (json['ips'] as num).toDouble() : 0.0,
      sksSemester: json['sks_semester'] is int ? json['sks_semester'] : 0,
      listNilai: grades,
    );
  }

  static List<SemesterGrades> fromFlatJsonList(List<dynamic> list) {
    final Map<String, List<dynamic>> grouped = {};

    for (var item in list) {
      if (item is! Map<String, dynamic>) continue;
      final kelasKuliah = item['kelaskuliah'] as Map<String, dynamic>?;
      final idSemester = kelasKuliah?['id_semester']?.toString() ?? 'unknown';
      grouped.putIfAbsent(idSemester, () => []).add(item);
    }

    final sortedKeys = grouped.keys.toList()..sort();
    final List<SemesterGrades> result = [];

    for (var idSemester in sortedKeys) {
      final items = grouped[idSemester]!;
      if (items.isEmpty) continue;

      final firstItem = items.first;
      final kelasKuliah = firstItem['kelaskuliah'] as Map<String, dynamic>?;
      final semester = kelasKuliah?['semester'] as Map<String, dynamic>?;

      String semesterNama = '';
      if (semester != null && semester['nama_semester'] != null) {
        final name = semester['nama_semester'].toString();
        semesterNama = name.contains('Semester') ? name : 'Semester $name';
      } else {
        semesterNama = _formatSemesterId(idSemester);
      }

      final List<CourseGrade> listNilai = [];
      for (var item in items) {
        final kk = item['kelaskuliah'] as Map<String, dynamic>?;
        final mk = kk?['matakuliah'] as Map<String, dynamic>?;

        final rawSks = kk?['sks_mk'] ?? mk?['sks_mata_kuliah'] ?? 0;
        final int sks = rawSks is int ? rawSks : (double.tryParse(rawSks.toString())?.toInt() ?? 0);

        final rawIndeks = item['nilai_indeks'] ?? 0.0;
        final double indeks = rawIndeks is num ? rawIndeks.toDouble() : (double.tryParse(rawIndeks.toString()) ?? 0.0);

        final String gradeHuruf = item['nilai_huruf'] ?? '';

        listNilai.add(CourseGrade(
          kodeMatakuliah: mk?['kode_mata_kuliah'] ?? '',
          namaMatakuliah: mk?['nama_mata_kuliah'] ?? '',
          sks: sks,
          nilaiAngka: indeks,
          nilaiHuruf: gradeHuruf,
        ));
      }

      int totalSks = 0;
      double totalBobot = 0.0;
      int sksSemester = 0;

      for (var course in listNilai) {
        sksSemester += course.sks;
        if (course.nilaiHuruf.isNotEmpty) {
          totalSks += course.sks;
          totalBobot += (course.sks * course.nilaiAngka);
        }
      }

      double ips = totalSks > 0 ? (totalBobot / totalSks) : 0.0;

      result.add(SemesterGrades(
        semesterNama: semesterNama,
        ips: double.parse(ips.toStringAsFixed(2)),
        sksSemester: sksSemester,
        listNilai: listNilai,
      ));
    }

    return result;
  }

  static String _formatSemesterId(String id) {
    if (id.length >= 5) {
      final yearStr = id.substring(0, 4);
      final termStr = id.substring(4, 5);
      final year = int.tryParse(yearStr) ?? 0;
      if (year > 0) {
        final nextYear = year + 1;
        String term = 'Lainnya';
        if (termStr == '1') {
          term = 'Ganjil';
        } else if (termStr == '2') {
          term = 'Genap';
        } else if (termStr == '3') {
          term = 'Pendek';
        }
        return 'Semester $year/$nextYear $term';
      }
    }
    return id;
  }
}

class TranskripItem {
  final String kodeMatakuliah;
  final String namaMatakuliah;
  final int sks;
  final String nilaiHuruf;
  final double nilaiAngka;

  TranskripItem({
    required this.kodeMatakuliah,
    required this.namaMatakuliah,
    required this.sks,
    required this.nilaiHuruf,
    required this.nilaiAngka,
  });

  factory TranskripItem.fromJson(Map<String, dynamic> json) {
    return TranskripItem(
      kodeMatakuliah: json['kode_mata_kuliah'] ?? '',
      namaMatakuliah: json['nama_mata_kuliah'] ?? '',
      sks: json['sks'] is int ? json['sks'] : (json['sks'] != null ? int.tryParse(json['sks'].toString()) ?? 0 : 0),
      nilaiHuruf: json['nilai_huruf'] ?? '',
      nilaiAngka: json['nilai_angka'] is num ? (json['nilai_angka'] as num).toDouble() : (json['nilai_angka'] != null ? double.tryParse(json['nilai_angka'].toString()) ?? 0.0 : 0.0),
    );
  }
}

class Transkrip {
  final double ipk;
  final int totalSks;
  final List<TranskripItem> listTranskrip;

  Transkrip({
    required this.ipk,
    required this.totalSks,
    required this.listTranskrip,
  });

  factory Transkrip.fromJson(Map<String, dynamic> json) {
    var list = (json['transkrip'] ?? json['list_transkrip']) as List?;
    List<TranskripItem> items = list != null
        ? list.map((i) => TranskripItem.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return Transkrip(
      ipk: json['ipk'] is num ? (json['ipk'] as num).toDouble() : (json['ipk'] != null ? double.tryParse(json['ipk'].toString()) ?? 0.0 : 0.0),
      totalSks: json['total_sks'] is num ? (json['total_sks'] as num).toInt() : (json['total_sks'] != null ? int.tryParse(json['total_sks'].toString()) ?? 0 : 0),
      listTranskrip: items,
    );
  }
}
