part of 'bloc.dart';

@immutable
sealed class ExpensesEvent {
  const ExpensesEvent();
}

final class ExpensesInitializeEvent extends ExpensesEvent {
  const ExpensesInitializeEvent();
}

final class ExpensesDeleteEvent extends ExpensesEvent {
  const ExpensesDeleteEvent(this.id);

  final int id;
}
