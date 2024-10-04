part of 'submission_bloc.dart';

sealed class SubmissionEvent extends Equatable {
  const SubmissionEvent();

  @override
  List<Object> get props => [];
}

class SubmissionLoadingEvent extends SubmissionEvent {}

class SubmissionLoadedEvent extends SubmissionEvent {
  final String idCompany;
  final int page;
  final int limit;

  const SubmissionLoadedEvent(
      {required this.idCompany, required this.page, required this.limit});

  @override
  List<Object> get props => [idCompany, page, limit];
}

class SubmissionDeleteEvent extends SubmissionEvent {
  final String id;

  const SubmissionDeleteEvent({required this.id});

  @override
  List<Object> get props => [id];
}

// Create Submission Event

sealed class CreateSubmissionEvent extends Equatable {
  const CreateSubmissionEvent();

  @override
  List<Object> get props => [];
}

class CreateSubmissionInitialEvent extends CreateSubmissionEvent {}

class CreateSubmissionLoadingEvent extends CreateSubmissionEvent {}

class CreateSubmissionAddedEvent extends CreateSubmissionEvent {
  final SubmissionModel submissionData;
  final AccountModel accountData;
  const CreateSubmissionAddedEvent(
      {required this.submissionData, required this.accountData});

  @override
  List<Object> get props => [submissionData, accountData];
}

class CreateSubmissionChangedEvent extends CreateSubmissionEvent {
  final SubmissionModel submissionData;
  final bool isUpdate;
  const CreateSubmissionChangedEvent(
      {required this.submissionData, required this.isUpdate});

  @override
  List<Object> get props => [submissionData, isUpdate];
}

class CreateEmplyeeErrorEvent extends CreateSubmissionEvent {
  final String message;
  const CreateEmplyeeErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateSubmissionByIdEvent extends CreateSubmissionEvent {
  final String id;

  const CreateSubmissionByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}
