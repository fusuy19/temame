import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dersasistan/AnaSayfa/AnaSayfa.dart';
import 'package:dersasistan/AnaSayfa/OyunModuSecimi.dart';
import 'package:dersasistan/AyarButonlari.dart';
import 'package:dersasistan/AyarButonlari2.dart';
import 'package:dersasistan/FarkliCozunurlukAyarSinifi.dart';
import 'package:dersasistan/Sorular.dart';
import 'package:flutter/material.dart';

class AyarSayfasi extends StatefulWidget {
  final blokSayisi;
  final sutunSayisi;
  final dostunYeri;
  final hiz;
  final List<int> taslar;
  final List<int> dusmanlar;
  final atesHakki;

  const AyarSayfasi({
    Key key,
    this.blokSayisi,
    this.sutunSayisi,
    this.dostunYeri,
    this.hiz,
    this.taslar,
    this.dusmanlar,
    this.atesHakki,
  }) : super(key: key);

  @override
  _AyarSayfasiState createState() => _AyarSayfasiState();
}

class _AyarSayfasiState extends State<AyarSayfasi> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int blokSayisi = 36;
  int sutunSayisi = 6;
  int dostunYeri;
  int hiz = 2000;
  List<int> taslar = [];
  List<int> dusmanlar = [];
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  Icon atesHakkiSonucu;

  int atesHakki = 3;

  oyundanGelenVeri() {
    if (widget.blokSayisi != null) {
      blokSayisi = widget.blokSayisi;
      sutunSayisi = widget.sutunSayisi;
      hiz = widget.hiz;
      taslar = widget.taslar;
      dusmanlar = widget.dusmanlar;
      atesHakki = widget.atesHakki;
    }
  }

  dusmanEkle() {
    initPlayer();
    audioCache.play("butonclick.mp3");
    int yeniDusman = blokSayisi - 1;
    setState(() {
      dusmanlar.add(yeniDusman);
    });
  }

  dusmanCikar() {
    initPlayer();
    audioCache.play("butonclick.mp3");
    setState(() {
      if (dusmanlar.isNotEmpty) {
        dusmanlar.removeLast();
      }
    });
  }

  tasEkle() {
    initPlayer();
    audioCache.play("butonclick.mp3");
    int yeniTas = Random().nextInt(blokSayisi);
    setState(() {
      if (yeniTas != dostunYeri &&
          taslar.contains(yeniTas) == false &&
          taslar.length < blokSayisi - 1) {
        taslar.add(yeniTas);
      }
    });
  }

  tasCikar() {
    initPlayer();
    audioCache.play("butonclick.mp3");
    setState(() {
      if (taslar.isNotEmpty) {
        taslar.removeLast();
      }
    });
  }

  Widget flatButton(int hizDegisim, Icon icon, int sutunSayisiDegisim) {
    return FlatButton(
      child: icon,
      onPressed: () {
        initPlayer();
        audioCache.play("butonclick.mp3");
        setState(() {
          // ignore: unnecessary_statements
          sutunSayisi = sutunSayisi + sutunSayisiDegisim;
          if (sutunSayisi < 2) {
            sutunSayisi = 2;
          } else if (sutunSayisi > 9) {
            sutunSayisi = 9;
          }

          blokSayisi = sutunSayisi * sutunSayisi;
          if (hizDegisim != 0) {
            hiz = hiz - ((hiz / hizDegisim).floor());
          } else {
            dostunYeri = Random().nextInt(blokSayisi);
            if (dostunYeri == 0) {
              dostunYeri = Random().nextInt(blokSayisi);
            }
          }

          if (hiz < 125) {
            hiz = 125;
          }
          if (hiz > 2000) {
            hiz = 2000;
          }
        });
      },
    );
  }

  @override
  void initState() {
    oyundanGelenVeri();
    dostunYeri = Random().nextInt(blokSayisi);
    while (taslar.contains(dostunYeri) || dostunYeri == 0) {
      dostunYeri = Random().nextInt(blokSayisi);
    }
    super.initState();
  }

  void initPlayer() {
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);
  }

  SorularSinifi sorularSinifi = SorularSinifi();
  int sira = 0;

  dogruMu(String yanit) {
    if (yanit == sorularSinifi.sorular[sira].cevap) {
      initPlayer();
      audioCache.play("okey.mp3");
      setState(() {
        atesHakki++;
        atesHakkiSonucu = Icon(
          Icons.check,
          size: 60,
          color: Colors.green[700],
        );
        sira++;
        Navigator.of(context).pop(false);
      });
    } else {
      initPlayer();
      audioCache.play("carpi.m4a");
      setState(() {
        atesHakkiSonucu = Icon(
          Icons.clear,
          size: 60,
          color: Colors.red,
        );
        sira++;
        Navigator.of(context).pop(false);
      });
    }
  }

  snakBarGoster() {
    final snackBar = SnackBar(
        content: Text(
          "Başka soru kalmadı",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3));

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  alertDiyalog() {
    var alert = AlertDialog(
      title: Text("Soru"),
      content: Text("${sorularSinifi.sorular[sira].soru}"),
      actions: [
        RaisedButton(
          child: Text("${sorularSinifi.sorular[sira].aYaniti}"),
          onPressed: () {
            dogruMu(sorularSinifi.sorular[sira].aYaniti);
          },
        ),
        RaisedButton(
          child: Text("${sorularSinifi.sorular[sira].bYaniti}"),
          onPressed: () {
            dogruMu(sorularSinifi.sorular[sira].bYaniti);
          },
        ),
        RaisedButton(
          child: Text("${sorularSinifi.sorular[sira].cYaniti}"),
          onPressed: () {
            dogruMu(sorularSinifi.sorular[sira].cYaniti);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Serbest Oyun Modu"),
        ),
        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/arkaplanlar/sosyalMesafe.png"),
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.plus),
              fit: BoxFit.cover,
              //   colorFilter: ColorFilter.linearToSrgbGamma()
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      "İSTEDİĞİN AYARLARI SEÇ VE BAŞLA",
                      style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                    ),
                    atesHakkiSonucu != null ? atesHakkiSonucu : Text(""),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "dezenfektantemiz.png",
                          height: 50,
                          width: 50,
                        ),
                        Text(
                          " : $atesHakki",
                          style: TextStyle(fontSize: 30),
                        ),
                        FlatButton.icon(
                          splashColor: Colors.red,
                          highlightColor: Colors.blue,
                          label: Text(""),
                          icon: Icon(

                            Icons.add,
                            size: 40,
                          ),
                          onPressed: () {
                            setState(() {
                              if (sira < 8) {
                                alertDiyalog();
                              } else {
                                snakBarGoster();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    AyarButonlari2(
                        tur: "Hız",
                        color: Colors.black,
                        turIcon: Icons.directions_run,
                        turIconRenk: Colors.amber,
                        turDeger: 2000 ~/ hiz,
                        flatButtonEkle: flatButton(

                            2,
                            Icon(
                              Icons.add,
                              size: 40,
                            ),
                            0),
                        flatButtonCikar: flatButton(
                            -1,
                            Icon(
                              Icons.remove,
                              size: 40,
                            ),
                            0)),
                    AyarButonlari2(
                        tur: "Blok",
                        color: Colors.green,
                        turDeger: blokSayisi,
                        flatButtonEkle: flatButton(
                            0,
                            Icon(
                              Icons.add,
                              size: 40,
                            ),
                            1),
                        flatButtonCikar: flatButton(
                            0,
                            Icon(
                              Icons.remove,
                              size: 40,
                            ),
                            -1)),
                    AyarButonlari(
                        tur: "Engel",
                        color: Colors.black45,
                        turIcon: Icons.do_not_disturb,
                        turDeger: taslar.length,
                        turFonksiyonEkle: tasEkle,
                        turFonksiyonCikar: tasCikar),
                    AyarButonlari(
                        tur: "Düşman",
                        color: Colors.black,
                        turIcon: Icons.ac_unit,
                        turIconRenk: Colors.amber,
                        turDeger: dusmanlar.length,
                        turFonksiyonEkle: dusmanEkle,
                        turFonksiyonCikar: dusmanCikar),
                  ],
                ),
                Column(
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
                            minWidth: SizeConfig.blockSizeHorizontal * 40,
                            height: SizeConfig.blockSizeVertical * 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_circle_outline,
                                  size: SizeConfig.safeBlockHorizontal * 12,
                                ),
                                Text(
                                  "BAŞLA",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 6,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AnaSayfa(
                                            blokSayisi: blokSayisi,
                                            sutunSayisi: sutunSayisi,
                                            dostunYeri: dostunYeri,
                                            hiz: hiz,
                                            taslar: taslar,
                                            dusmanlar: dusmanlar,
                                            atesHakki: atesHakki,
                                            tiklananindeks: 0,
                                            levelindeks: 0,
                                            ayarSayfasindanMiGelindi: true,
                                            gorunmezlikHakki: 1,
                                            maskeHakki: 1,
                                          )));
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
                            minWidth: SizeConfig.blockSizeHorizontal * 40,
                            height: SizeConfig.blockSizeVertical * 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home,
                                  size: SizeConfig.safeBlockHorizontal * 10,
                                  color: Colors.black,
                                ),
                                Text(
                                  "ANASAYFA",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 6,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OyunModuSecimi()));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
