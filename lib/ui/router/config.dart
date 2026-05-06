import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackify/injector.dart';
import 'package:trackify/ui/blocs/add_expense/bloc.dart';
import 'package:trackify/ui/blocs/expenses/bloc.dart';
import 'package:trackify/ui/pages/add/page.dart';
import 'package:trackify/ui/pages/home/page.dart';
import 'package:trackify/ui/router/routes.dart';

final class GoRouterConfig {
  const GoRouterConfig._();

  static final routes = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (_, _, child) => BlocProvider<ExpensesBloc>(
          create: (_) =>
              Injector.instance()..add(const ExpensesInitializeEvent()),
          child: child,
        ),
        routes: [
          GoRoute(
            name: AppRoute.home(),
            path: '/',
            builder: (_, _) => const HomePage(),
            routes: [
              GoRoute(
                name: AppRoute.add(),
                path: 'add',
                builder: (_, _) => BlocProvider<AddExpenseBloc>(
                  create: (_) => Injector.instance(),
                  child: const AddPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
