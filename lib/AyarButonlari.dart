import 'package:flutter/material.dart';

class AyarButonlari extends StatefulWidget {
  final tur;
  final color;
  final turIcon;
  final turIconRenk;
  final turDeger;
  final turFonksiyonEkle;
  final turFonksiyonCikar;

  const AyarButonlari(
      {Key key,
      this.tur,
      this.color,
      this.turIcon,
      this.turDeger,
      this.turFonksiyonEkle,
      this.turFonksiyonCikar,
      this.turIconRenk})
      : super(key: key);

  @override
  _AyarButonlariState createState() => _AyarButonlariState();
}

class _AyarButonlariState extends State<AyarButonlari> {
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
            Container(
                alignment: Alignment.center,
                width: 60,
                child: FlatButton(
                  child: Center(
                      child: Icon(
                    Icons.add,
                    size: 40,
                  )),
                  onPressed: widget.turFonksiyonEkle,
                )),
            Container(
                width: 60,
                child: FlatButton(
                  child: Icon(
                    Icons.remove,
                    size: 40,
                  ),
                  onPressed: widget.turFonksiyonCikar,
                )),
          ],
        ),
      ),
    );
  }
}
