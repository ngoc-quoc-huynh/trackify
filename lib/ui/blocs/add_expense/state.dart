part of 'bloc.dart';

@immutable
sealed class AddExpenseState extends Equatable {
  const AddExpenseState();

  @override
  List<Object?> get props => [];
}

final class AddExpenseInitial extends AddExpenseState {
  const AddExpenseInitial();
}

final class AddExpenseLoadInProgress extends AddExpenseState {
  const AddExpenseLoadInProgress();
}

final class AddExpenseLoadOnSuccess extends AddExpenseState {
  const AddExpenseLoadOnSuccess(this.expense);

  final Expense expense;
}
