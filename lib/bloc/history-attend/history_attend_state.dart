part of 'history_attend_bloc.dart';

sealed class HistoryAttendState extends Equatable {
  const HistoryAttendState();

  @override
  List<Object> get props => [];
}

final class HistoryAttendInitialState extends HistoryAttendState {}

final class HistoryAttendLoadingState extends HistoryAttendState {}

final class HistoryAttendLoadedState extends HistoryAttendState {
  final List<HistoryAttendModel> listHistoryAttend;
  const HistoryAttendLoadedState({
    required this.listHistoryAttend,
  });

  @override
  List<Object> get props => [listHistoryAttend];
}

final class HistoryAttendErrorState extends HistoryAttendState {
  final String message;
  const HistoryAttendErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class HistoryAttendEmptyState extends HistoryAttendState {}

final class HistoryAttendDeleteSuccessState extends HistoryAttendState {}

final class HistoryAttendDeleteErrorState extends HistoryAttendState {
  final String message;

  const HistoryAttendDeleteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// Create HistoryAttend

class CreateHistoryAttendState extends Equatable {
  final HistoryAttendModel? historyAttend;
  final FormSubmissionStatus formStatus;

  final String errorMessage;
  final bool isUpdate;

  const CreateHistoryAttendState(
      {this.historyAttend,
      this.errorMessage = '',
      this.isUpdate = false,
      this.formStatus = const InitialFormStatus()});

  CreateHistoryAttendState copyWith(
      {HistoryAttendModel? historyAttend,
      String? errorMessage,
      bool? isUpdate,
      FormSubmissionStatus? formStatus}) {
    return CreateHistoryAttendState(
      historyAttend: historyAttend ?? historyAttend,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdate: isUpdate ?? this.isUpdate,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props =>
      [historyAttend, errorMessage, isUpdate, formStatus];
}

abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class ChangedFormStatus extends FormSubmissionStatus {}

final class CreateHistoryAttendErrorState extends CreateHistoryAttendState {
  final String message;

  const CreateHistoryAttendErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateHistoryAttendInitialState extends CreateHistoryAttendState {}

final class CreateHistoryAttendLoadingState extends CreateHistoryAttendState {}

final class CreateHistoryAttendSuccessState extends CreateHistoryAttendState {
  final bool isUpdateHistoryAttend;

  const CreateHistoryAttendSuccessState({required this.isUpdateHistoryAttend});

  @override
  List<Object> get props => [isUpdateHistoryAttend];
}

final class CreateEmployeByIdSuccessState extends CreateHistoryAttendState {}
