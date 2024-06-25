import 'package:attend_smart_admin/models/department_model.dart';
import 'package:attend_smart_admin/repository/department/department_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'department_event.dart';
part 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  DepartmentRepository? departmentRepository;
  DepartmentBloc(this.departmentRepository) : super(DepartmentInitialState()) {
    on<DepartmentLoadedEvent>((event, emit) async {
      var result = await departmentRepository?.getDepartment();
      if (result.runtimeType == List<DepartmentModel>) {
        emit(DepartmentLoadedState(listDepartments: result));
      } else {
        emit(DepartmentErrorState(message: result));
      }
    });
  }
}
