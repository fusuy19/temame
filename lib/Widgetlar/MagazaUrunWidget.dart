import 'dart:async';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:dersasistan/FarkliCozunurlukAyarSinifi.dart';
import 'package:flutter/material.dart';

class MagazaUrunWidget extends StatefulWidget {
  final karakterSecmeFonksiyonu;
  final karakterOncedenAlinmisMi;
  final karakterAlindiMi;
  final karakterResim;
  final paraResim;
  final karakterDeger;
  final satinAlmaFonksiyonu;
  final bitisIcon;
  final ozellikDeger;

  const MagazaUrunWidget({
    Key key,
    this.karakterAlindiMi,
    this.karakterResim,
    this.paraResim,
    this.karakterDeger,
    this.satinAlmaFonksiyonu,
    this.bitisIcon,
    this.ozellikDeger,
    this.karakterSecmeFonksiyonu,
    this.karakterOncedenAlinmisMi,
  }) : super(key: key);

  @override
  _MagazaUrunWidgetState createState() => _MagazaUrunWidgetState();
}

class _MagazaUrunWidgetState extends State<MagazaUrunWidget> {
  Timer _timer;
  double y = 17;
  double x = 17;

  buyut() {
    _timer = Timer.periodic(Duration(microseconds: 200), (timer) {
      setState(() {
        y++;
        x++;
        if (x == 24) {
          timer.cancel();
          kucult();
        }
      });
    });
  }

  kucult() {
    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        y--;
        x--;
        if (x == 17) {
          timer.cancel();
          buyut();
        }
      });
    });
  }

  @override
  void initState() {
    buyut();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: widget.karakterAlindiMi ? Colors.green[600] : Colors.grey,
      borderRadius: BorderRadius.circular(30),
      shadowColor: Colors.blue[900],
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black54, width: 3)),
        height: SizeConfig.blockSizeVertical * 33,
        width: SizeConfig.blockSizeHorizontal * 25,
        child: Column(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 14,
              child: GestureDetector(
                onTap: widget.karakterSecmeFonksiyonu,
                child: Image.asset(
                  widget.karakterResim,
                  height: widget.karakterOncedenAlinmisMi
                      ? SizeConfig.blockSizeVertical * x
                      : SizeConfig.blockSizeVertical * 17,
                  width: widget.karakterOncedenAlinmisMi
                      ? SizeConfig.blockSizeHorizontal * y
                      : SizeConfig.blockSizeHorizontal * 17,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Material(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        widget.paraResim,
                        height: SizeConfig.blockSizeVertical * 4,
                        width: SizeConfig.blockSizeHorizontal * 4,
                      ),
                      Text(
                        ": ${widget.karakterDeger}",
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                widget.karakterAlindiMi == true &&
                        widget.karakterOncedenAlinmisMi == false
                    ? Container(
                       // height: 70,
                        child: IconButton(
                            splashColor: Colors.red,
                            splashRadius: SizeConfig.safeBlockHorizontal*8,
                            iconSize: SizeConfig.safeBlockHorizontal * (x - 15),
                            icon: Icon(widget.bitisIcon),
                            onPressed: widget.satinAlmaFonksiyonu),
                      )
                    : widget.karakterOncedenAlinmisMi
                        ? RaisedButton.icon(
                  color: Colors.transparent,
                            onPressed: widget.karakterSecmeFonksiyonu,
                            icon: Icon(
                              Icons.fast_forward,
                              size: SizeConfig.safeBlockHorizontal * 7,
                            ),
                            label: Text(
                              "Seç",
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3),
                            ),
                          )
                        : Icon(
                            Icons.clear,
                            size: SizeConfig.safeBlockHorizontal * 8,
                          ),
                Text(
                  " ${widget.ozellikDeger}",
                  style:
                      TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
