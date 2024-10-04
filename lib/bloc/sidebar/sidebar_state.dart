part of 'sidebar_bloc.dart';

sealed class SidebarState extends Equatable {
  const SidebarState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class SidebarInitialState extends SidebarState {
  int initalPage = 0;

  SidebarInitialState({required this.initalPage});
  @override
  List<Object> get props => [initalPage];
}

final class SidebarChangedState extends SidebarState {
  final int index;

  const SidebarChangedState({required this.index});

  @override
  List<Object> get props => [index];
}
