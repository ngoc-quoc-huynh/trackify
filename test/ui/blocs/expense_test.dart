import 'package:bloc_test/bloc_test.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackify/domain/models/category.dart';
import 'package:trackify/domain/models/expense.dart';
import 'package:trackify/ui/blocs/expenses/bloc.dart';

import '../../mocks.dart';

void main() {
  final repository = MockExpenseRepository();
  ExpensesBloc createBloc() => ExpensesBloc(repository);

  final expense = Expense(
    id: 1,
    description: '',
    value: Decimal.one,
    category: ExpenseCategory.other,
    date: DateTime.utc(2026),
  );

  test(
    'inital state is ExpensesLoadInProgress',
    () => expect(createBloc().state, const ExpensesLoadInProgress()),
  );

  group('ExpensesInitializeEvent', () {
    blocTest<ExpensesBloc, ExpensesState>(
      'emits ExpensesLoadOnSuccess',
      setUp: () => when(
        repository.getAll,
      ).thenAnswer((_) async => [expense]),
      build: createBloc,
      act: (bloc) => bloc.add(const ExpensesInitializeEvent()),
      expect: () => [
        const ExpensesLoadInProgress(),
        ExpensesLoadOnSuccess([expense]),
      ],
      verify: (_) => verify(repository.getAll).called(1),
    );

    blocTest<ExpensesBloc, ExpensesState>(
      'emits ExpensesLoadOnFailure',
      setUp: () => when(
        repository.getAll,
      ).thenThrow(Exception()),
      build: createBloc,
      act: (bloc) => bloc.add(const ExpensesInitializeEvent()),
      expect: () => [
        const ExpensesLoadInProgress(),
        const ExpensesLoadOnFailure(),
      ],
      verify: (_) => verify(repository.getAll).called(1),
    );
  });

  group('ExpensesDeleteEvent', () {
    blocTest<ExpensesBloc, ExpensesState>(
      'emits ExpensesLoadOnSuccess',
      setUp: () => when(
        () => repository.delete(expense.id),
      ).thenAnswer((_) => Future.value()),
      seed: () => ExpensesLoadOnSuccess([expense]),
      build: createBloc,
      act: (bloc) => bloc.add(ExpensesDeleteEvent(expense.id)),
      expect: () => [
        const ExpensesLoadInProgress(),
        const ExpensesLoadOnSuccess([]),
      ],
      verify: (_) => verify(() => repository.delete(expense.id)).called(1),
    );

    blocTest<ExpensesBloc, ExpensesState>(
      'emits ExpensesLoadOnFailure',
      setUp: () => when(
        () => repository.delete(expense.id),
      ).thenThrow(Exception()),
      seed: () => ExpensesLoadOnSuccess([expense]),
      build: createBloc,
      act: (bloc) => bloc.add(ExpensesDeleteEvent(expense.id)),
      expect: () => [
        const ExpensesLoadInProgress(),
        const ExpensesLoadOnFailure(),
      ],
      verify: (_) => verify(() => repository.delete(expense.id)).called(1),
    );
  });
}
