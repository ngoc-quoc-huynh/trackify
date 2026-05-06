part of 'bloc.dart';

@immutable
sealed class ExpensesEvent {
  const ExpensesEvent();
}

final class ExpensesInitializeEvent extends ExpensesEvent {
  const ExpensesInitializeEvent([this.category]);

  final ExpenseCategory? category;
}

final class ExpensesDeleteEvent extends ExpensesEvent {
  const ExpensesDeleteEvent(this.id);

  final int id;
}
