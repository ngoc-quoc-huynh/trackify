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
  const ExpensesLoadOnSuccess(this.expenses);

  final List<Expense> expenses;
}

final class ExpensesLoadOnFailure extends ExpensesState {
  const ExpensesLoadOnFailure();
}
