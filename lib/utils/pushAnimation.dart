import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:web_view_app/deatilPackage/deatilScreen.dart';

_pushAnimation(BuildContext context) {
  // 1
  Navigator.of(context).push(new PageRouteBuilder(
      opaque: true,
      // 2
      transitionDuration: const Duration(milliseconds: 1000),
      // 3
      pageBuilder: (BuildContext context, _, __) {
        return new DetailScreen();
      },
      // 4
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return new FadeTransition(
          opacity: animation,
          child: new RotationTransition(
            turns: new Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          ),
        );
      }
  ));
}
