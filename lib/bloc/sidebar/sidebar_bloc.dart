import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sidebar_event.dart';
part 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc() : super(SidebarInitialState(initalPage: 0)) {
    on<SidebarEvent>((event, emit) {});

    on<SidebarInitialEvent>((event, emit) {
      emit(SidebarInitialState(initalPage: event.initalPage));
    });

    on<SidebarChangedEvent>((event, emit) {
      emit(SidebarChangedState(index: event.index));
    });
  }
}
