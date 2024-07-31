import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:attend_smart_admin/pages/account/account_repository.dart';
import 'package:attend_smart_admin/repository/employee/employee_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../history-attend/history_attend_bloc.dart';
part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository employeeRepo;
  EmployeeBloc(this.employeeRepo) : super(EmployeeLoadingState()) {
    on<EmployeeLoadedEvent>((event, emit) async {
      final result = await employeeRepo.getEmployee(event.idCompany);

      if (result.length == 0) {
        emit(EmployeeEmptyState());
      } else {
        emit(EmployeeLoadedState(listEmployee: result));
      }
    });

    on<EmployeeDeleteEvent>((event, emit) async {
      final result = await employeeRepo.deleteEmployee(id: event.id);
      if (result.runtimeType == String) {
        emit(EmployeeDeleteErrorState(message: result));
      } else {
        emit(EmployeeDeleteSuccessState());
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
            isUpdate: false,
            formStatus: ChangedFormStatus()));
      } else if (event is CreateEmployeeAddedEvent) {
        try {
          var randomString = getRandomString(10);
          var employeeData = state.employee;

          employeeData?.nameCompany = event.accountData.nameCompany;
          employeeData?.idCompany = event.accountData.idCompany;

          var isUpdateEmployee = true;

          var idEmployee = '';

          if (employeeData?.id == null) {
            employeeData?.id =
                'employee_${event.accountData.idCompany}_$randomString';
            isUpdateEmployee = false;
          }

          idEmployee = employeeData?.id ?? '';

          var result =
              await employeeRepo.addEmployee(employee: state.employee!);

          if (result.runtimeType == String) {
            emit(CreateEmployeeErrorState(message: state.errorMessage));
          } else {
            var accountData = AccountModel(
              id: 'account_${event.accountData.idCompany}_$randomString',
              name: event.employeeData.name,
              email:
                  '${event.employeeData.name?.replaceAll(' ', '').toLowerCase()}${getRandomString(3)}@${event.accountData.idCompany?.toLowerCase()}.com',
              password: 'MTIzNDU2Nzg=', // 12345678,
              idCompany: event.accountData.idCompany,
              idEmployee: idEmployee,
              nameCompany: event.accountData.nameCompany,
              createdAt: DateTime.now().toString(),
              role: 'employee',
            );
            AccountRepository().createAccount(accountData);
            emit(
                CreateEmployeeSuccessState(isUpdateEmployee: isUpdateEmployee));
          }
        } catch (e) {
          emit(CreateEmployeeErrorState(message: e.toString()));
        }
      }
    });

    on<CreateEmployeeInitialEvent>((event, emit) async {
      emit(state.copyWith(
          employee: EmployeeModel(),
          isUpdate: false,
          formStatus: const InitialFormStatus()));
    });

    on<CreateEmployeeByIdEvent>((event, emit) async {
      var result = await employeeRepo.getEmployeeById(id: event.id);
      if (result.runtimeType == String) {
        emit(CreateEmployeeErrorState(message: result));
      } else {
        emit(state.copyWith(
            employee: EmployeeModel.fromJson(result),
            isUpdate: true,
            formStatus: ChangedFormStatus()));
      }
    });
  }
}
