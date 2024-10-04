import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/broadcast_model.dart';
import 'package:attend_smart_admin/repository/broadcast/broadcast_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../history-attend/history_attend_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;

part 'broadcast_event.dart';
part 'broadcast_state.dart';

class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  final BroadcastRepository broadcastRepo;
  BroadcastBloc(this.broadcastRepo) : super(BroadcastLoadingState()) {
    on<BroadcastLoadedEvent>((event, emit) async {
      final result = await broadcastRepo.getBroadcast(event.idCompany, {});

      var totalData = result.length;
      var start = (event.page - 1) * event.limit;
      var end = start + event.limit;
      var paginatedData =
          result.sublist(start, end > totalData ? totalData : end);

      if (result.length == 0) {
        emit(BroadcastEmptyState());
      } else {
        emit(BroadcastLoadedState(
            listInitialBroadcast: result,
            listBroadcast: paginatedData,
            page: event.page,
            limit: event.limit,
            lengthData: result.length));
      }
    });

    on<BroadcastDeleteEvent>((event, emit) async {
      final result =
          await broadcastRepo.deleteBroadcast(id: event.dataBroadcast.id ?? '');

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('broadcast/${event.dataBroadcast.id}');

      await ref.delete();
      if (result.runtimeType == String) {
        emit(BroadcastDeleteErrorState(message: result));
      } else {
        emit(BroadcastDeleteSuccessState());
      }
    });
  }
}

//Create Broadcast

class CreateBroadcastBloc
    extends Bloc<CreateBroadcastEvent, CreateBroadcastState> {
  final BroadcastRepository broadcastRepo;
  CreateBroadcastBloc(this.broadcastRepo)
      : super(CreateBroadcastInitialState()) {
    on<CreateBroadcastEvent>((event, emit) async {
      if (event is CreateBroadcastChangedEvent) {
        emit(state.copyWith(
            broadcast: event.broadcastData,
            isUpdate: false,
            formStatus: ChangedFormStatus()));
      } else if (event is CreateBroadcastAddedEvent) {
        try {
          var randomString = getRandomString(10);
          var broadcastData = state.broadcast;

          broadcastData?.idCompany = event.accountData.idCompany;

          var isUpdateBroadcast = true;

          if (broadcastData?.id == null) {
            broadcastData?.id =
                'broadcast_${event.accountData.idCompany}_$randomString';
            isUpdateBroadcast = false;
          }

          if (broadcastData?.imageBytes != null) {
            firabase_storage.UploadTask uploadTask;

            firabase_storage.Reference ref = firabase_storage
                .FirebaseStorage.instance
                .ref()
                .child('broadcast/${broadcastData?.id}');

            final metadata =
                firabase_storage.SettableMetadata(contentType: 'image/jpeg');
            uploadTask = ref.putData(broadcastData!.imageBytes!, metadata);
            await uploadTask.whenComplete(() => null);
            var url = await ref.getDownloadURL();
            broadcastData.imageUrl = url;
            broadcastData.imagePath = 'broadcast/${broadcastData.id}';
          }

          var result = await broadcastRepo.addBroadcast(
              broadcast: BroadcastModel(
                  id: broadcastData?.id,
                  idCompany: event.accountData.idCompany,
                  title: broadcastData?.title,
                  subTitle: broadcastData?.subTitle,
                  imageUrl: broadcastData?.imageUrl));

          if (result.runtimeType == String) {
            emit(CreateBroadcastErrorState(message: state.errorMessage));
          } else {
            emit(CreateBroadcastSuccessState(
                isUpdateBroadcast: isUpdateBroadcast));
          }
        } catch (e) {
          emit(CreateBroadcastErrorState(message: e.toString()));
        }
      }
    });

    on<CreateBroadcastInitialEvent>((event, emit) async {
      emit(state.copyWith(
          broadcast: BroadcastModel(),
          isUpdate: false,
          formStatus: const InitialFormStatus()));
    });

    on<CreateBroadcastByIdEvent>((event, emit) async {
      var result = await broadcastRepo.getBroadcastById(id: event.id);
      if (result.runtimeType == String) {
        emit(CreateBroadcastErrorState(message: result));
      } else {
        emit(state.copyWith(
            broadcast: BroadcastModel.fromJson(result),
            isUpdate: true,
            formStatus: ChangedFormStatus()));
      }
    });
  }
}
