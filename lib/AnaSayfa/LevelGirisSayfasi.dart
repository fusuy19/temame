import 'dart:async';
import 'package:dersasistan/AnaSayfa/AnaSayfa.dart';
import 'package:dersasistan/AnaSayfa/OyunModuSecimi.dart';
import 'package:dersasistan/Bolumler.dart';
import 'package:dersasistan/FarkliCozunurlukAyarSinifi.dart';
import 'package:dersasistan/VeriTabani/Database.dart';
import 'package:flutter/material.dart';

PageStorageBucket bucketGlobal = PageStorageBucket();

class LevelGirisSayfasi extends StatefulWidget {
  final sure;
  final adim;
  final kazandiMi;
  final levelindeks;
  final tiklananindeks;

  const LevelGirisSayfasi({
    Key key,
    this.kazandiMi,
    this.levelindeks,
    this.tiklananindeks,
    this.sure,
    this.adim,
  }) : super(key: key);

  @override
  _LevelGirisSayfasiState createState() => _LevelGirisSayfasiState();
}

class _LevelGirisSayfasiState extends State<LevelGirisSayfasi> {
  BolumlerSinifi bolumlerSinifi = BolumlerSinifi();
  int sure = 0;
  int adim = 0;
  int suredenGelenPuan = 0;
  int adimdanGelenPuan = 0;
  Timer timer;
  int levelindeks = 0;
  List enBuyukIndeks = [];

  void levelliGiris(int indeks) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (
      BuildContext context,
    ) =>
            AnaSayfa(
              levelindeks: levelindeks,
              tiklananindeks: indeks,
              blokSayisi: bolumlerSinifi.bolumler[indeks].blokSayisi,
              sutunSayisi: bolumlerSinifi.bolumler[indeks].sutunSayisi,
              dostunYeri: bolumlerSinifi.bolumler[indeks].dostunYeri,
              hiz: bolumlerSinifi.bolumler[indeks].hiz,
              taslar: bolumlerSinifi.bolumler[indeks].taslar,
              dusmanlar: bolumlerSinifi.bolumler[indeks].dusmanlar,
              atesHakki: bolumlerSinifi.bolumler[indeks].atesHakki,
              ayarSayfasindanMiGelindi: false,
            )));
  }

  @override
  initState() {
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer.periodic(Duration(milliseconds: 50), (timer1) {
      if (widget.sure != null) {
        setState(() {
          sure = widget.sure;
          adim = widget.adim;

          suredenGelenPuan++;
          adimdanGelenPuan++;
          if (suredenGelenPuan > widget.sure) {
            suredenGelenPuan = widget.sure;
          }
          if (adimdanGelenPuan > widget.adim) {
            adimdanGelenPuan = widget.adim;
          }
          if (widget.sure > widget.adim) {
            if (suredenGelenPuan == widget.sure) {
              timer1.cancel();
            }
          } else {
            if (adimdanGelenPuan == widget.adim) {
              timer1.cancel();
            }
          }
        });
      }
    });

    setState(() {
      if (widget.levelindeks != null) {
        levelindeks = widget.levelindeks;
      }
      if (widget.kazandiMi != null) {
        if (widget.kazandiMi == true) {
          if (widget.tiklananindeks < widget.levelindeks) {
            levelindeks = widget.levelindeks;
          } else {
            levelindeks++;
          }

          if (levelindeks > bolumlerSinifi.bolumler.length) {
            levelindeks = bolumlerSinifi.bolumler.length;
          }
        } else {
          levelindeks = widget.levelindeks;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: bucketGlobal,
      child: Scaffold(
        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/arkaplanlar/covid.png"),
              colorFilter: ColorFilter.srgbToLinearGamma(),
              fit: BoxFit.cover,
              //   colorFilter: ColorFilter.linearToSrgbGamma()
            ),
          ),
          child: GridView.count(

            key: PageStorageKey("grid"),
            crossAxisCount: 4,
            padding: EdgeInsets.only(top: 30, left: 10, right: 10),
            mainAxisSpacing: 0,
            shrinkWrap: true,
            children: List.generate(bolumlerSinifi.bolumler.length, (index) {
              return GridTile(
                  child: Card(
                elevation: 20,
                shadowColor: Colors.blue,
                child: Center(
                  child: GestureDetector(
                    onTap: () =>
                        levelindeks >= index ? levelliGiris(index) : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                levelindeks > index
                                    ? Colors.green[600]
                                    : levelindeks == index
                                        ? Colors.pink
                                        : Colors.black45,
                                Colors.white
                              ])),
                          height: SizeConfig.blockSizeVertical * 15,
                          width: SizeConfig.blockSizeHorizontal * 25,
                          /*color: levelindeks > index
                              ? Colors.green[800]
                              : levelindeks == index ? Colors.pink : Colors.grey,*/
                          child: Column(
                            children: [
                              levelindeks > index
                                  ? Icon(
                                      Icons.check,
                                      size: SizeConfig.blockSizeHorizontal * 10,
                                    )
                                  : levelindeks == index
                                      ? Expanded(
                                          child: Image.asset(
                                          "assets/kilitler/6acik.png",
                                          width:
                                              SizeConfig.safeBlockHorizontal *
                                                  10,
                                        ))
                                      : Expanded(
                                          child: Image.asset(
                                            "assets/kilitler/6.png",
                                            width:
                                                SizeConfig.safeBlockHorizontal *
                                                    13,
                                          ),
                                        ),
                              Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ));
            }),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/arkaplanlar/sosyalMesafe.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma(),
            ),
          ),
          //color: Colors.transparent,
          height: SizeConfig.blockSizeVertical * 30,
          child: BottomAppBar(
            color: Colors.transparent,
            //clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: CircularNotchedRectangle(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 15, right: 15, bottom: 10),
                  child: Container(
                      child: widget.sure != null && widget.kazandiMi
                          ? Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size:
                                                SizeConfig.safeBlockHorizontal *
                                                    9,
                                          ),
                                          Text(
                                            " :$sure",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    6),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "altin2.png",
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    5,
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    5,
                                          ),
                                          Text(
                                            " :$suredenGelenPuan x 10 = ${suredenGelenPuan * 10}",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    6),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.directions_run,
                                            size:
                                                SizeConfig.safeBlockHorizontal *
                                                    9,
                                          ),
                                          Text(
                                            " :$adim",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    6),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 25),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "elmas.png",
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      5,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  5,
                                            ),
                                            Text(
                                              " :$adimdanGelenPuan x 1 = ${adimdanGelenPuan * 1}",
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      6),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Text(""),
                      height: SizeConfig.blockSizeVertical * 15,
                      color: Colors.transparent),
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
                              color: Colors.white,
                            ),
                            Text(
                              "ANASAYFA",
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
                                  builder: (BuildContext context) =>
                                      OyunModuSecimi()));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
