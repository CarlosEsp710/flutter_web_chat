import 'package:flutter/material.dart';

class InfoTextWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoTextWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          Text(subtitle),
        ],
      ),
    );
  }
}
