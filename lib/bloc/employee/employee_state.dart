part of 'employee_bloc.dart';

sealed class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

final class EmployeeLoadingState extends EmployeeState {}

final class EmployeeLoadedState extends EmployeeState {
  final List<EmployeeModel> listEmployee;

  const EmployeeLoadedState({required this.listEmployee});

  @override
  List<Object> get props => [listEmployee];
}

final class EmployeeEmptyState extends EmployeeState {}

final class EmployeeErrorState extends EmployeeState {
  final String message;

  const EmployeeErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// Create Employee State

class CreateEmployeeState extends Equatable {
  final EmployeeModel? employee;

  final String errorMessage;

  const CreateEmployeeState({
    this.employee,
    this.errorMessage = '',
  });

  CreateEmployeeState copyWith({
    EmployeeModel? employee,
    String? errorMessage,
  }) {
    return CreateEmployeeState(
      employee: employee ?? employee,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [employee, errorMessage];
}

final class CreateEmployeeErrorState extends CreateEmployeeState {
  final String message;

  const CreateEmployeeErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateEmployeeInitialState extends CreateEmployeeState {}

final class CreateEmployeeLoadingState extends CreateEmployeeState {}

final class CreateEmployeeSuccessState extends CreateEmployeeState {
  final bool isUpdateEmployee;

  const CreateEmployeeSuccessState({required this.isUpdateEmployee});

  @override
  List<Object> get props => [isUpdateEmployee];
}
