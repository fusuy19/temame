import 'dart:math';

import 'package:dersasistan/AnaSayfa/LevelGirisSayfasi.dart';
import 'package:dersasistan/FarkliCozunurlukAyarSinifi.dart';
import 'package:dersasistan/VeriTabani/Database.dart';
import 'package:dersasistan/Widgetlar/MagazaUrunWidget.dart';
import 'package:flutter/material.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Magaza extends StatefulWidget {
  @override
  _MagazaState createState() => _MagazaState();
}

class _MagazaState extends State<Magaza> {
  DbHelper _dbHelper;
  bool orumcekAdamOncedenAlindiMi = false;
  bool batmanOncedenAlindiMi = false;
  bool supermanOncedenAlindiMi = false;
  bool orumcekAdamAlindiMi = false;
  bool batmanAlindiMi = false;
  bool supermanAlindiMi = false;
  bool gorunmezlikAlindiMi = false;
  bool dezenfektanAlindiMi = false;
  bool maskeAlindiMi = false;

  int toplamAlt = 0;
  int toplamElm = 0;
  int orumcekAdamFiyat = 10000;
  int batmanFiyat = 20000;
  int supermanFiyat = 30000;

  int maskeFiyat = 20;
  int gorunmezlikFiyat = 200;
  int dezenfektanFiyat = 100;

  List toplamElmas = [];
  List toplamAltin = [];
  List enBuyukIndeks = [];
  List orumcekAdamListe = [];
  List batmanListe = [];
  List supermanListe = [];
  List toplamHarcananAltinListe = [];
  List toplamHarcananElmasListe = [];
  int enSonPuan;
  int toplamHarcananAltin = 0;
  int toplamHarcananElmas = 0;

  int dezenfektan = 0;
  int maske = 0;
  int gorunmezlik = 0;
  int alinanDezenfektan = 0;
  int alinanMaske = 0;
  int alinanGorunmezlik = 0;
  int harcananElmas = 0;
  int harcananAltin = 0;

  istatistikGonder() async {
    await _dbHelper.istatistikleriGetir().then((value) {
      if (value.length != 0) {
        _dbHelper
            .istatistikEkle(
          Istatistikler(
              id: value.last.id,
              adim: value.last.adim,
              sure: value.last.sure,
              dezenfektan: "$dezenfektan",
              maske: "$maske",
              gorunmezlik: "$gorunmezlik",
              orumcekAdam: value.last.orumcekAdam != "true"
                  ? batmanAlindiMi || supermanAlindiMi
                      ? "false"
                      : "$orumcekAdamAlindiMi"
                  : batmanAlindiMi || supermanAlindiMi
                      ? "false"
                      : value.last.orumcekAdam,
              batman: value.last.batman != "true"
                  ? orumcekAdamAlindiMi || supermanAlindiMi
                      ? "false"
                      : "$batmanAlindiMi"
                  : orumcekAdamAlindiMi || supermanAlindiMi
                      ? "false"
                      : value.last.batman,
              superman: value.last.superman != "true"
                  ? batmanAlindiMi || orumcekAdamAlindiMi
                      ? "false"
                      : "$supermanAlindiMi"
                  : orumcekAdamAlindiMi || batmanAlindiMi
                      ? "false"
                      : value.last.superman,
              harcananElmas: harcananElmas != 0
                  ? "$harcananElmas"
                  : value.last.harcananElmas,
              harcananAltin: harcananAltin != 0
                  ? "$harcananAltin"
                  : value.last.harcananAltin),
        )
            .catchError((e) {
          _dbHelper.istatistikGuncelle(Istatistikler(
              id: value.last.id,
              adim: value.last.adim,
              sure: value.last.sure,
              dezenfektan: "$dezenfektan",
              maske: "$maske",
              gorunmezlik: "$gorunmezlik",
              orumcekAdam: value.last.orumcekAdam != "true"
                  ? batmanAlindiMi || supermanAlindiMi
                      ? "false"
                      : "$orumcekAdamAlindiMi"
                  : batmanAlindiMi || supermanAlindiMi
                      ? "false"
                      : value.last.orumcekAdam,
              batman: value.last.batman != "true"
                  ? orumcekAdamAlindiMi || supermanAlindiMi
                      ? "false"
                      : "$batmanAlindiMi"
                  : orumcekAdamAlindiMi || supermanAlindiMi
                      ? "false"
                      : value.last.batman,
              superman: value.last.superman != "true"
                  ? batmanAlindiMi || orumcekAdamAlindiMi
                      ? "false"
                      : "$supermanAlindiMi"
                  : orumcekAdamAlindiMi || batmanAlindiMi
                      ? "false"
                      : value.last.superman,
              harcananElmas: harcananElmas != 0
                  ? "$harcananElmas"
                  : value.last.harcananElmas,
              harcananAltin: harcananAltin != 0
                  ? "$harcananAltin"
                  : value.last.harcananAltin));
        });
      }
    });
  }

