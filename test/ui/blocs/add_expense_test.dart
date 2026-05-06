import 'package:bloc_test/bloc_test.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackify/domain/models/category.dart';
import 'package:trackify/domain/models/expense.dart';
import 'package:trackify/domain/models/new_expense.dart';
import 'package:trackify/ui/blocs/add_expense/bloc.dart';

import '../../mocks.dart';

void main() {
  final repository = MockExpenseRepository();
  AddExpenseBloc createBloc() => AddExpenseBloc(repository);
  final newExpense = NewExpense(
    description: '',
    value: Decimal.one,
    category: ExpenseCategory.other,
    date: DateTime.utc(2026),
  );
  final expense = Expense(
    id: 1,
    description: '',
    value: Decimal.one,
    category: ExpenseCategory.other,
    date: DateTime.utc(2026),
  );

  test(
    'inital state is AddExpenseInitial',
    () => expect(createBloc().state, const AddExpenseInitial()),
  );

  blocTest<AddExpenseBloc, AddExpenseState>(
    'emits AddExpenseLoadOnSuccess',
    setUp: () => when(
      () => repository.save(newExpense),
    ).thenAnswer((_) async => expense),
    build: createBloc,
    act: (bloc) => bloc.add(
      AddExpenseEvent(
        NewExpense(
          description: '',
          value: Decimal.one,
          category: ExpenseCategory.other,
          date: DateTime.utc(2026),
        ),
      ),
    ),
    expect: () => [
      const AddExpenseLoadInProgress(),
      AddExpenseLoadOnSuccess(expense),
    ],
    verify: (_) => verify(() => repository.save(newExpense)).called(1),
  );
}
