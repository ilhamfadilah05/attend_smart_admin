part of 'branch_bloc.dart';

sealed class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object> get props => [];
}

final class BranchLoadingState extends BranchState {}

final class BranchLoadedState extends BranchState {
  final List listBranch;
  final List listInitialBranch;
  final int page;
  final int limit;
  final int lengthData;

  const BranchLoadedState(
      {required this.listBranch,
      required this.listInitialBranch,
      required this.page,
      required this.limit,
      required this.lengthData});

  @override
  List<Object> get props =>
      [listBranch, page, limit, lengthData, listInitialBranch];
}

final class BranchEmptyState extends BranchState {}

final class BranchErrorState extends BranchState {
  final String message;

  const BranchErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class BranchDeleteSuccessState extends BranchState {}

final class BranchDeleteErrorState extends BranchState {
  final String message;

  const BranchDeleteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
// Create Branch State

class CreateBranchState extends Equatable {
  final BranchModel? branch;
  final FormSubmissionStatus formStatus;
  final String errorMessage;
  final bool isUpdate;

  const CreateBranchState(
      {this.branch,
      this.errorMessage = '',
      this.isUpdate = false,
      this.formStatus = const InitialFormStatus()});

  CreateBranchState copyWith({
    BranchModel? branch,
    String? errorMessage,
    bool? isUpdate,
    FormSubmissionStatus? formStatus,
  }) {
    return CreateBranchState(
      branch: branch ?? branch,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdate: isUpdate ?? this.isUpdate,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [branch, errorMessage, isUpdate, formStatus];
}

final class CreateBranchErrorState extends CreateBranchState {
  final String message;

  const CreateBranchErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateBranchInitialState extends CreateBranchState {}

final class CreateBranchLoadingState extends CreateBranchState {}

final class CreateBranchSuccessState extends CreateBranchState {
  final bool isUpdateBranch;

  const CreateBranchSuccessState({required this.isUpdateBranch});

  @override
  List<Object> get props => [isUpdateBranch];
}

final class CreateEmployeByIdSuccessState extends CreateBranchState {}
