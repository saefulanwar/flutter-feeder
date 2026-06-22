abstract class TicketEvent {}

class FetchTicketsRequested extends TicketEvent {}

class FetchTicketDetailRequested extends TicketEvent {
  final int ticketId;
  FetchTicketDetailRequested(this.ticketId);
}

class CreateTicketRequested extends TicketEvent {
  final String kategori;
  final String judul;
  final String deskripsi;
  final List<int>? fileBytes;
  final String? fileName;

  CreateTicketRequested({
    required this.kategori,
    required this.judul,
    required this.deskripsi,
    this.fileBytes,
    this.fileName,
  });
}

class SendTicketReplyRequested extends TicketEvent {
  final int ticketId;
  final String pesan;
  final List<int>? fileBytes;
  final String? fileName;

  SendTicketReplyRequested({
    required this.ticketId,
    required this.pesan,
    this.fileBytes,
    this.fileName,
  });
}
