part of 'broadcast_bloc.dart';

sealed class BroadcastEvent extends Equatable {
  const BroadcastEvent();

  @override
  List<Object> get props => [];
}

class BroadcastLoadingEvent extends BroadcastEvent {}

class BroadcastLoadedEvent extends BroadcastEvent {
  final String idCompany;
  final int page;
  final int limit;

  const BroadcastLoadedEvent(
      {required this.idCompany, required this.page, required this.limit});

  @override
  List<Object> get props => [idCompany, page, limit];
}

class BroadcastDeleteEvent extends BroadcastEvent {
  final BroadcastModel dataBroadcast;

  const BroadcastDeleteEvent({required this.dataBroadcast});

  @override
  List<Object> get props => [dataBroadcast];
}

// Create Broadcast Event

sealed class CreateBroadcastEvent extends Equatable {
  const CreateBroadcastEvent();

  @override
  List<Object> get props => [];
}

class CreateBroadcastInitialEvent extends CreateBroadcastEvent {}

class CreateBroadcastLoadingEvent extends CreateBroadcastEvent {}

class CreateBroadcastAddedEvent extends CreateBroadcastEvent {
  final BroadcastModel broadcastData;
  final AccountModel accountData;
  const CreateBroadcastAddedEvent({
    required this.broadcastData,
    required this.accountData,
  });

  @override
  List<Object> get props => [broadcastData, accountData];
}

class CreateBroadcastChangedEvent extends CreateBroadcastEvent {
  final BroadcastModel broadcastData;
  final bool isUpdate;
  const CreateBroadcastChangedEvent(
      {required this.broadcastData, required this.isUpdate});

  @override
  List<Object> get props => [broadcastData, isUpdate];
}

class CreateEmplyeeErrorEvent extends CreateBroadcastEvent {
  final String message;
  const CreateEmplyeeErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateBroadcastByIdEvent extends CreateBroadcastEvent {
  final String id;

  const CreateBroadcastByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}
