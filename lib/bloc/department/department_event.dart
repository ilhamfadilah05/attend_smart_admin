part of 'department_bloc.dart';

sealed class DepartmentEvent extends Equatable {
  const DepartmentEvent();

  @override
  List<Object> get props => [];
}

class DepartmentLoadedEvent extends DepartmentEvent {
  const DepartmentLoadedEvent();

  @override
  List<Object> get props => [];
}
