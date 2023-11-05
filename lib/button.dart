import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final IconData? icon;
  final String text;
  MyButton({required this.onPressed, required this.text, this.icon});

  final GestureTapCallback onPressed;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.black,
      splashColor: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              widget.icon,
              color: Colors.amber,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              widget.text,
              maxLines: 1,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      onPressed: widget.onPressed,
      shape: const StadiumBorder(),
    );
  }
}
