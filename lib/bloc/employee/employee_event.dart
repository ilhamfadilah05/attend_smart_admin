part of 'employee_bloc.dart';

sealed class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class EmployeeLoadingEvent extends EmployeeEvent {}

class EmployeeLoadedEvent extends EmployeeEvent {
  final int startData;
  final int lastData;

  const EmployeeLoadedEvent({required this.startData, required this.lastData});

  @override
  List<Object> get props => [startData, lastData];
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
  const CreateEmployeeAddedEvent({required this.employeeData});

  @override
  List<Object> get props => [employeeData];
}

class CreateEmployeeChangedEvent extends CreateEmployeeEvent {
  final EmployeeModel employeeData;
  const CreateEmployeeChangedEvent({required this.employeeData});

  @override
  List<Object> get props => [employeeData];
}

class CreateEmplyeeErrorEvent extends CreateEmployeeEvent {
  final String message;
  const CreateEmplyeeErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}
