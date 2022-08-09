import 'dart:async';

import 'package:flutter/material.dart';

class Deneme extends StatefulWidget {
  @override
  _DenemeState createState() => _DenemeState();
}

class _DenemeState extends State<Deneme> {
  Timer _timer;
  double y = 50;
  double x = 50;

  buyut() {
    _timer = Timer.periodic(Duration(microseconds: 100), (timer) {
      setState(() {
        y++;
        x++;
        if (x == 100) {
          timer.cancel();
        }
      });
    });
  }

  durdur() {
    setState(() {
      _timer.cancel();
    });
  }

  kucult() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        y--;
        x--;
        if (x == 10) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              height: y,
              width: x,
              color: Colors.red,
            ),
            onTapDown: (details) {
              buyut();
            },
            onTapUp: (details) {
              setState(() {
                x = 50;
                y = 50;
                _timer.cancel();
              });
            },
          ),
          GestureDetector(
            child: Container(
              height: 50,
              width: 50,
              color: Colors.black,
            ),
            onTap: durdur,
          ),
          GestureDetector(
            child: Container(
              height: 50,
              width: 50,
              color: Colors.blue,
            ),
            onLongPress: kucult,
          )
        ],
      )),
    );
  }
}
