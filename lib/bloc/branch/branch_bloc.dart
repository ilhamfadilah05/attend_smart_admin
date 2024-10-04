import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/branch_model.dart';
import 'package:attend_smart_admin/repository/branch/branch_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../history-attend/history_attend_bloc.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository branchRepo;
  BranchBloc(this.branchRepo) : super(BranchLoadingState()) {
    on<BranchLoadedEvent>((event, emit) async {
      final result = await branchRepo.getBranch(event.idCompany);

      var totalData = result.length;
      var start = (event.page - 1) * event.limit;
      var end = start + event.limit;
      var paginatedData =
          result.sublist(start, end > totalData ? totalData : end);

      if (result.length == 0) {
        emit(BranchEmptyState());
      } else {
        emit(BranchLoadedState(
            listInitialBranch: result,
            listBranch: paginatedData,
            page: event.page,
            limit: event.limit,
            lengthData: result.length));
      }
    });

    on<BranchDeleteEvent>((event, emit) async {
      final result = await branchRepo.deleteBranch(id: event.id);
      if (result.runtimeType == String) {
        emit(BranchDeleteErrorState(message: result));
      } else {
        emit(BranchDeleteSuccessState());
      }
    });
  }
}

//Create Branch

class CreateBranchBloc extends Bloc<CreateBranchEvent, CreateBranchState> {
  final BranchRepository branchRepo;
  CreateBranchBloc(this.branchRepo) : super(CreateBranchInitialState()) {
    on<CreateBranchEvent>((event, emit) async {
      if (event is CreateBranchChangedEvent) {
        emit(state.copyWith(
            branch: event.branchData,
            isUpdate: false,
            formStatus: ChangedFormStatus()));
      } else if (event is CreateBranchAddedEvent) {
        try {
          var randomString = getRandomString(10);
          var branchData = state.branch;

          branchData?.idCompany = event.accountData.idCompany;

          var isUpdateBranch = true;

          if (branchData?.id == null) {
            branchData?.id =
                'branch_${event.accountData.idCompany}_$randomString';
            isUpdateBranch = false;
          }

          var result = await branchRepo.addBranch(branch: state.branch!);

          if (result.runtimeType == String) {
            emit(CreateBranchErrorState(message: state.errorMessage));
          } else {
            emit(CreateBranchSuccessState(isUpdateBranch: isUpdateBranch));
          }
        } catch (e) {
          emit(CreateBranchErrorState(message: e.toString()));
        }
      }
    });

    on<CreateBranchInitialEvent>((event, emit) async {
      emit(state.copyWith(
          branch: BranchModel(),
          isUpdate: false,
          formStatus: const InitialFormStatus()));
    });

    on<CreateBranchByIdEvent>((event, emit) async {
      var result = await branchRepo.getBranchById(id: event.id);
      if (result.runtimeType == String) {
        emit(CreateBranchErrorState(message: result));
      } else {
        emit(state.copyWith(
            branch: BranchModel.fromJson(result),
            isUpdate: true,
            formStatus: ChangedFormStatus()));
      }
    });
  }
}
