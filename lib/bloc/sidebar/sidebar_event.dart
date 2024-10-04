part of 'sidebar_bloc.dart';

sealed class SidebarEvent extends Equatable {
  const SidebarEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class SidebarInitialEvent extends SidebarEvent {
  int initalPage = 0;
  SidebarInitialEvent({required this.initalPage});
  @override
  List<Object> get props => [initalPage];
}

class SidebarChangedEvent extends SidebarEvent {
  final int index;
  const SidebarChangedEvent({required this.index});
  @override
  List<Object> get props => [index];
}
