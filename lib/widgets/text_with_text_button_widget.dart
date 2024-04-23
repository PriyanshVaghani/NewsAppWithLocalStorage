import 'package:flutter/material.dart';

class TextWithTextButtonWidget extends StatelessWidget {
  const TextWithTextButtonWidget({
    super.key,
    required this.textMessage,
    required this.textButtonMessage,
    required this.onPressed,
  });

  final String textMessage;
  final String textButtonMessage;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(textMessage),
        TextButton(
          onPressed: onPressed,
          child: Text(
            textButtonMessage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        )
      ],
    );
  }
}
