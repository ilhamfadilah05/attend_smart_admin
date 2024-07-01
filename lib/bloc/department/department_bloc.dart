import 'package:attend_smart_admin/bloc/branch/branch_bloc.dart';
import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
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
      var result = await departmentRepository?.getDepartment(
          event.idCompany, event.lastData);
      var totalData =
          await departmentRepository?.getTotalDataDepartment(event.idCompany);
      if (result.runtimeType == List<DepartmentModel>) {
        emit(DepartmentLoadedState(
            listDepartments: result,
            totalData: totalData ?? 0,
            lastData: (result[result.length - 1]).toJson()));
      } else {
        emit(DepartmentErrorState(message: result));
      }
    });

    on<DepartmentDeleteEvent>((event, emit) async {
      final result = await departmentRepository?.deleteDepartment(id: event.id);
      if (result.runtimeType == String) {
        emit(DepartmentDeleteErrorState(message: result));
      } else {
        emit(DepartmentDeleteSuccessState());
      }
    });
  }
}

// Create Department

class CreateDepartmentBloc
    extends Bloc<CreateDepartmentEvent, CreateDepartmentState> {
  final DepartmentRepository departmentRepo;
  CreateDepartmentBloc(this.departmentRepo)
      : super(CreateDepartmentInitialState()) {
    on<CreateDepartmentEvent>((event, emit) async {
      if (event is CreateDepartmentChangedEvent) {
        emit(state.copyWith(department: event.departmentData, isUpdate: false,formStatus: ChangedFormStatus()));
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
