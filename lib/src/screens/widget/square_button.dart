import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final Color backgroundColor;
  final String title;

  SquareButton({Key key, this.backgroundColor, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Text(title,
          style: TextStyle(
              fontSize: 18.0, letterSpacing: 1.0, color: Colors.white)),
    );
  }
}
