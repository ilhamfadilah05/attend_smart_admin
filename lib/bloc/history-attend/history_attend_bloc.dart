import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/history_attend_model.dart';
import 'package:attend_smart_admin/repository/history-attend/history_attend_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'history_attend_event.dart';
part 'history_attend_state.dart';

class HistoryAttendBloc extends Bloc<HistoryAttendEvent, HistoryAttendState> {
  final HistoryAttendRepository historyAttendRepo;
  HistoryAttendBloc(this.historyAttendRepo)
      : super(HistoryAttendLoadingState()) {
    on<HistoryAttendLoadedEvent>((event, emit) async {
      final result = await historyAttendRepo.getHistoryAttend(event.idCompany);

      var totalData = result.length;
      var start = (event.page - 1) * event.limit;
      var end = start + event.limit;
      var paginatedData =
          result.sublist(start, end > totalData ? totalData : end);

      if (result.length == 0) {
        emit(HistoryAttendEmptyState());
      } else {
        emit(HistoryAttendLoadedState(
            listInitialHistoryAttend: result,
            listHistoryAttend: paginatedData,
            page: event.page,
            limit: event.limit,
            lengthData: result.length));
      }
    });

    on<HistoryAttendDeleteEvent>((event, emit) async {
      final result = await historyAttendRepo.deleteHistoryAttend(id: event.id);
      if (result.runtimeType == String) {
        emit(HistoryAttendDeleteErrorState(message: result));
      } else {
        emit(HistoryAttendDeleteSuccessState());
      }
    });
  }
}

//Create HistoryAttend

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
            emit(CreateHistoryAttendSuccessState(
                isUpdateHistoryAttend: isUpdateHistoryAttend));
          }
        } catch (e) {
          emit(CreateHistoryAttendErrorState(message: e.toString()));
        }
      }
    });

    on<CreateHistoryAttendInitialEvent>((event, emit) async {
      emit(state.copyWith(
          historyAttend: HistoryAttendModel(),
          isUpdate: false,
          formStatus: const InitialFormStatus()));
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
  }
}
