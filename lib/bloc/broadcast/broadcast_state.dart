part of 'broadcast_bloc.dart';

sealed class BroadcastState extends Equatable {
  const BroadcastState();

  @override
  List<Object> get props => [];
}

final class BroadcastLoadingState extends BroadcastState {}

final class BroadcastLoadedState extends BroadcastState {
  final List listBroadcast;
  final List listInitialBroadcast;
  final int page;
  final int limit;
  final int lengthData;

  const BroadcastLoadedState(
      {required this.listBroadcast,
      required this.listInitialBroadcast,
      required this.page,
      required this.limit,
      required this.lengthData});

  @override
  List<Object> get props =>
      [listBroadcast, page, limit, lengthData, listInitialBroadcast];
}

final class BroadcastEmptyState extends BroadcastState {}

final class BroadcastErrorState extends BroadcastState {
  final String message;

  const BroadcastErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class BroadcastDeleteSuccessState extends BroadcastState {}

final class BroadcastDeleteErrorState extends BroadcastState {
  final String message;

  const BroadcastDeleteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// Create Broadcast State

class CreateBroadcastState extends Equatable {
  final BroadcastModel? broadcast;
  final FormSubmissionStatus formStatus;
  final String errorMessage;
  final bool isUpdate;

  const CreateBroadcastState(
      {this.broadcast,
      this.errorMessage = '',
      this.isUpdate = false,
      this.formStatus = const InitialFormStatus()});

  CreateBroadcastState copyWith({
    BroadcastModel? broadcast,
    String? errorMessage,
    bool? isUpdate,
    FormSubmissionStatus? formStatus,
  }) {
    return CreateBroadcastState(
      broadcast: broadcast ?? broadcast,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdate: isUpdate ?? this.isUpdate,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [broadcast, errorMessage, isUpdate, formStatus];
}

final class CreateBroadcastErrorState extends CreateBroadcastState {
  final String message;

  const CreateBroadcastErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateBroadcastInitialState extends CreateBroadcastState {}

final class CreateBroadcastLoadingState extends CreateBroadcastState {}

final class CreateBroadcastSuccessState extends CreateBroadcastState {
  final bool isUpdateBroadcast;

  const CreateBroadcastSuccessState({required this.isUpdateBroadcast});

  @override
  List<Object> get props => [isUpdateBroadcast];
}

final class CreateEmployeByIdSuccessState extends CreateBroadcastState {}
