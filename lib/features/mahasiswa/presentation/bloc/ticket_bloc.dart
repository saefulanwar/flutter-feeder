import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/mahasiswa_repository_impl.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final MahasiswaRepositoryImpl _repository;

  TicketBloc(this._repository) : super(TicketInitial()) {
    on<FetchTicketsRequested>((event, emit) async {
      emit(TicketsLoadInProgress());
      final result = await _repository.getTickets();
      result.fold(
        (failure) => emit(TicketsLoadFailure(failure)),
        (tickets) => emit(TicketsLoadSuccess(tickets)),
      );
    });

    on<FetchTicketDetailRequested>((event, emit) async {
      emit(TicketDetailLoadInProgress());
      final result = await _repository.getTicketDetail(event.ticketId);
      result.fold(
        (failure) => emit(TicketDetailLoadFailure(failure)),
        (ticket) => emit(TicketDetailLoadSuccess(ticket)),
      );
    });

    on<CreateTicketRequested>((event, emit) async {
      emit(TicketCreateInProgress());
      final result = await _repository.createTicket(
        kategori: event.kategori,
        judul: event.judul,
        deskripsi: event.deskripsi,
        fileBytes: event.fileBytes,
        fileName: event.fileName,
      );
      result.fold(
        (failure) => emit(TicketCreateFailure(failure)),
        (ticket) => emit(TicketCreateSuccess(ticket)),
      );
    });

    on<SendTicketReplyRequested>((event, emit) async {
      emit(TicketReplySendInProgress());
      final result = await _repository.createTicketReply(
        ticketId: event.ticketId,
        pesan: event.pesan,
        fileBytes: event.fileBytes,
        fileName: event.fileName,
      );
      result.fold(
        (failure) => emit(TicketReplySendFailure(failure)),
        (reply) => emit(TicketReplySendSuccess(reply)),
      );
    });
  }
}
