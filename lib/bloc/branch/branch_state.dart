part of 'branch_bloc.dart';

sealed class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object> get props => [];
}

final class BranchInitialState extends BranchState {}

final class BranchLoadingState extends BranchState {}

final class BranchLoadedtate extends BranchState {
  final List<BranchModel> listBranch;

  const BranchLoadedtate({required this.listBranch});

  @override
  List<Object> get props => [listBranch];
}

final class BranchErrorState extends BranchState {
  final String message;

  const BranchErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
