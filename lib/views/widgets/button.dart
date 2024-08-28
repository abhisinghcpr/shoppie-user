import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final VoidCallback? onPressed;
  final String buttonText;

  const Button({Key? key, required this.onPressed, required this.buttonText})
      : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      child: Text(widget.buttonText),
      style: ElevatedButton.styleFrom(

        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Button padding
      ),
    );
  }
}
