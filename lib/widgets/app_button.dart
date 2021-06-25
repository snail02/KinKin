import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool enabled;

  const AppButton({
    required this.text,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Color.fromRGBO(47, 128, 237, 1),
      onPressed: enabled ? () => onPressed.call() : () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 16),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
