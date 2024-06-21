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

  final FormSubmissionStatus formStatus;
  final String errorMessage;

  const CreateEmployeeState({
    this.employee,
    this.formStatus = const InitialFormStatus(),
    this.errorMessage = '',
  });

  CreateEmployeeState copyWith({
    EmployeeModel? employee,
    FormSubmissionStatus? formStatus,
    String? errorMessage,
  }) {
    return CreateEmployeeState(
      employee: employee ?? employee,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [employee, formStatus, errorMessage];
}

final class CreateEmployeeInitialState extends CreateEmployeeState {}
