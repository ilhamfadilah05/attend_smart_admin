part of 'account_cubit.dart';

sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

final class AccountInitial extends AccountState {}

final class AccountLoaded extends AccountState {
  final AccountModel account;

  const AccountLoaded(this.account);

  @override
  List<Object> get props => [account];
}
