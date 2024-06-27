part of 'department_bloc.dart';

sealed class DepartmentEvent extends Equatable {
  const DepartmentEvent();

  @override
  List<Object> get props => [];
}

class DepartmentLoadedEvent extends DepartmentEvent {
  final String idCompany;
  final Map<String, dynamic> lastData;

  const DepartmentLoadedEvent(
      {required this.idCompany, required this.lastData});

  @override
  List<Object> get props => [idCompany, lastData];
}


class DepartmentDeleteEvent extends DepartmentEvent {
  final String id;

  const DepartmentDeleteEvent({required this.id});

  @override
  List<Object> get props => [id];
}

// Create Department
sealed class CreateDepartmentEvent extends Equatable {
  const CreateDepartmentEvent();

  @override
  List<Object> get props => [];
}

class CreateDepartmentInitialEvent extends CreateDepartmentEvent {}

class CreateDepartmentLoadingEvent extends CreateDepartmentEvent {}

class CreateDepartmentAddedEvent extends CreateDepartmentEvent {
  final DepartmentModel departmentData;
  final AccountModel accountData;
  const CreateDepartmentAddedEvent(
      {required this.departmentData, required this.accountData});

  @override
  List<Object> get props => [departmentData, accountData];
}

class CreateDepartmentChangedEvent extends CreateDepartmentEvent {
  final DepartmentModel departmentData;
  final bool isUpdate;
  const CreateDepartmentChangedEvent(
      {required this.departmentData, required this.isUpdate});

  @override
  List<Object> get props => [departmentData, isUpdate];
}

class CreateEmplyeeErrorEvent extends CreateDepartmentEvent {
  final String message;
  const CreateEmplyeeErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateDepartmentByIdEvent extends CreateDepartmentEvent {
  final String id;

  const CreateDepartmentByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}
