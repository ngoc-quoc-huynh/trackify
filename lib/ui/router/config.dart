import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackify/injector.dart';
import 'package:trackify/ui/blocs/expenses/bloc.dart';
import 'package:trackify/ui/pages/home/page.dart';
import 'package:trackify/ui/router/routes.dart';

final class GoRouterConfig {
  const GoRouterConfig._();

  static final routes = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: AppRoute.home(),
        path: '/',
        builder: (_, _) => BlocProvider<ExpensesBloc>(
          create: (_) =>
              Injector.instance()..add(const ExpensesInitializeEvent()),
          child: const HomePage(),
        ),
      ),
    ],
  );
}
