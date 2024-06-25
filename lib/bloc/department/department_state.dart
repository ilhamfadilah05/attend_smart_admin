part of 'department_bloc.dart';

sealed class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object> get props => [];
}

final class DepartmentInitialState extends DepartmentState {}

final class DepartmentLoadingState extends DepartmentState {}

final class DepartmentLoadedState extends DepartmentState {
  final List<DepartmentModel> listDepartments;
  const DepartmentLoadedState({required this.listDepartments});

  @override
  List<Object> get props => [listDepartments];
}

final class DepartmentErrorState extends DepartmentState {
  final String message;
  const DepartmentErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class DepartmentEmptyState extends DepartmentState {}
