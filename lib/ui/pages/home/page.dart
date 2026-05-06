import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackify/domain/models/category.dart';
import 'package:trackify/domain/models/expense.dart';
import 'package:trackify/ui/blocs/expenses/bloc.dart';
import 'package:trackify/ui/router/routes.dart';
import 'package:trackify/ui/utils.dart';
import 'package:trackify/ui/widgets/loading_indcator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocSelector<ExpensesBloc, ExpensesState, bool>(
        selector: (state) => state is ExpensesLoadOnSuccess,
        builder: (context, state) => switch (state) {
          true => FloatingActionButton(
            onPressed: () => context.goNamed(AppRoute.add()),
            child: const Icon(Icons.add),
          ),
          false => const SizedBox.shrink(),
        },
      ),
      appBar: AppBar(
        title: const Text('Trackify'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: _CategoryFilter(),
        ),
      ),
      body: BlocBuilder<ExpensesBloc, ExpensesState>(
        builder: (context, state) => switch (state) {
          ExpensesLoadInProgress() => const LoadingInidcator(),
          ExpensesLoadOnSuccess(:final expenses) when expenses.isEmpty =>
            const Center(
              child: Text(
                'There are no expenses yet, try adding one.',
              ),
            ),
          ExpensesLoadOnSuccess(:final expenses) => _Body(expenses),
          ExpensesLoadOnFailure() => const Text('Ooops, something went wrong'),
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this._expenses);

  final List<Expense> _expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final expense = _expenses[index];

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Text(expense.description),
          subtitle: Row(
            spacing: 5,
            children: [
              Text(expense.category.name),
              const Text('-'),
              Text(expense.date.format()),
            ],
          ),
          trailing: Row(
            mainAxisSize: .min,
            spacing: 5,
            children: [
              Text(
                '${expense.value} €',
                style: TextTheme.of(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => context.read<ExpensesBloc>().add(
                  ExpensesDeleteEvent(expense.id),
                ),
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete expense',
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, _) => const Divider(),
      itemCount: _expenses.length,
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Row(
        spacing: 10,
        children: ExpenseCategory.values
            .map(
              (c) => BlocSelector<ExpensesBloc, ExpensesState, bool>(
                selector: (state) => switch (state) {
                  ExpensesLoadInProgress() => false,
                  ExpensesLoadOnSuccess(:final category) => c == category,
                  ExpensesLoadOnFailure() => false,
                },
                builder: (context, state) => ChoiceChip(
                  label: Text(c.name),
                  selected: state,
                  onSelected: (val) => switch (val) {
                    true => context.read<ExpensesBloc>().add(
                      ExpensesInitializeEvent(c),
                    ),
                    false => context.read<ExpensesBloc>().add(
                      const ExpensesInitializeEvent(),
                    ),
                  },
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
