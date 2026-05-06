part of 'bloc.dart';

@immutable
sealed class ExpensesState extends Equatable {
  const ExpensesState();

  @override
  List<Object?> get props => [];
}

final class ExpensesLoadInProgress extends ExpensesState {
  const ExpensesLoadInProgress();
}

final class ExpensesLoadOnSuccess extends ExpensesState {
  const ExpensesLoadOnSuccess({required this.expenses, this.category});

  final List<Expense> expenses;
  final ExpenseCategory? category;

  @override
  List<Object?> get props => [expenses, category];
}

final class ExpensesLoadOnFailure extends ExpensesState {
  const ExpensesLoadOnFailure();
}
