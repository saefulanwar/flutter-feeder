class TicketModel {
  final int id;
  final String nim;
  final String? idProdi;
  final String kategori;
  final String judul;
  final String deskripsi;
  final String status;
  final String? lampiran;
  final String createdAt;
  final String updatedAt;
  final List<TicketReplyModel> replies;

  TicketModel({
    required this.id,
    required this.nim,
    this.idProdi,
    required this.kategori,
    required this.judul,
    required this.deskripsi,
    required this.status,
    this.lampiran,
    required this.createdAt,
    required this.updatedAt,
    this.replies = const [],
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    var list = json['replies'] as List?;
    List<TicketReplyModel> repliesList = list != null
        ? list.map((e) => TicketReplyModel.fromJson(e as Map<String, dynamic>)).toList()
        : [];

    return TicketModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nim: json['nim'] ?? '',
      idProdi: json['id_prodi']?.toString(),
      kategori: json['kategori'] ?? '',
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      status: json['status'] ?? 'open',
      lampiran: json['lampiran'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      replies: repliesList,
    );
  }
}

class TicketReplyModel {
  final int id;
  final int ticketId;
  final String senderType;
  final int? userId;
  final String pesan;
  final String? lampiran;
  final String createdAt;
  final String updatedAt;
  final AdminUserModel? user;

  TicketReplyModel({
    required this.id,
    required this.ticketId,
    required this.senderType,
    this.userId,
    required this.pesan,
    this.lampiran,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory TicketReplyModel.fromJson(Map<String, dynamic> json) {
    return TicketReplyModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      ticketId: json['ticket_id'] is int ? json['ticket_id'] : int.tryParse(json['ticket_id'].toString()) ?? 0,
      senderType: json['sender_type'] ?? '',
      userId: json['user_id'] is int ? json['user_id'] : (json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null),
      pesan: json['pesan'] ?? '',
      lampiran: json['lampiran'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: json['user'] != null ? AdminUserModel.fromJson(json['user'] as Map<String, dynamic>) : null,
    );
  }
}

class AdminUserModel {
  final int id;
  final String name;
  final String? email;

  AdminUserModel({
    required this.id,
    required this.name,
    this.email,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? json['nama'] ?? 'Admin',
      email: json['email'],
    );
  }
}
