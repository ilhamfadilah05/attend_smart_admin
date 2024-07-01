part of 'history_attend_bloc.dart';

sealed class HistoryAttendEvent extends Equatable {
  const HistoryAttendEvent();

  @override
  List<Object> get props => [];
}

class HistoryAttendLoadedEvent extends HistoryAttendEvent {
  final String idCompany;

  const HistoryAttendLoadedEvent({
    required this.idCompany,
  });

  @override
  List<Object> get props => [idCompany];
}

class HistoryAttendDeleteEvent extends HistoryAttendEvent {
  final String id;

  const HistoryAttendDeleteEvent({required this.id});

  @override
  List<Object> get props => [id];
}

// Create HistoryAttend
sealed class CreateHistoryAttendEvent extends Equatable {
  const CreateHistoryAttendEvent();

  @override
  List<Object> get props => [];
}

class CreateHistoryAttendInitialEvent extends CreateHistoryAttendEvent {}

class CreateHistoryAttendLoadingEvent extends CreateHistoryAttendEvent {}

class CreateHistoryAttendAddedEvent extends CreateHistoryAttendEvent {
  final HistoryAttendModel historyAttendData;
  final AccountModel accountData;
  const CreateHistoryAttendAddedEvent(
      {required this.historyAttendData, required this.accountData});

  @override
  List<Object> get props => [historyAttendData, accountData];
}

class CreateHistoryAttendChangedEvent extends CreateHistoryAttendEvent {
  final HistoryAttendModel historyAttendData;
  final bool isUpdate;
  const CreateHistoryAttendChangedEvent(
      {required this.historyAttendData, required this.isUpdate});

  @override
  List<Object> get props => [historyAttendData, isUpdate];
}

class CreateHistoryAttendResetEvent extends CreateHistoryAttendEvent {}

class CreateEmplyeeErrorEvent extends CreateHistoryAttendEvent {
  final String message;
  const CreateEmplyeeErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateHistoryAttendByIdEvent extends CreateHistoryAttendEvent {
  final String id;

  const CreateHistoryAttendByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}
