import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
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
          var randomString = getRandomString(10);
          var employeeData = state.employee;

          employeeData?.nameCompany = event.accountData.nameCompany;
          employeeData?.idCompany = event.accountData.idCompany;

          var isUpdateEmployee = true;

          if (employeeData?.id == null) {
            employeeData?.id =
                'employee_${event.accountData.idCompany}_$randomString';
            isUpdateEmployee = false;
          }

          var result =
              await employeeRepo.addEmployee(employee: state.employee!);

          if (result.runtimeType == String) {
            emit(CreateEmployeeErrorState(message: state.errorMessage));
          } else {
            emit(
                CreateEmployeeSuccessState(isUpdateEmployee: isUpdateEmployee));
          }
        } catch (e) {
          emit(CreateEmployeeErrorState(message: e.toString()));
        }
      }
    });

    on<CreateEmployeeByIdEvent>((event, emit) async {
      var result = await employeeRepo.getEmployeeById(id: event.id);
      if (result.runtimeType == String) {
        emit(CreateEmployeeErrorState(message: result));
      } else {
        emit(state.copyWith(employee: EmployeeModel.fromJson(result)));
      }
    });
  }
}
