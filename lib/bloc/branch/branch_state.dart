// part of 'branch_bloc.dart';

// sealed class BranchState extends Equatable {
//   const BranchState();

//   @override
//   List<Object> get props => [];
// }

// final class BranchInitialState extends BranchState {}

// final class BranchLoadingState extends BranchState {}

// final class BranchLoadedtate extends BranchState {
//   final List<BranchModel> listBranch;

//   const BranchLoadedtate({required this.listBranch});

//   @override
//   List<Object> get props => [listBranch];
// }

// final class BranchErrorState extends BranchState {
//   final String message;

//   const BranchErrorState({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// ignore_for_file: must_be_immutable

part of 'branch_bloc.dart';

sealed class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object> get props => [];
}

final class BranchInitialState extends BranchState {}

final class BranchLoadingState extends BranchState {}

final class BranchLoadedState extends BranchState {
  final List<BranchModel> listBranch;
  const BranchLoadedState({
    required this.listBranch,
  });

  @override
  List<Object> get props => [listBranch];
}

final class BranchErrorState extends BranchState {
  final String message;
  const BranchErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class BranchEmptyState extends BranchState {}

final class BranchDeleteSuccessState extends BranchState {}

final class BranchDeleteErrorState extends BranchState {
  final String message;

  const BranchDeleteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// Create Branch

class CreateBranchState extends Equatable {
  final BranchModel? branch;

  final String errorMessage;
  final bool isUpdate;

  const CreateBranchState(
      {this.branch, this.errorMessage = '', this.isUpdate = false});

  CreateBranchState copyWith({
    BranchModel? branch,
    String? errorMessage,
    bool? isUpdate,
  }) {
    return CreateBranchState(
      branch: branch ?? branch,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdate: isUpdate ?? this.isUpdate,
    );
  }

  @override
  List<Object?> get props => [branch, errorMessage];
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
