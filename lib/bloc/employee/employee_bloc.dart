import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:attend_smart_admin/repository/employee/employee_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository employeeRepo;
  EmployeeBloc(this.employeeRepo) : super(EmployeeLoadingState()) {
    on<EmployeeLoadedEvent>((event, emit) async {
      final result = await employeeRepo.getEmployee();

      if (result.length == 0) {
        emit(EmployeeEmptyState());
      } else {
        emit(EmployeeLoadedState(listEmployee: result));
      }
    });
  }
}

//Create Employee

class CreateEmployeeBloc
    extends Bloc<CreateEmployeeEvent, CreateEmployeeState> {
  final EmployeeRepository employeeRepo;
  CreateEmployeeBloc(this.employeeRepo) : super(CreateEmployeeInitialState()) {
    on<CreateEmployeeEvent>((event, emit) async {
      if (event is CreateEmployeeChangedEvent) {
        emit(state.copyWith(
          employee: event.employeeData,
        ));
      } else if (event is CreateEmployeeAddedEvent) {
        try {
          var result =
              await employeeRepo.addEmployee(employee: state.employee!);

          if (result.runtimeType == String) {
            emit(state.copyWith(
                errorMessage: state.errorMessage,
                formStatus: SubmissionFailed()));
          } else {
            emit(state.copyWith(
                employee: state.employee, formStatus: SubmissionSuccess()));
          }
        } catch (e) {
          emit(state.copyWith(
              errorMessage: e.toString(), formStatus: SubmissionFailed()));
        }
      }
    });
  }
}
