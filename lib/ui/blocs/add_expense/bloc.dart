import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/domain/interfaces/expense.dart';
import 'package:trackify/domain/models/expense.dart';
import 'package:trackify/domain/models/new_expense.dart';

part 'event.dart';
part 'state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  AddExpenseBloc(this._repository) : super(const AddExpenseInitial()) {
    on<AddExpenseEvent>(
      _onAddExpenseInitializeEvent,
      transformer: droppable(),
    );
  }

  final ExpenseRepository _repository;

  Future<void> _onAddExpenseInitializeEvent(
    AddExpenseEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    emit(const AddExpenseLoadInProgress());
    // TODO: Handle errors
    final expense = await _repository.save(event.newExpense);
    emit(AddExpenseLoadOnSuccess(expense));
  }
}
