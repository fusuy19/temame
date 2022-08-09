import 'package:dersasistan/FarkliCozunurlukAyarSinifi.dart';
import 'package:flutter/material.dart';

class YonButonlari extends StatelessWidget {
  final color;
  final icon;
  final function;

  const YonButonlari({Key key, this.color, this.icon, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1),
      child: GestureDetector(
        onTap: function,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(

                gradient: RadialGradient(
                  radius: .6,

                    //begin: Alignment.topRight,
                    //end: Alignment.bottomLeft,
                    colors: [Colors.white, color,Colors.transparent])),

            height: SizeConfig.blockSizeVertical*11,
            width: SizeConfig.blockSizeHorizontal*20,
            child: Icon(icon, color: Colors.black,),
          ),
        ),
      ),
    );
  }
}
