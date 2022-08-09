import 'package:flutter/material.dart';

class AyarButonlari2 extends StatefulWidget {
  final tur;
  final color;
  final turIcon;
  final turIconRenk;
  final turDeger;
  final flatButtonEkle;
  final flatButtonCikar;

  const AyarButonlari2(
      {Key key,
      this.tur,
      this.color,
      this.turIcon,
      this.turDeger,
      this.turIconRenk,
      this.flatButtonEkle,
      this.flatButtonCikar})
      : super(key: key);

  @override
  _AyarButonlariState createState() => _AyarButonlariState();
}

class _AyarButonlariState extends State<AyarButonlari2> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              child: Text(
                widget.tur,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 40,
                  color: widget.color,
                  height: 40,
                  child: Icon(
                    widget.turIcon,
                    size: 40,
                    color: widget.turIconRenk,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 40,
                  child: Text(
                    "${widget.turDeger}",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
            Container(width: 60, child: widget.flatButtonEkle),
            Container(width: 60, child: widget.flatButtonCikar),
          ],
        ),
      ),
    );
  }
}
