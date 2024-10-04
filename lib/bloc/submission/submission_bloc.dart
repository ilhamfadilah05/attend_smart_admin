import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:attend_smart_admin/models/history_attend_model.dart';
import 'package:attend_smart_admin/models/submission_model.dart';
import 'package:attend_smart_admin/repository/employee/employee_repository.dart';
import 'package:attend_smart_admin/repository/history-attend/history_attend_repository.dart';
import 'package:attend_smart_admin/repository/submission/submission_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../history-attend/history_attend_bloc.dart';

part 'submission_event.dart';
part 'submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final SubmissionRepository submissionRepo;
  SubmissionBloc(this.submissionRepo) : super(SubmissionLoadingState()) {
    on<SubmissionLoadedEvent>((event, emit) async {
      final result = await submissionRepo.getSubmission(event.idCompany, {});

      var totalData = result.length;
      var start = (event.page - 1) * event.limit;
      var end = start + event.limit;
      var paginatedData =
          result.sublist(start, end > totalData ? totalData : end);

      if (result.length == 0) {
        emit(SubmissionEmptyState());
      } else {
        emit(SubmissionLoadedState(
            listInitialSubmission: result,
            listSubmission: paginatedData,
            page: event.page,
            limit: event.limit,
            lengthData: result.length));
      }
    });

    on<SubmissionDeleteEvent>((event, emit) async {
      final result = await submissionRepo.deleteSubmission(id: event.id);
      if (result.runtimeType == String) {
        emit(SubmissionDeleteErrorState(message: result));
      } else {
        emit(SubmissionDeleteSuccessState());
      }
    });
  }
}

//Create Submission

class CreateSubmissionBloc
    extends Bloc<CreateSubmissionEvent, CreateSubmissionState> {
  final SubmissionRepository submissionRepo;
  CreateSubmissionBloc(this.submissionRepo)
      : super(CreateSubmissionInitialState()) {
    on<CreateSubmissionEvent>((event, emit) async {
      if (event is CreateSubmissionChangedEvent) {
        emit(state.copyWith(
            submission: event.submissionData,
            isUpdate: false,
            formStatus: ChangedFormStatus()));
      } else if (event is CreateSubmissionAddedEvent) {
        try {
          var randomString = getRandomString(10);
          var submissionData = state.submission;

          submissionData?.idCompany = event.accountData.idCompany;

          var isUpdateSubmission = true;

          if (submissionData?.id == null) {
            submissionData?.id =
                'submission_${event.accountData.idCompany}_$randomString';
            isUpdateSubmission = false;
          }

          var result =
              await submissionRepo.addSubmission(submission: state.submission!);

          var dataEmployee = EmployeeModel.fromJson(await EmployeeRepository()
              .getEmployeeById(id: state.submission!.idEmployee!));

          var dateStart = DateTime.parse(state.submission!.dateStart!);
          var dateEnd = DateTime.parse(state.submission!.dateEnd!);

          var totalDaySubmission = dateEnd.difference(dateStart).inDays;

          for (var i = 0; i <= totalDaySubmission; i++) {
            var dataAttend = HistoryAttendModel(
              id: 'history_${dataEmployee.id}_${getRandomString(6)}',
              idEmployee: dataEmployee.id,
              idBranch: state.submission?.idBranch,
              idCompany: state.submission?.idCompany,
              nameEmployee: state.submission?.nameEmployee,
              nameBranch: dataEmployee.nameBranch,
              nameCompany: dataEmployee.nameCompany,
              tipeAbsen: state.submission?.type?.toUpperCase(),
              delayedAttend: '0',
              latLong: '0,0',
              locationAttend: state.submission?.type?.toUpperCase(),
              imageAttend: null,
              dateAttend: DateFormat('yyyy-MM-dd')
                  .format(dateStart.add(Duration(days: i)))
                  .toString(),
              timeAttend: DateFormat('HH:mm')
                  .format(dateStart.add(Duration(days: i)))
                  .toString(),
              department: dataEmployee.department,
              createdAt: DateTime.now().toString(),
            );

            await HistoryAttendRepository()
                .addHistoryAttend(historyAttend: dataAttend);
          }

          if (result.runtimeType == String) {
            emit(CreateSubmissionErrorState(message: state.errorMessage));
          } else {
            emit(CreateSubmissionSuccessState(
                isUpdateSubmission: isUpdateSubmission));
          }
        } catch (e) {
          emit(CreateSubmissionErrorState(message: e.toString()));
        }
      }
    });

    on<CreateSubmissionInitialEvent>((event, emit) async {
      emit(state.copyWith(
          submission: SubmissionModel(),
          isUpdate: false,
          formStatus: const InitialFormStatus()));
    });

    on<CreateSubmissionByIdEvent>((event, emit) async {
      var result = await submissionRepo.getSubmissionById(id: event.id);
      if (result.runtimeType == String) {
        emit(CreateSubmissionErrorState(message: result));
      } else {
        emit(state.copyWith(
            submission: SubmissionModel.fromJson(result),
            isUpdate: true,
            formStatus: ChangedFormStatus()));
      }
    });
  }
}