  ekle(int karakter) {
    setState(() {
      if (karakter == orumcekAdamFiyat) {
        if (karakter <= toplamAlt && orumcekAdamAlindiMi == false) {
          toplamAlt = toplamAlt - orumcekAdamFiyat;
          orumcekAdamAlindiMi = true;
          //orumcekAdamOncedenAlindiMi = true;

          batmanAlindiMi = false;
          supermanAlindiMi = false;
        }
      } else if (karakter == batmanFiyat) {
        if (karakter <= toplamAlt && batmanAlindiMi == false) {
          toplamAlt = toplamAlt - batmanFiyat;
          batmanAlindiMi = true;
         // batmanOncedenAlindiMi = true;

          supermanAlindiMi = false;
          orumcekAdamAlindiMi = false;
        }
      } else if (karakter == supermanFiyat) {
        if (karakter <= toplamAlt && supermanAlindiMi == false) {
          toplamAlt = toplamAlt - supermanFiyat;
          supermanAlindiMi = true;
         // supermanOncedenAlindiMi = true;

          batmanAlindiMi = false;
          orumcekAdamAlindiMi = false;
        }
      } else if (karakter == gorunmezlikFiyat) {
        if (karakter <= toplamElm) {
          toplamElm = toplamElm - gorunmezlikFiyat;
          gorunmezlik++;
          alinanGorunmezlik++;
        }
      } else if (karakter == dezenfektanFiyat) {
        if (karakter <= toplamElm) {
          toplamElm = toplamElm - dezenfektanFiyat;
          dezenfektan++;
          alinanDezenfektan++;
        }
      }
    });
  }

  harcananParaHesapla() {
    if (orumcekAdamAlindiMi) {
      harcananAltin = harcananAltin + orumcekAdamFiyat;
    } else if (batmanAlindiMi) {
      harcananAltin = harcananAltin + batmanFiyat;
    } else if (supermanAlindiMi) {
      harcananAltin = harcananAltin + supermanFiyat;
    } else {
      harcananElmas = alinanMaske * maskeFiyat +
          alinanGorunmezlik * gorunmezlikFiyat +
          alinanDezenfektan * dezenfektanFiyat;
    }
  }

