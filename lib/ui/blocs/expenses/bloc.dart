import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/domain/interfaces/expense.dart';
import 'package:trackify/domain/models/category.dart';
import 'package:trackify/domain/models/expense.dart';

part 'event.dart';
part 'state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc(this._repository) : super(const ExpensesLoadInProgress()) {
    on<ExpensesInitializeEvent>(
      _onExpensesInitializeEvent,
      transformer: restartable(),
    );
    on<ExpensesDeleteEvent>(
      _onExpensesDeleteEvent,
      transformer: droppable(),
    );
  }

  final ExpenseRepository _repository;

  Future<void> _onExpensesInitializeEvent(
    ExpensesInitializeEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(const ExpensesLoadInProgress());

    try {
      final expenses = await _repository.getAll(event.category);
      emit(ExpensesLoadOnSuccess(expenses: expenses, category: event.category));
    } on Exception {
      emit(const ExpensesLoadOnFailure());
    }
  }

  Future<void> _onExpensesDeleteEvent(
    ExpensesDeleteEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    if (state case ExpensesLoadOnSuccess(:final category, :final expenses)) {
      emit(const ExpensesLoadInProgress());

      try {
        await _repository.delete(event.id);
        final newExpenses = List.of(expenses)
          ..removeWhere((expense) => expense.id == event.id);
        emit(
          ExpensesLoadOnSuccess(expenses: newExpenses, category: category),
        );
      } on Exception {
        emit(const ExpensesLoadOnFailure());
      }
    }
  }
}
