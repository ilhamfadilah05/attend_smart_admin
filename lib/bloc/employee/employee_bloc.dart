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

      // Terapkan semua filter secara bersamaan
      var filteredData = result.where((element) {
        bool matchesName = true;
        bool matchesDepartment = true;
        bool matchesBranch = true;

        if (event.searchName != null) {
          matchesName = element['name']
              .toLowerCase()
              .contains(event.searchName!.toLowerCase());
        }

        if (event.searchDepartment != null) {
          matchesDepartment = element['department']
              .toLowerCase()
              .contains(event.searchDepartment!.toLowerCase());
        }

        if (event.searchBranch != null) {
          matchesBranch = element['name_branch']
              .toLowerCase()
              .contains(event.searchBranch!.toLowerCase());
        }

        // Hanya yang memenuhi ketiga filter yang akan dipertahankan
        return matchesName && matchesDepartment && matchesBranch;
      }).toList();

      // Paginasi setelah filter diterapkan
      var totalData = filteredData.length;
      var start = (event.page - 1) * event.limit;
      var end = start + event.limit;
      var paginatedData =
          filteredData.sublist(start, end > totalData ? totalData : end);

      if (filteredData.isEmpty) {
        emit(EmployeeEmptyState());
      } else {
        emit(EmployeeLoadedState(
            listInitialEmployee: result,
            listEmployee: paginatedData,
            page: event.page,
            limit: event.limit,
            lengthData: filteredData.length));
      }
    });

    on<EmployeeDeleteEvent>((event, emit) async {
      final result =
          await employeeRepo.deleteEmployee(id: event.dataEmployee.id!);

      await employeeRepo.deleteAccount(id: event.dataEmployee.idAccount!);
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
          emit(state.copyWith(
              employee: event.employeeData,
              isUpdate: false,
              formStatus: LoadingButtonStatus()));
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

          employeeData?.idAccount ??=
              employeeData.id?.replaceAll('employee', 'account');

          employeeData?.tokenNotif = employeeData.tokenNotif;

          idEmployee = employeeData?.id ?? '';

          employeeData?.tokenNotif = employeeData.tokenNotif ?? '';

          var result = await employeeRepo.addEmployee(employee: employeeData!);

          if (result.runtimeType == String) {
            emit(CreateEmployeeErrorState(message: state.errorMessage));
          } else {
            var accountData = AccountModel(
              id: employeeData.idAccount,
              name: event.employeeData.name,
              email: event.employeeData.email ??
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
      emit(state.copyWith(
          employee: EmployeeModel(),
          isUpdate: false,
          formStatus: LoadingFormStatus()));
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
