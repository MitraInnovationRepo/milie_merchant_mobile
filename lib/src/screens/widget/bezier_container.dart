import 'package:flutter/material.dart';
import 'custom_clipper.dart';

class BezierContainer extends StatelessWidget {
  final double angle;
  final Color gradientColor;
  const BezierContainer({Key key, this.angle, this.gradientColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
          angle: angle,
          child: ClipPath(
            clipper: ClipPainter(),
            child: Container(
              height: MediaQuery.of(context).size.height *.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [gradientColor, Theme.of(context).primaryColor]
                  )
              ),
            ),
          ),
        )
    );
  }
}