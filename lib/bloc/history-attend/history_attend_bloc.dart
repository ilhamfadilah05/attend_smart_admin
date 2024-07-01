import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/history_attend_model.dart';
import 'package:attend_smart_admin/repository/history-attend/history_attend_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'history_attend_event.dart';
part 'history_attend_state.dart';

class HistoryAttendBloc extends Bloc<HistoryAttendEvent, HistoryAttendState> {
  HistoryAttendRepository? historyAttendRepo;
  HistoryAttendBloc(this.historyAttendRepo)
      : super(HistoryAttendInitialState()) {
    on<HistoryAttendLoadedEvent>((event, emit) async {
      var result = await historyAttendRepo?.getHistoryAttend(event.idCompany);
      if (result.runtimeType == List<HistoryAttendModel>) {
        emit(HistoryAttendLoadedState(listHistoryAttend: result));
      } else {
        emit(HistoryAttendErrorState(message: result));
      }
    });

    on<HistoryAttendDeleteEvent>((event, emit) async {
      final result = await historyAttendRepo?.deleteHistoryAttend(id: event.id);
      if (result.runtimeType == String) {
        emit(HistoryAttendDeleteErrorState(message: result));
      } else {
        emit(HistoryAttendDeleteSuccessState());
      }
    });
  }
}

// Create HistoryAttend
class CreateHistoryAttendBloc
    extends Bloc<CreateHistoryAttendEvent, CreateHistoryAttendState> {
  final HistoryAttendRepository historyAttendRepo;

  CreateHistoryAttendBloc(this.historyAttendRepo)
      : super(CreateHistoryAttendInitialState()) {
    on<CreateHistoryAttendEvent>((event, emit) async {
      if (event is CreateHistoryAttendChangedEvent) {
        emit(state.copyWith(
            historyAttend: event.historyAttendData,
            isUpdate: false,
            formStatus: ChangedFormStatus()));
      } else if (event is CreateHistoryAttendAddedEvent) {
        try {
          var randomString = getRandomString(10);
          var historyAttendData = state.historyAttend;

          historyAttendData?.idCompany = event.accountData.idCompany;

          var isUpdateHistoryAttend = true;

          if (historyAttendData?.id == null) {
            historyAttendData?.id =
                'historyAttend_${event.accountData.idCompany}_$randomString';
            isUpdateHistoryAttend = false;
          }

          var result = await historyAttendRepo.addHistoryAttend(
              historyAttend: state.historyAttend!);

          if (result.runtimeType == String) {
            emit(CreateHistoryAttendErrorState(message: state.errorMessage));
          } else {
            emit(state.copyWith(historyAttend: HistoryAttendModel()));
            emit(CreateHistoryAttendSuccessState(
                isUpdateHistoryAttend: isUpdateHistoryAttend));
          }
        } catch (e) {
          emit(CreateHistoryAttendErrorState(message: e.toString()));
        }
      }
    });

    on<CreateHistoryAttendByIdEvent>((event, emit) async {
      var result = await historyAttendRepo.getHistoryAttendById(id: event.id);
      if (result.runtimeType == String) {
        emit(CreateHistoryAttendErrorState(message: result));
      } else {
        emit(state.copyWith(
            historyAttend: HistoryAttendModel.fromJson(result),
            isUpdate: true,
            formStatus: ChangedFormStatus()));
      }
    });

    on<CreateHistoryAttendResetEvent>((event, emit) async {
      emit(CreateHistoryAttendInitialState());
      emit(state.copyWith(
          isUpdate: false,
          historyAttend: HistoryAttendModel(),
          formStatus: const InitialFormStatus()));
    });
  }
}
