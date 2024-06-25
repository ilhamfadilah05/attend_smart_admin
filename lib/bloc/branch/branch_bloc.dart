import 'package:attend_smart_admin/models/branch_model.dart';
import 'package:attend_smart_admin/repository/branch/branch_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchRepository? branchRepository;
  BranchBloc(this.branchRepository) : super(BranchInitialState()) {
    on<BranchEvent>((event, emit) {});

    on<BranchLoadedEvent>((event, emit) async {
      var result = await branchRepository?.getBranch();
      if (result.runtimeType == List<BranchModel>) {
        emit(BranchLoadedtate(listBranch: result));
      } else {
        emit(BranchErrorState(message: result));
      }
    });
  }
}
