import '../../data/models/ticket_model.dart';

abstract class TicketState {}

class TicketInitial extends TicketState {}

// List of tickets states
class TicketsLoadInProgress extends TicketState {}

class TicketsLoadSuccess extends TicketState {
  final List<TicketModel> tickets;
  TicketsLoadSuccess(this.tickets);
}

class TicketsLoadFailure extends TicketState {
  final String errorMessage;
  TicketsLoadFailure(this.errorMessage);
}

// Detail of ticket states
class TicketDetailLoadInProgress extends TicketState {}

class TicketDetailLoadSuccess extends TicketState {
  final TicketModel ticket;
  TicketDetailLoadSuccess(this.ticket);
}

class TicketDetailLoadFailure extends TicketState {
  final String errorMessage;
  TicketDetailLoadFailure(this.errorMessage);
}

// Create ticket states
class TicketCreateInProgress extends TicketState {}

class TicketCreateSuccess extends TicketState {
  final TicketModel ticket;
  TicketCreateSuccess(this.ticket);
}

class TicketCreateFailure extends TicketState {
  final String errorMessage;
  TicketCreateFailure(this.errorMessage);
}

// Reply ticket states
class TicketReplySendInProgress extends TicketState {}

class TicketReplySendSuccess extends TicketState {
  final TicketReplyModel reply;
  TicketReplySendSuccess(this.reply);
}

class TicketReplySendFailure extends TicketState {
  final String errorMessage;
  TicketReplySendFailure(this.errorMessage);
}
