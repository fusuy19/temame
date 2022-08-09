import 'package:dersasistan/AnaSayfa/LevelGirisSayfasi.dart';
import 'package:dersasistan/AnaSayfa/Magaza.dart';
import 'package:dersasistan/AyarSayfasi.dart';
import 'package:dersasistan/FarkliCozunurlukAyarSinifi.dart';
import 'package:dersasistan/VeriTabani/Database.dart';
import 'package:dersasistan/VeriTabani/PuanListesi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OyunModuSecimi extends StatefulWidget {

  @override
  _OyunModuSecimiState createState() => _OyunModuSecimiState();
}

class _OyunModuSecimiState extends State<OyunModuSecimi> {
  DbHelper _dbHelper;
  List enBuyukIndeks = [];
  int enSonPuan;





  @override
  void initState() {

    _dbHelper = DbHelper();
    if (_dbHelper != null) {
      _dbHelper.istatistikleriGetir().then((value) {
        if (value.length != 0) {
          enSonPuan = int.parse(value.last.adim);
          value.forEach((element) {
            enBuyukIndeks.add(element.id);
            enBuyukIndeks.reversed;
          });
        }
      });
    } else {
      setState(() {
        enBuyukIndeks = [0];
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: new BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/arkaplanlar/covid.png"),fit: BoxFit.cover,colorFilter: ColorFilter.srgbToLinearGamma()),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.grey, Colors.teal,])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(60),
                    shadowColor: Colors.blue[900],
                    elevation: 60,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,

                              colors: [
                                Colors.blue,
                                Colors.red,

                              ])),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(60.0)),
                        minWidth: SizeConfig.blockSizeHorizontal * 50,
                        height: SizeConfig.blockSizeVertical * 10,
                        child: Row(
                          children: [
                            Icon(Icons.play_circle_fill_rounded,size: SizeConfig.safeBlockHorizontal*12,),
                            Text(
                              "İLERLEMELİ OYUN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.safeBlockHorizontal * 6,
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPressed: () async {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LevelGirisSayfasi(
                                          levelindeks: enBuyukIndeks.length == 0
                                              ? 0
                                              : enSonPuan == 0
                                                  ? enBuyukIndeks.length - 1
                                                  : enBuyukIndeks.length)));
                        },
                      ),
                    ),
                  ),
                ),
                Text("kjsdfkdsfkl",style: TextStyle(color: Colors.yellow),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(60),
                    shadowColor: Colors.blue[900],
                    elevation: 60,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,

                              colors: [
                                Colors.blue,
                                Colors.red,

                              ])),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(60.0)),
                        minWidth: SizeConfig.blockSizeHorizontal * 50,
                        height: SizeConfig.blockSizeVertical * 10,
                        child: Row(
                          children: [
                            Icon(Icons.play_circle_outline,size: SizeConfig.safeBlockHorizontal*12,),
                            Text(
                              "SERBEST OYUN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.safeBlockHorizontal * 6,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AyarSayfasi()));
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(60),
                    shadowColor: Colors.blue[900],
                    elevation: 60,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,

                              colors: [
                                Colors.blue,
                                Colors.red,

                              ])),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(60.0)),
                        minWidth: SizeConfig.blockSizeHorizontal * 50,
                        height: SizeConfig.blockSizeVertical * 10,
                        child: Row(
                          children: [
                            Icon(Icons.score,size: SizeConfig.safeBlockHorizontal*12,),
                            Text(
                              "SKOR TABLOSU",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.safeBlockHorizontal * 6,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Siralama()));
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(60),
                    shadowColor: Colors.blue[900],
                    elevation: 60,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,

                              colors: [
                                Colors.blue,
                                Colors.red,

                              ])),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(60.0)),
                        minWidth: SizeConfig.blockSizeHorizontal * 50,
                        height: SizeConfig.blockSizeVertical * 10,
                        child: Row(
                          children: [
                            Icon(Icons.shopping_cart,size: SizeConfig.safeBlockHorizontal*12,),
                            Text(
                              "MAĞAZA",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.safeBlockHorizontal * 6,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Magaza()));
                        },
                      ),
                    ),
                  ),
                ),


               /* Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    elevation: 40,
                    child: Text(
                      "..xx.",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () async {
                      _dbHelper.veriTabaniSil();
                    },
                    color: Colors.transparent,
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
