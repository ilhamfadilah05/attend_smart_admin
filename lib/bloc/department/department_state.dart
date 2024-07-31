part of 'department_bloc.dart';


sealed class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object> get props => [];
}

final class DepartmentLoadingState extends DepartmentState {}

final class DepartmentLoadedState extends DepartmentState {
  final List<DepartmentModel> listDepartment;

  const DepartmentLoadedState({required this.listDepartment});

  @override
  List<Object> get props => [listDepartment];
}

final class DepartmentEmptyState extends DepartmentState {}

final class DepartmentErrorState extends DepartmentState {
  final String message;

  const DepartmentErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class DepartmentDeleteSuccessState extends DepartmentState {}

final class DepartmentDeleteErrorState extends DepartmentState {
  final String message;

  const DepartmentDeleteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// Create Department State

class CreateDepartmentState extends Equatable {
  final DepartmentModel? department;
  final FormSubmissionStatus formStatus;
  final String errorMessage;
  final bool isUpdate;

  const CreateDepartmentState(
      {this.department,
      this.errorMessage = '',
      this.isUpdate = false,
      this.formStatus = const InitialFormStatus()});

  CreateDepartmentState copyWith({
    DepartmentModel? department,
    String? errorMessage,
    bool? isUpdate,
    FormSubmissionStatus? formStatus,
  }) {
    return CreateDepartmentState(
      department: department ?? department,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdate: isUpdate ?? this.isUpdate,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [department, errorMessage, isUpdate, formStatus];
}

final class CreateDepartmentErrorState extends CreateDepartmentState {
  final String message;

  const CreateDepartmentErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateDepartmentInitialState extends CreateDepartmentState {}

final class CreateDepartmentLoadingState extends CreateDepartmentState {}

final class CreateDepartmentSuccessState extends CreateDepartmentState {
  final bool isUpdateDepartment;

  const CreateDepartmentSuccessState({required this.isUpdateDepartment});

  @override
  List<Object> get props => [isUpdateDepartment];
}

final class CreateEmployeByIdSuccessState extends CreateDepartmentState {}
