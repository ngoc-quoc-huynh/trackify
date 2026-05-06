import 'package:flutter/material.dart';

class LoadingInidcator extends StatelessWidget {
  const LoadingInidcator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
