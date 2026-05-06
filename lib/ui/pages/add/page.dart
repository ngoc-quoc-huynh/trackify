import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:trackify/domain/models/category.dart';
import 'package:trackify/domain/models/new_expense.dart';
import 'package:trackify/ui/blocs/add_expense/bloc.dart';
import 'package:trackify/ui/blocs/expenses/bloc.dart';
import 'package:trackify/ui/router/routes.dart';
import 'package:trackify/ui/utils.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  final _dateController = TextEditingController(text: DateTime.now().format());
  ExpenseCategory _category = ExpenseCategory.other;

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddExpenseBloc, AddExpenseState>(
      listener: _onAddExpenseStateChanged,
      child: Column(
        spacing: 10,
        children: [
          TextFormField(
            controller: _descriptionController,
            textInputAction: .next,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            validator: _descrptionValidator,
          ),
          TextFormField(
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            textInputAction: .next,
            decoration: const InputDecoration(
              labelText: 'Amount',
              suffixText: '€',
            ),
            validator: _valueValidator,
          ),
          DropdownButtonFormField<ExpenseCategory>(
            initialValue: _category,
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
            items: ExpenseCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.name),
                  ),
                )
                .toList(),
            onChanged: _onCategoryChanged,
          ),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date',
              suffixIcon: Icon(Icons.calendar_today_outlined),
            ),
            onTap: _showDatePicker,
          ),
          BlocSelector<AddExpenseBloc, AddExpenseState, bool>(
            selector: (state) => state is AddExpenseLoadInProgress,
            builder: (context, state) => FilledButton(
              onPressed: switch (state) {
                true => null,
                false => () => _saveExpense(context),
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  String? _descrptionValidator(String? value) =>
      value == null || value.trim().isEmpty ? 'Enter a description' : null;

  String? _valueValidator(String? value) {
    final amount = _parseAmount(value ?? '');
    if (amount == null || amount <= Decimal.zero) {
      return 'Enter a valid amount';
    }

    return null;
  }

  Decimal? _parseAmount(String value) {
    final normalizedValue = value.trim().replaceAll(',', '.');

    if (normalizedValue.isEmpty) {
      return null;
    }

    return Decimal.tryParse(normalizedValue);
  }

  void _onCategoryChanged(ExpenseCategory? category) {
    if (category != null) {
      _category = category;
    }
  }

  Future<void> _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) {
      return;
    }

    _dateController.text = pickedDate.format();
  }

  void _saveExpense(BuildContext context) {
    final state = Form.of(context);
    if (!state.validate()) {
      return;
    }

    final amount = _parseAmount(_valueController.text);
    if (amount == null) {
      return;
    }

    context.read<AddExpenseBloc>().add(
      AddExpenseEvent(
        NewExpense(
          description: _descriptionController.text.trim(),
          value: amount,
          category: _category,
          date: DateFormat('dd.MM.yyyy').parse(_dateController.text),
        ),
      ),
    );
  }

  void _onAddExpenseStateChanged(BuildContext context, AddExpenseState state) {
    if (state is AddExpenseLoadOnSuccess) {
      context
        ..goNamed(AppRoute.home())
        ..read<ExpensesBloc>().add(const ExpensesInitializeEvent());
    }
  }
}
