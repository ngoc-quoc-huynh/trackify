import 'package:go_router/go_router.dart';
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
        builder: (_, _) => const HomePage(),
      ),
    ],
  );
}
