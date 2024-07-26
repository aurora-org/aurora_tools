import 'package:flutter/material.dart';

class AButton extends StatelessWidget {
  late void Function() onPress;
  late String actionText;
  late Color? bgColor = Colors.blue;

  AButton({required this.onPress, required this.actionText, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: bgColor),
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.transparent)),
        child: Text(
          actionText,
          style: TextStyle(
              fontSize: 16, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