  @override
  void initState() {
    _dbHelper = DbHelper();
    if (_dbHelper != null) {
      _dbHelper.istatistikleriGetir().then((value) {
        if (value.length != 0) {
          enSonPuan = int.parse(value.last.adim);
          setState(() {
            dezenfektan = int.parse(value.last.dezenfektan);
            maske = int.parse(value.last.maske);
            gorunmezlik = int.parse(value.last.gorunmezlik);
          });

          value.forEach((element) {
            orumcekAdamListe.add(element.orumcekAdam);
            if (orumcekAdamListe.contains("true")) {
              orumcekAdamOncedenAlindiMi = true;
             // print("orumcek");
            }
            batmanListe.add(element.batman);
            if (batmanListe.contains("true")) {
              batmanOncedenAlindiMi = true;
             // print("batman");
            }
            supermanListe.add(element.superman);
            if (supermanListe.contains("true")) {
              supermanOncedenAlindiMi = true;
             // print("superman");
            }
            enBuyukIndeks.add(element.id);
            enBuyukIndeks.reversed;
          });
        }
      });
    } else {
      enBuyukIndeks = [0];
    }

    _dbHelper.istatistikleriGetir().then((value) => value.forEach((element) {
          toplamElmas.add(int.parse(element.adim));
          toplamElm = toplamElmas.fold(
              0, (previousValue, element) => previousValue + element);

          toplamHarcananAltinListe.add(int.parse(
              element.harcananAltin != null ? element.harcananAltin : "0"));
          toplamHarcananAltinListe.removeWhere((element) => element == "0");
          toplamHarcananAltin = toplamHarcananAltinListe.fold(
              0, (previousValue, element) => previousValue + element);

          toplamHarcananElmasListe.add(int.parse(
              element.harcananElmas != null ? element.harcananElmas : "0"));
          toplamHarcananElmasListe.removeWhere((element) => element == "0");
          toplamHarcananElmas = toplamHarcananElmasListe.fold(
              0, (previousValue, element) => previousValue + element);

          toplamAltin.add(int.parse(element.sure));
          toplamAlt = toplamAltin.fold(
              0, (previousValue, element) => previousValue + element);
          setState(() {
            if (batmanAlindiMi) {
              toplamAlt = toplamAlt - batmanFiyat;
            } else if (supermanAlindiMi) {
              toplamAlt = toplamAlt - supermanFiyat;
            } else if (orumcekAdamAlindiMi) {
              toplamAlt = toplamAlt - orumcekAdamFiyat;
            }
          });
          setState(() {
            toplamAlt = toplamAlt - toplamHarcananAltin;
          });

          setState(() {
            toplamElm = toplamElm - toplamHarcananElmas;
          });
        }));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/arkaplanlar/covid.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma()
            ),
          ),
          child: ListView(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "elmas.png",
                            height: SizeConfig.blockSizeVertical * 8,
                            width: SizeConfig.blockSizeHorizontal * 8,
                          ),
                          Text(
                            " :$toplamElm",
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 6),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "altin2.png",
                            height: SizeConfig.blockSizeVertical * 8,
                            width: SizeConfig.blockSizeHorizontal * 8,
                          ),
                          Text(
                            " :$toplamAlt",
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 6),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MagazaUrunWidget(
                        karakterSecmeFonksiyonu: orumcekAdamOncedenAlindiMi
                            ? () {
                                setState(() {
                                  orumcekAdamAlindiMi = true;
                                  batmanAlindiMi = false;
                                  supermanAlindiMi = false;
                                });
                              }
                            : null,
                        karakterOncedenAlinmisMi: orumcekAdamOncedenAlindiMi,
                        karakterAlindiMi: orumcekAdamFiyat <= toplamAlt,
                        karakterResim: "assets/karakterler/orumcekadam.png",
                        paraResim: "altin2.png",
                        karakterDeger: orumcekAdamFiyat,
                        bitisIcon: orumcekAdamAlindiMi?null:Icons.add,
                        ozellikDeger: orumcekAdamAlindiMi ? "ok" : "",
                        satinAlmaFonksiyonu: orumcekAdamOncedenAlindiMi == false
                            ? () {
                                ekle(orumcekAdamFiyat);
                              }
                            : null),
                    MagazaUrunWidget(
                        karakterSecmeFonksiyonu: batmanOncedenAlindiMi
                            ? () {
                                setState(() {
                                  orumcekAdamAlindiMi = false;
                                  batmanAlindiMi = true;
                                  supermanAlindiMi = false;
                                });
                              }
                            : null,
                        karakterOncedenAlinmisMi: batmanOncedenAlindiMi,
                        karakterAlindiMi: batmanFiyat <= toplamAlt,
                        karakterResim: "assets/karakterler/batman.png",
                        paraResim: "altin2.png",
                        karakterDeger: batmanFiyat,
                        bitisIcon: batmanAlindiMi?null:Icons.add,
                        ozellikDeger: batmanAlindiMi ? "ok" : "",
                        satinAlmaFonksiyonu: batmanOncedenAlindiMi == false
                            ? () {
                                ekle(batmanFiyat);
                              }
                            : null),
                    MagazaUrunWidget(
                        karakterSecmeFonksiyonu: supermanOncedenAlindiMi
                            ? () {
                                setState(() {
                                  orumcekAdamAlindiMi = false;
                                  batmanAlindiMi = false;
                                  supermanAlindiMi = true;
                                });
                              }
                            : null,
                        karakterOncedenAlinmisMi: supermanOncedenAlindiMi,
                        karakterAlindiMi: supermanFiyat <= toplamAlt,
                        karakterResim: "assets/karakterler/superman.png",
                        paraResim: "altin2.png",
                        karakterDeger: supermanFiyat,
                        bitisIcon: supermanAlindiMi?null:Icons.add,
                        ozellikDeger: supermanAlindiMi ? "ok" : "",
                        satinAlmaFonksiyonu: supermanOncedenAlindiMi == false
                            ? () {
                                ekle(supermanFiyat);
                              }
                            : null),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MagazaUrunWidget(
                      karakterOncedenAlinmisMi: false,
                      karakterAlindiMi: gorunmezlikFiyat <= toplamElm,
                      karakterResim: "tulumkask.png",
                      paraResim: "elmas.png",
                      karakterDeger: gorunmezlikFiyat,
                      bitisIcon: Icons.add,
                      ozellikDeger: "$gorunmezlik",
                      satinAlmaFonksiyonu: () {
                        ekle(gorunmezlikFiyat);
                      }),
                  MagazaUrunWidget(
                      karakterOncedenAlinmisMi: false,
                      karakterAlindiMi: dezenfektanFiyat <= toplamElm,
                      karakterResim: "dezenfektantemiz.png",
                      paraResim: "elmas.png",
                      karakterDeger: dezenfektanFiyat,
                      bitisIcon: Icons.add,
                      ozellikDeger: "$dezenfektan",
                      satinAlmaFonksiyonu: () {
                        ekle(dezenfektanFiyat);
                      }),
                  MagazaUrunWidget(
                      karakterOncedenAlinmisMi: false,
                      karakterAlindiMi: maskeFiyat <= toplamElm,
                      karakterResim: "maske.png",
                      paraResim: "elmas.png",
                      karakterDeger: maskeFiyat,
                      bitisIcon: Icons.add,
                      ozellikDeger: "$maske",
                      satinAlmaFonksiyonu: () {
                        setState(() {
                          toplamElm = toplamElm - maskeFiyat;
                          maske++;
                          alinanMaske++;
                        });
                      }),
                ],
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

                              Colors.red,
                              Colors.blue
                            ])),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(60.0)),
                      minWidth: SizeConfig.blockSizeHorizontal * 10,
                      height: SizeConfig.blockSizeVertical * 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.forward,
                              size: SizeConfig.blockSizeHorizontal * 8),
                          Text(
                            "LEVEL EKRANINA GİT",
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 5,
                               color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        harcananParaHesapla();
                        istatistikGonder();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
            ],
          ),
        ),
      ),
    );
  }
}
