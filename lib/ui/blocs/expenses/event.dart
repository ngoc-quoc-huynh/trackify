part of 'bloc.dart';

@immutable
sealed class ExpensesEvent {
  const ExpensesEvent();
}

final class ExpensesInitializeEvent extends ExpensesEvent {
  const ExpensesInitializeEvent();
}
