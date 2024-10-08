// ignore_for_file: must_be_immutable

part of 'employee_bloc.dart';

sealed class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class EmployeeLoadingEvent extends EmployeeEvent {}

class EmployeeLoadedEvent extends EmployeeEvent {
  final String idCompany;
  final int page;
  final int limit;
  String? searchName;
  String? searchDepartment;
  String? searchBranch;
  String? workingStatus;

  EmployeeLoadedEvent(
      {required this.idCompany,
      required this.page,
      required this.limit,
      this.searchName,
      this.searchDepartment,
      this.searchBranch,
      this.workingStatus});

  @override
  List<Object> get props => [
        idCompany,
        page,
        limit,
        searchName ?? '',
        searchDepartment ?? '',
        searchBranch ?? '',
        workingStatus ?? ''
      ];
}

class EmployeeDeleteEvent extends EmployeeEvent {
  final EmployeeModel dataEmployee;

  const EmployeeDeleteEvent({required this.dataEmployee});

  @override
  List<Object> get props => [dataEmployee];
}

// Create Employee Event

sealed class CreateEmployeeEvent extends Equatable {
  const CreateEmployeeEvent();

  @override
  List<Object> get props => [];
}

class CreateEmployeeInitialEvent extends CreateEmployeeEvent {}

class CreateEmployeeLoadingEvent extends CreateEmployeeEvent {}

class CreateEmployeeAddedEvent extends CreateEmployeeEvent {
  final EmployeeModel employeeData;
  final AccountModel accountData;
  const CreateEmployeeAddedEvent(
      {required this.employeeData, required this.accountData});

  @override
  List<Object> get props => [employeeData, accountData];
}

class CreateEmployeeChangedEvent extends CreateEmployeeEvent {
  final EmployeeModel employeeData;
  final bool isUpdate;
  const CreateEmployeeChangedEvent(
      {required this.employeeData, required this.isUpdate});

  @override
  List<Object> get props => [employeeData, isUpdate];
}

class CreateEmplyeeErrorEvent extends CreateEmployeeEvent {
  final String message;
  const CreateEmplyeeErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateEmployeeByIdEvent extends CreateEmployeeEvent {
  final String id;

  const CreateEmployeeByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}
