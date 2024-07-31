part of 'branch_bloc.dart';

sealed class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object> get props => [];
}

class BranchLoadingEvent extends BranchEvent {}

class BranchLoadedEvent extends BranchEvent {
  final String idCompany;

  const BranchLoadedEvent({required this.idCompany});

  @override
  List<Object> get props => [idCompany];
}

class BranchDeleteEvent extends BranchEvent {
  final String id;

  const BranchDeleteEvent({required this.id});

  @override
  List<Object> get props => [id];
}

// Create Branch Event

sealed class CreateBranchEvent extends Equatable {
  const CreateBranchEvent();

  @override
  List<Object> get props => [];
}

class CreateBranchInitialEvent extends CreateBranchEvent {}

class CreateBranchLoadingEvent extends CreateBranchEvent {}

class CreateBranchAddedEvent extends CreateBranchEvent {
  final BranchModel branchData;
  final AccountModel accountData;
  const CreateBranchAddedEvent(
      {required this.branchData, required this.accountData});

  @override
  List<Object> get props => [branchData, accountData];
}

class CreateBranchChangedEvent extends CreateBranchEvent {
  final BranchModel branchData;
  final bool isUpdate;
  const CreateBranchChangedEvent(
      {required this.branchData, required this.isUpdate});

  @override
  List<Object> get props => [branchData, isUpdate];
}

class CreateEmplyeeErrorEvent extends CreateBranchEvent {
  final String message;
  const CreateEmplyeeErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateBranchByIdEvent extends CreateBranchEvent {
  final String id;

  const CreateBranchByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}
