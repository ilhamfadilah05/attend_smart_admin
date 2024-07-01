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

final class EmployeeDeleteSuccessState extends EmployeeState {}

final class EmployeeDeleteErrorState extends EmployeeState {
  final String message;

  const EmployeeDeleteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// Create Employee State

class CreateEmployeeState extends Equatable {
  final EmployeeModel? employee;
  final FormSubmissionStatus formStatus;
  final String errorMessage;
  final bool isUpdate;

  const CreateEmployeeState(
      {this.employee,
      this.errorMessage = '',
      this.isUpdate = false,
      this.formStatus = const InitialFormStatus()});

  CreateEmployeeState copyWith({
    EmployeeModel? employee,
    String? errorMessage,
    bool? isUpdate,
    FormSubmissionStatus? formStatus,
  }) {
    return CreateEmployeeState(
      employee: employee ?? employee,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdate: isUpdate ?? this.isUpdate,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [employee, errorMessage, isUpdate, formStatus];
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

final class CreateEmployeByIdSuccessState extends CreateEmployeeState {}
