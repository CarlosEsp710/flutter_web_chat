import 'package:flutter/material.dart';

import '../widgets/info_text_widget.dart';

class ErrorPage extends StatelessWidget {
  final String error;

  const ErrorPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InfoTextWidget(
        title: 'Ups! Algo salió mal.',
        subtitle: error,
      ),
    );
  }
}
