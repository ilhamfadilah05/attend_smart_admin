part of 'submission_bloc.dart';

sealed class SubmissionState extends Equatable {
  const SubmissionState();

  @override
  List<Object> get props => [];
}

final class SubmissionLoadingState extends SubmissionState {}

final class SubmissionLoadedState extends SubmissionState {
  final List listSubmission;
  final List listInitialSubmission;
  final int page;
  final int limit;
  final int lengthData;

  const SubmissionLoadedState(
      {required this.listSubmission,
      required this.listInitialSubmission,
      required this.page,
      required this.limit,
      required this.lengthData});

  @override
  List<Object> get props =>
      [listSubmission, page, limit, lengthData, listInitialSubmission];
}

final class SubmissionEmptyState extends SubmissionState {}

final class SubmissionErrorState extends SubmissionState {
  final String message;

  const SubmissionErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class SubmissionDeleteSuccessState extends SubmissionState {}

final class SubmissionDeleteErrorState extends SubmissionState {
  final String message;

  const SubmissionDeleteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// Create Submission State

class CreateSubmissionState extends Equatable {
  final SubmissionModel? submission;
  final FormSubmissionStatus formStatus;
  final String errorMessage;
  final bool isUpdate;

  const CreateSubmissionState(
      {this.submission,
      this.errorMessage = '',
      this.isUpdate = false,
      this.formStatus = const InitialFormStatus()});

  CreateSubmissionState copyWith({
    SubmissionModel? submission,
    String? errorMessage,
    bool? isUpdate,
    FormSubmissionStatus? formStatus,
  }) {
    return CreateSubmissionState(
      submission: submission ?? submission,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdate: isUpdate ?? this.isUpdate,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [submission, errorMessage, isUpdate, formStatus];
}

final class CreateSubmissionErrorState extends CreateSubmissionState {
  final String message;

  const CreateSubmissionErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateSubmissionInitialState extends CreateSubmissionState {}

final class CreateSubmissionLoadingState extends CreateSubmissionState {}

final class CreateSubmissionSuccessState extends CreateSubmissionState {
  final bool isUpdateSubmission;

  const CreateSubmissionSuccessState({required this.isUpdateSubmission});

  @override
  List<Object> get props => [isUpdateSubmission];
}

final class CreateEmployeByIdSuccessState extends CreateSubmissionState {}
