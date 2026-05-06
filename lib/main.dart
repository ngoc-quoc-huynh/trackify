import 'package:flutter/material.dart';
import 'package:trackify/ui/router/config.dart';

void main() {
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
