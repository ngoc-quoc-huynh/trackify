part of 'bloc.dart';

@immutable
final class AddExpenseEvent {
  const AddExpenseEvent(this.newExpense);

  final NewExpense newExpense;
}
