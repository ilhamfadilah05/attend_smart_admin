import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/department_model.dart';
import 'package:attend_smart_admin/repository/department/department_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../history-attend/history_attend_bloc.dart';

part 'department_event.dart';
part 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepository departmentRepo;
  DepartmentBloc(this.departmentRepo) : super(DepartmentLoadingState()) {
    on<DepartmentLoadedEvent>((event, emit) async {
      final result = await departmentRepo.getDepartment(event.idCompany, {});

      var totalData = result.length;
      var start = (event.page - 1) * event.limit;
      var end = start + event.limit;
      var paginatedData =
          result.sublist(start, end > totalData ? totalData : end);

      if (result.length == 0) {
        emit(DepartmentEmptyState());
      } else {
        emit(DepartmentLoadedState(
            listInitialDepartment: result,
            listDepartment: paginatedData,
            page: event.page,
            limit: event.limit,
            lengthData: result.length));
      }
    });

    on<DepartmentDeleteEvent>((event, emit) async {
      final result = await departmentRepo.deleteDepartment(id: event.id);
      if (result.runtimeType == String) {
        emit(DepartmentDeleteErrorState(message: result));
      } else {
        emit(DepartmentDeleteSuccessState());
      }
    });
  }
}

//Create Department

class CreateDepartmentBloc
    extends Bloc<CreateDepartmentEvent, CreateDepartmentState> {
  final DepartmentRepository departmentRepo;
  CreateDepartmentBloc(this.departmentRepo)
      : super(CreateDepartmentInitialState()) {
    on<CreateDepartmentEvent>((event, emit) async {
      if (event is CreateDepartmentChangedEvent) {
        emit(state.copyWith(
            department: event.departmentData,
            isUpdate: false,
            formStatus: ChangedFormStatus()));
      } else if (event is CreateDepartmentAddedEvent) {
        try {
          var randomString = getRandomString(10);
          var departmentData = state.department;

          departmentData?.idCompany = event.accountData.idCompany;

          var isUpdateDepartment = true;

          if (departmentData?.id == null) {
            departmentData?.id =
                'department_${event.accountData.idCompany}_$randomString';
            isUpdateDepartment = false;
          }

          var result =
              await departmentRepo.addDepartment(department: state.department!);

          if (result.runtimeType == String) {
            emit(CreateDepartmentErrorState(message: state.errorMessage));
          } else {
            emit(CreateDepartmentSuccessState(
                isUpdateDepartment: isUpdateDepartment));
          }
        } catch (e) {
          emit(CreateDepartmentErrorState(message: e.toString()));
        }
      }
    });

    on<CreateDepartmentInitialEvent>((event, emit) async {
      emit(state.copyWith(
          department: DepartmentModel(),
          isUpdate: false,
          formStatus: const InitialFormStatus()));
    });

    on<CreateDepartmentByIdEvent>((event, emit) async {
      var result = await departmentRepo.getDepartmentById(id: event.id);
      if (result.runtimeType == String) {
        emit(CreateDepartmentErrorState(message: result));
      } else {
        emit(state.copyWith(
            department: DepartmentModel.fromJson(result),
            isUpdate: true,
            formStatus: ChangedFormStatus()));
      }
    });
  }
}
