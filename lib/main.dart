import 'package:flutter/material.dart';
import 'package:trackify/injector.dart';
import 'package:trackify/ui/router/config.dart';

Future<void> main() async {
  await Injector.setupDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trackify',
      routerConfig: GoRouterConfig.routes,
    );
  }
}
