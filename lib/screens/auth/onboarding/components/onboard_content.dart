import 'package:flutter/material.dart';
import 'package:ueh_food_delivery/constants.dart';

class OnboardContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset(
          image,
          height: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: defaultPadding * 2),


        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: defaultPadding),


        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: bodyTextColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
