import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/submission_model.dart';
import 'package:attend_smart_admin/repository/submission/submission_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../history-attend/history_attend_bloc.dart';

part 'submission_event.dart';
part 'submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final SubmissionRepository submissionRepo;
  SubmissionBloc(this.submissionRepo) : super(SubmissionLoadingState()) {
    on<SubmissionLoadedEvent>((event, emit) async {
      final result = await submissionRepo.getSubmission(event.idCompany, {});

      if (result.length == 0) {
        emit(SubmissionEmptyState());
      } else {
        emit(SubmissionLoadedState(listSubmission: result));
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
