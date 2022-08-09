import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dersasistan/AnaSayfa/LevelGirisSayfasi.dart';
import 'package:dersasistan/AnaSayfa/OyunModuSecimi.dart';
import 'package:dersasistan/AyarSayfasi.dart';
import 'package:dersasistan/Bolumler.dart';
import 'package:dersasistan/FarkliCozunurlukAyarSinifi.dart';
import 'package:dersasistan/VeriTabani/Database.dart';
import 'package:dersasistan/YonButonlari.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class AnaSayfa extends StatefulWidget {
  final blokSayisi;
  final sutunSayisi;
  final dostunYeri;
  final hiz;
  final List<int> taslar;
  final List<int> dusmanlar;
  final atesHakki;
  final levelindeks;
  final tiklananindeks;
  final ayarSayfasindanMiGelindi;
  final gorunmezlikHakki;
  final maskeHakki;

  const AnaSayfa({
    Key key,
    this.blokSayisi,
    this.sutunSayisi,
    this.dostunYeri,
    this.hiz,
    this.taslar,
    this.dusmanlar,
    this.atesHakki,
    this.levelindeks,
    this.tiklananindeks,
    this.ayarSayfasindanMiGelindi, this.gorunmezlikHakki, this.maskeHakki,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AnaSayfa> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DbHelper _dbHelper = DbHelper();
  Timer _timer;
  int sure = 60;
  int pozisyon = 0;
  Timer timer;
  Timer atesTimer;
  int ates;
  bool atesEdilmismi = false;
  int atesHiz;
  int atesHakki;
  int maskeHakki = 0;
  int gorunmezlikHakki = 0;
  int dezenfektanYeri;
  int adim = 20;
  final List<Color> arkaplanRenkListesi = [
    Colors.black,
    Colors.blueGrey[900],
    Colors.orange[900],
    Colors.pink[900],
    Colors.brown[900],
    Colors.blue[900],
    Colors.indigo[900],
    Colors.green[900],
    Colors.teal[900],
    Colors.purple[900],
  ];
  final List<Color> blokRenkListesi = [
    Colors.white,
    Colors.yellowAccent,
    Colors.lightBlueAccent[200],
    Colors.teal[100],
    Colors.greenAccent,
    Colors.purple[100],
    Colors.pink[200],
    Colors.white24,
    Colors.brown[200],
    Colors.orange[300],
  ];
  int arkaplanrenkSira = 0;
  int blokrenkSira = 0;

  AudioPlayer advancedPlayer;

  AudioCache audioCache = AudioCache();

  bool maske = false;
  bool gorunurMu = true;
  bool bolumuGectiMi;

  List enBuyukIndeks = [];

  bool orumcekAdamMi = false;

  bool batmanMi = false;

  bool supermanMi = false;

  gorunmezYap() {
    if (gorunurMu) {
      if (gorunmezlikHakki != 0) {
        gorunmezlikHakki--;
        //initPlayer();
        audioCache.play("gorunmezlik.m4a");
        setState(() {
          if (gorunurMu == true) {
            gorunurMu = false;
          } else {
            gorunurMu = true;
          }
        });
      }
    } else {}
  }

  //atesMaskeGorunmezlikHakkiAzalt(gorunmezlikHakki);

  arkaPlanRenkDegistir() {
    setState(() {
      arkaplanrenkSira++;
      if (arkaplanrenkSira > 9) {
        arkaplanrenkSira = 0;
      }
    });
  }

  blokRenkDegistir() {
    setState(() {
      blokrenkSira++;
      if (blokrenkSira > 9) {
        blokrenkSira = 0;
      }
    });
  }

  istatistikGonder(
      int id,
      String adim,
      String sure,
      String dezenfektan,
      String maske,
      String gorunmezlik,
      String orumcekAdam,
      String batman,
      String superman) {
    if (widget.tiklananindeks < widget.levelindeks) {
      _dbHelper.istatistikGuncelle(Istatistikler(
          id: id,
          adim: adim,
          sure: sure,
          dezenfektan: dezenfektan,
          maske: maske,
          gorunmezlik: gorunmezlik,
          orumcekAdam: orumcekAdam,
          batman: batman,
          superman: superman));
    } else {
      _dbHelper
          .istatistikEkle(Istatistikler(
              id: id,
              adim: adim,
              sure: sure,
              dezenfektan: dezenfektan,
              maske: maske,
              gorunmezlik: gorunmezlik,
              orumcekAdam: orumcekAdam,
              batman: batman,
              superman: superman))
          .catchError((e) {
        {
          _dbHelper.istatistikGuncelle(Istatistikler(
              id: id,
              adim: adim,
              sure: sure,
              dezenfektan: dezenfektan,
              maske: maske,
              gorunmezlik: gorunmezlik,
              orumcekAdam: orumcekAdam,
              batman: batman,
              superman: superman));
        }
      });
    }
  }

  kazandiMi() async {
    if (gorunurMu == true && widget.dusmanlar.contains(pozisyon)) {
      bolumuGectiMi = false;

      await istatistikGonder(
          widget.tiklananindeks,
          "0",
          "0",
          "$atesHakki",
          "$maskeHakki",
          "$gorunmezlikHakki",
          "$orumcekAdamMi",
          "$batmanMi",
          "$supermanMi");
      //await istatistikGonder(37, "1", "1", "$atesHakki", "$maskeHakki",
      //   "$gorunmezlikHakki", "false", "false", "false");
      sonuc(
        context,
        "Kaybettiniz",
        Icon(
          Icons.sentiment_very_dissatisfied,
          size: SizeConfig.safeBlockHorizontal * 10,
          color: Colors.orangeAccent,
        ),
        Icon(
          Icons.thumb_down,
          size: SizeConfig.safeBlockHorizontal * 10,
          color: Colors.orangeAccent,
        ),
      );
      //initPlayer();
      audioCache.play("kaybetme.mp3");
      oyunMuzigiStop();
//oyunMuzigiStop();
      timer.cancel();
      _timer.cancel();
      atesTimer.cancel();
      return;
    } else if (gorunurMu == true && maske == false) {
      if ((pozisyon % widget.sutunSayisi == 0 &&
              widget.dusmanlar.contains(pozisyon - 1)) ||
          pozisyon % widget.sutunSayisi == widget.sutunSayisi - 1 &&
              widget.dusmanlar.contains(pozisyon + 1)) {
      } else {
        if (widget.dusmanlar.contains(pozisyon - 1) ||
            widget.dusmanlar.contains(pozisyon + 1)) {
          bolumuGectiMi = false;
          await istatistikGonder(
              widget.tiklananindeks,
              "0",
              "0",
              "$atesHakki",
              "$maskeHakki",
              "$gorunmezlikHakki",
              "$orumcekAdamMi",
              "$batmanMi",
              "$supermanMi");
          /*await istatistikGonder(37, "1", "1", "$atesHakki", "$maskeHakki",
              "$gorunmezlikHakki", "false", "false", "false");*/

          sonuc(
            context,
            "Kaybettiniz",
            Icon(
              Icons.sentiment_very_dissatisfied,
              size: SizeConfig.safeBlockHorizontal * 10,
              color: Colors.orangeAccent,
            ),
            Icon(
              Icons.thumb_down,
              size: SizeConfig.safeBlockHorizontal * 10,
              color: Colors.orangeAccent,
            ),
          );
          // initPlayer();
          audioCache.play("kaybetme.mp3");
          oyunMuzigiStop();
          // oyunMuzigiStop();

          timer.cancel();
          _timer.cancel();
          atesTimer.cancel();

          return;
        }
      }
    }
    if (pozisyon == widget.dostunYeri) {
      bolumuGectiMi = true;
      await istatistikGonder(
          widget.tiklananindeks,
          "$adim",
          "${sure * 10}",
          "$atesHakki",
          "$maskeHakki",
          "$gorunmezlikHakki",
          "$orumcekAdamMi",
          "$batmanMi",
          "$supermanMi");

      sonuc(
        context,
        "Tebrikler, kazandınız",
        Icon(
          Icons.sentiment_very_satisfied,
          size: SizeConfig.safeBlockHorizontal * 10,
          color: Colors.orangeAccent,
        ),
        Icon(
          Icons.thumb_up,
          size: SizeConfig.safeBlockHorizontal * 10,
          color: Colors.orangeAccent,
        ),
      );
      //initPlayer();
      audioCache.play("kazanma.mp3");
      oyunMuzigiStop();
      timer.cancel();
      atesTimer.cancel();
      _timer.cancel();
      return;
    }
  }

  sayacBaslat() {
    if (timer != null) {
      timer.cancel();
    }

    setState(() {
      dezenfektanYeri = Random().nextInt(widget.blokSayisi);
      while (widget.taslar.contains(dezenfektanYeri) ||
          widget.dostunYeri == dezenfektanYeri) {
        dezenfektanYeri = Random().nextInt(widget.blokSayisi);
      }
      /*for (int i = 0; i < widget.dusmanlar.length; i++) {
        widget.dusmanlar[i] = widget.blokSayisi - 1;
      }*/
      timer = new Timer.periodic(Duration(milliseconds: widget.hiz), (timer) {
        setState(() {
          for (int i = 0; i < widget.dusmanlar.length; i++) {
            widget.dusmanlar[i] = widget.dusmanlar[i] - widget.sutunSayisi;
            if (widget.dusmanlar[i] < 0)
              widget.dusmanlar[i] =
                  widget.blokSayisi - Random().nextInt(widget.sutunSayisi);
          }
          kazandiMi();
          if (widget.dusmanlar.contains(ates)) {
            //initPlayer();
            audioCache.play("dusmanpatlama.mp3");
            widget.dusmanlar.removeWhere((element) => element == ates);
            ates = widget.blokSayisi + 100;
            atesEdilmismi = false;
          }
        });
      });
    });
  }

  dezenfektanAl() {
    setState(() {
      if (pozisyon == dezenfektanYeri) {
        dezenfektanYeri = Random().nextInt(widget.blokSayisi);
        while (widget.taslar.contains(dezenfektanYeri) ||
            widget.dostunYeri == dezenfektanYeri) {
          dezenfektanYeri = Random().nextInt(widget.blokSayisi);
        }
        atesHakki++;
        if (atesHakki > 99) {
          atesHakki = 99;
        }
      }
    });
  }

  atesEt() {
    if (atesTimer != null) {
      atesTimer.cancel();
    }

    setState(() {
      ates = widget.blokSayisi + 100;
      atesTimer = new Timer.periodic(Duration(milliseconds: 300), (timer2) {
        setState(() {
          if (atesEdilmismi) {
            ates = ates + widget.sutunSayisi;
            if (ates > widget.blokSayisi) {
              ates = widget.blokSayisi + 100;
            }

            if (widget.taslar.contains(ates)) {
              //    initPlayer();
              audioCache.play("engelpatlama.mp3");
              widget.taslar.removeWhere((element) => element == ates);
              ates = widget.blokSayisi + 100;
              atesEdilmismi = false;
            }
            if (widget.dusmanlar.contains(ates)) {
              // initPlayer();
              audioCache.play("dusmanpatlama.mp3");
              widget.dusmanlar.removeWhere((element) => element == ates);
              ates = widget.blokSayisi + 100;
              atesEdilmismi = false;
            }
            kazandiMi();
          }
        });
      });
    });
  }

  sonuc(BuildContext dialogContext, String text, Icon icon, Icon icon2) async {
    if (widget.tiklananindeks + 1 == BolumlerSinifi().bolumler.length &&
        bolumuGectiMi) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => OyunModuSecimi()

          /* builder: (BuildContext context) => AyarSayfasi(
              sutunSayisi: widget.sutunSayisi,
              blokSayisi: widget.blokSayisi,
              hiz: widget.hiz,
              taslar: widget.taslar,
              dusmanlar: widget.dusmanlar,
              atesHakki: atesHakki,
            )*/
          ));
    } else {
      widget.ayarSayfasindanMiGelindi?Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => AyarSayfasi(
            atesHakki: atesHakki,
          )

        /* builder: (BuildContext context) => AyarSayfasi(
              sutunSayisi: widget.sutunSayisi,
              blokSayisi: widget.blokSayisi,
              hiz: widget.hiz,
              taslar: widget.taslar,
              dusmanlar: widget.dusmanlar,
              atesHakki: atesHakki,
            )*/
      )):Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => LevelGirisSayfasi(
              sure: sure,
              adim: adim,
              levelindeks: widget.levelindeks,
              kazandiMi: bolumuGectiMi,
              tiklananindeks: widget.tiklananindeks)

        /* builder: (BuildContext context) => AyarSayfasi(
              sutunSayisi: widget.sutunSayisi,
              blokSayisi: widget.blokSayisi,
              hiz: widget.hiz,
              taslar: widget.taslar,
              dusmanlar: widget.dusmanlar,
              atesHakki: atesHakki,
            )*/
      ));
    }

    showDialog(
        context: context,
        builder: (dialogContex) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                widget.tiklananindeks + 1 == BolumlerSinifi().bolumler.length &&
                        bolumuGectiMi
                    ? Text(
                        "Harika iş çıkardın. Bütün bölümleri geçtin\n Yeni ve farklı bölümler için takipte kalınız",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: SizeConfig.safeBlockHorizontal * 6,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "$text",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: SizeConfig.safeBlockHorizontal * 6,
                            fontWeight: FontWeight.bold),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                    icon2,
                  ],
                ),
              ],
            ),
          );
        });
  }

  adimSayisi() {
    adim--;
    if (adim < 0) {
      adim = 0;
    }
  }

  altaRenkDegistir() {
    //initPlayer();
    audioCache.play("hareket.mp3");
    setState(() {
      if (widget.taslar.contains(pozisyon + widget.sutunSayisi) ||
          widget.taslar.contains(
              pozisyon - (widget.sutunSayisi * (widget.sutunSayisi - 1)))) {
        if (gorunurMu == false) {
          pozisyon = (pozisyon + widget.sutunSayisi) % widget.blokSayisi;
          adimSayisi();
        }
      } else {
        pozisyon = (pozisyon + widget.sutunSayisi) % widget.blokSayisi;
        adimSayisi();
      }
      kazandiMi();
      dezenfektanAl();
    });
  }

  sagaRenkDegistir() {
    //  initPlayer();
    audioCache.play("hareket.mp3");
    setState(() {
      if (gorunurMu == false) {
        if (pozisyon % widget.sutunSayisi == widget.sutunSayisi - 1) {
          pozisyon = pozisyon - widget.sutunSayisi + 1;
          adimSayisi();
        } else {
          pozisyon++;
          adimSayisi();
        }
      } else {
        if (pozisyon % widget.sutunSayisi == widget.sutunSayisi - 1) {
          if (widget.taslar.contains(pozisyon - widget.sutunSayisi + 1)) {
          } else {
            pozisyon = pozisyon - widget.sutunSayisi + 1;
            adimSayisi();
          }
        } else {
          pozisyon++;
          adimSayisi();
          if (widget.taslar.contains(pozisyon)) {
            pozisyon--;
            adim++;
          }
        }
      }

      /*pozisyon = (pozisyon + 1);
      if (widget.taslar.contains(pozisyon)) {
        if (gorunurMu == false) {
          pozisyon = (pozisyon + 1) % widget.blokSayisi;
        }
      } else {
        if (pozisyon % widget.sutunSayisi == 0) {
          pozisyon = pozisyon - widget.sutunSayisi;
        }
      }*/
      kazandiMi();
      dezenfektanAl();

      //tasSil();
    });
  }

  solaRenkDegistir() {
    // initPlayer();
    audioCache.play("hareket.mp3");
    setState(() {
      if (gorunurMu == false) {
        if (pozisyon % widget.sutunSayisi == 0) {
          pozisyon = pozisyon + widget.sutunSayisi - 1;
          adimSayisi();
        } else {
          pozisyon--;
          adimSayisi();
        }
      } else {
        if (pozisyon % widget.sutunSayisi == 0) {
          if (widget.taslar.contains(pozisyon + widget.sutunSayisi - 1)) {
          } else {
            pozisyon = pozisyon + widget.sutunSayisi - 1;
            adimSayisi();
          }
        } else {
          pozisyon--;
          adimSayisi();
          if (widget.taslar.contains(pozisyon)) {
            pozisyon++;
            adim++;
          }
        }
      }

      /* if (widget.taslar.contains(pozisyon )) {
        pozisyon++;
        if (gorunurMu == false) {
          pozisyon = (pozisyon - 1) % widget.blokSayisi;
        }
      } else {
        if (pozisyon % widget.sutunSayisi == widget.sutunSayisi - 1) {
          pozisyon = pozisyon + widget.sutunSayisi;
        }
      }*/
      kazandiMi();
      dezenfektanAl();
    });
  }

  usteRenkDegistir() {
    setState(() {
      if (widget.taslar.contains(pozisyon - widget.sutunSayisi) ||
          widget.taslar.contains(
              pozisyon + (widget.sutunSayisi * (widget.sutunSayisi - 1)))) {
        if (gorunurMu == false) {
          pozisyon = (pozisyon - widget.sutunSayisi) % widget.blokSayisi;
          adimSayisi();
        }
      } else {
        pozisyon = (pozisyon - widget.sutunSayisi) % widget.blokSayisi;
        adimSayisi();
      }
    });

    // initPlayer();
    audioCache.play("hareket.mp3");
    setState(() {
      kazandiMi();
      dezenfektanAl();
    });
  }

  tasSil() {
    if (atesHakki != 0) {
      atesHakki--;
    }
    // atesMaskeGorunmezlikHakkiAzalt(atesHakki);
    setState(() {
      //initPlayer();
      audioCache.play("fisfis.mp3");
      //audioCache.play("ates.mp3");
      ates = pozisyon;
      atesEdilmismi = true;
    });
  }

  Widget hangiKarakter() {
    if (orumcekAdamMi) {
      return Image.asset("assets/karakterler/orumcekadam.png");
    } else if (batmanMi) {
      return Image.asset("assets/karakterler/batman.png");
    } else if (supermanMi) {
      return Image.asset("assets/karakterler/superman.png");
    } else {
      return Image.asset("androidiconmaskesiz.png");
    }
  }

  karakterAlindiMiGetir() async {
    _dbHelper = DbHelper();
    await _dbHelper.istatistikleriGetir().then((value) {
      if (value.length != 0) {
        if (value.last.orumcekAdam == "false") {
          orumcekAdamMi = false;
        } else {
          orumcekAdamMi = true;
        }
        if (value.last.batman == "false") {
          batmanMi = false;
        } else {
          batmanMi = true;
        }
        if (value.last.superman == "false") {
          supermanMi = false;
        } else {
          supermanMi = true;
        }
        setState(() {
          gorunmezlikHakki = int.parse(value.last.gorunmezlik);
          maskeHakki = int.parse(value.last.maske);
          atesHakki = int.parse(value.last.dezenfektan);
        });
      }
    });
  }

  _oyunYonergeDialog(String yonerge) async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: [
                FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.clear),
                    label: Text("Tamam"))
              ],
              content: Container(
                  child: Text(
                yonerge,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              )));
        });
  }

  List<String> _yonergeler = [
    "Yön tuşlarını kullanarak eve git,görevin hep eve gitmek",
    "Viruslu kutular engeldir,etrafından dolaş",
    "Sola ya da yukarı basarak diğer taraflara geçiş yap",
    "Şıkıştığında dezenfektan tuşuna bas,virüslü yerler temizlensin",
    "Şimdi aşağıdan sana gelen virüse dezenfektan gönder",
    "Virüs yanından geçerse veya üzerine geldiğinde kaybedersin,virüsden uzak dur",
    "Virüslere karşı maske ,dezenfektan veya tulum kullanabilirsin,bunları mağazadan al",
    "Maske takarsan virüs yanından geçse de bişey olmaz",
    "Tulum giyersen virüslerden ve engellerden etkilenmezsin",
    "Ne kadar kısa sürede eve ulaşırsan o kadar çok altın kazanırsın,bunlarla kahraman alabilirsin",
    "Ne kadar az adımda eve ulaşırsan o kadar elmas kazanırsın,bunlarla dezenfektan,maske ve tulum alabilirsin",
    "En kısa sürede ve en az adımda eve git,başarılar!"
  ];

  tiklananindekseGoreYonerge(int tiklananindeks) {
    if (widget.tiklananindeks == tiklananindeks) {
      _oyunYonergeDialog(_yonergeler[tiklananindeks]);
    }
  }

  oyunmuzigiBaslat() async {
    advancedPlayer = await audioCache.play(
      "oyunmuzigi.mp3",
    );
  }

  oyunMuzigiStop() async {
    await advancedPlayer?.stop();
  }

  @override
  void dispose() {
    audioCache.clearCache();
    advancedPlayer?.stop();
    super.dispose();
  }

  ayarSayfasindanGelindiyse(){
    setState(() {
      gorunmezlikHakki=widget.gorunmezlikHakki;
      maskeHakki=widget.maskeHakki;
    });
  }
  @override
  void initState() {
    oyunmuzigiBaslat();
    for (int i = 0; i < _yonergeler.length; i++) {
      tiklananindekseGoreYonerge(i);
    }

    widget.ayarSayfasindanMiGelindi?ayarSayfasindanGelindiyse():karakterAlindiMiGetir();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        sure--;
        if (sure < 0) {
          sure = 0;
        }
      });
    });

    atesHakki = widget.atesHakki;

    sayacBaslat();
    atesEt();
    super.initState();
  }

  /*Future<void> initPlayer() async {
    advancedPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

    audioCache = AudioCache(fixedPlayer: advancedPlayer);
  }*/

  snakBarGoster(String uyari) {
    final snackBar = SnackBar(
        content: Text(
          uyari,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        backgroundColor: Colors.transparent,
        duration: Duration(milliseconds: 500));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  maskeGoster() {
    setState(() {
      if (maskeHakki != 0) {
        if (maske == false) {
          maske = true;
          maskeHakki--;
        }
      }
    });
  }

  Future<bool> _geriBasma() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Oyun bitmeden çıkmak istediğinize emin misiniz?'),
            content: new Text(
              'Giriş sayfasına yönlendirileceksiniz!',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Container(
                  child: Text(
                    "Hayır",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  color: Colors.amber,
                  height: 30,
                  width: 70,
                ),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: cikis,
                child: Container(
                  child: Text(
                    "Evet",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  color: Colors.amber,
                  height: 30,
                  width: 70,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  cikis() {
    oyunMuzigiStop();
    timer.cancel();
    _timer.cancel();
    atesTimer.cancel();
    Navigator.of(context, rootNavigator: true).pop(true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => OyunModuSecimi()));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _geriBasma,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_run),
                    Text(" :$adim"),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time),
                    Text(" :$sure"),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      "maske.png",
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      " :$maskeHakki",
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      "tulumkask.png",
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      " :$gorunmezlikHakki",
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Image.asset(
                        "dezenfektantemiz.png",
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Text(
                      " :$atesHakki",
                    ),
                  ],
                ),
              ],
            ),
          ),
          backgroundColor: arkaplanRenkListesi[arkaplanrenkSira],
          key: _scaffoldKey,
          bottomNavigationBar: Container(
            color: Colors.transparent,
            height: SizeConfig.blockSizeVertical * 35,
            child: BottomAppBar(
              color: Colors.transparent,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: CircularNotchedRectangle(),
              child: Container(
                  child: Center(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: GestureDetector(
                                        onTap: maskeHakki != 0
                                            ? maskeGoster
                                            : () {
                                                snakBarGoster(
                                                    "Masken yok,marketten alabilirsin");
                                              },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                              color: Colors.black,
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      9,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  15,
                                              child: Image.asset("maske.png")),
                                        ),
                                      ),
                                    ),
                                    YonButonlari(
                                      color: Colors.amber,
                                      icon: Icons.arrow_upward,
                                      function: usteRenkDegistir,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: EdgeInsets.all(1),
                                          child: GestureDetector(
                                            onTap: gorunmezlikHakki != 0
                                                ? () {
                                                    gorunmezYap();
                                                  }
                                                : () {
                                                    snakBarGoster(
                                                        "tulumun yok,marketten alabilirsin");
                                                  },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                  color: Colors.black,
                                                  height: SizeConfig
                                                          .blockSizeVertical *
                                                      9,
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      15,
                                                  child: Image.asset(
                                                      "assets/tulumkask.png")),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    YonButonlari(
                                      color: Colors.amber,
                                      icon: Icons.arrow_back,
                                      function: solaRenkDegistir,
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(1),
                                          child: GestureDetector(
                                            onTap: atesHakki != 0
                                                ? tasSil
                                                : () {
                                                    snakBarGoster(
                                                        "ateş hakkın yok,marketten alabilirsin");
                                                  },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                  color: Colors.white,
                                                  height: SizeConfig
                                                          .blockSizeVertical *
                                                      9,
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      20,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Image.asset(
                                                        "dezenfektantemiz.png"),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    YonButonlari(
                                      color: Colors.amber,
                                      icon: Icons.arrow_forward,
                                      function: sagaRenkDegistir,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: GestureDetector(
                                        onTap: blokRenkDegistir,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                              color: Colors.black,
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      9,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  15,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                    "butonrengi.png"),
                                              )),
                                        ),
                                      ),
                                    ),
                                    YonButonlari(
                                      color: Colors.amber,
                                      icon: Icons.arrow_downward,
                                      function: altaRenkDegistir,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: GestureDetector(
                                        onTap: arkaPlanRenkDegistir,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                              color: Colors.black,
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      9,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  15,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                    "butonrengi.png"),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //height: 200,
                  color: Colors.transparent),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4, 70,
                SizeConfig.blockSizeHorizontal * 4, 0),
            child: Container(
              child: GridView.count(

                crossAxisCount: widget.sutunSayisi,
                padding: EdgeInsets.only(top: 2, left: 15, right: 15),
                mainAxisSpacing: 0,
                shrinkWrap: false,
                children: List.generate(widget.blokSayisi, (index) {
                  if (pozisyon == index) {
                    return GridTile(
                        child: Card(
                      child: Center(
                        child: GestureDetector(
                          child: maske == true
                              ? gorunurMu == true
                                  ? orumcekAdamMi
                                      ? Image.asset(
                                          "assets/karakterler/orumcekadammaskeli.png")
                                      : supermanMi
                                          ? Image.asset(
                                              "assets/karakterler/supermanmaskeli.png")
                                          : batmanMi
                                              ? Image.asset(
                                                  "assets/karakterler/orumcekadammaskeli.png")
                                              : Image.asset(
                                                  "androidiconmaskeli.PNG")
                                  : Image.asset("tulumkask.png")
                              : gorunurMu == true
                                  ? hangiKarakter()
                                  : Image.asset("tulumkask.png"),
                          onTap: gorunmezYap,
                        ),
                      ),
                      color: blokRenkListesi[blokrenkSira],
                    ));
                  } else if (widget.dusmanlar.contains(index)) {
                    return GridTile(
                        child: Card(
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: arkaplanRenkListesi[arkaplanrenkSira]
                                    .withOpacity(.4),
                                spreadRadius: 30,
                                blurRadius: 30,
                                offset:
                                    Offset(15, 0), // changes position of shadow
                              ),
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.transparent, Colors.white])),
                        child: GestureDetector(
                          child: widget.tiklananindeks < 9
                              ? Image.asset(
                                  "assets/virusler/koronaresimtemizson.png")
                              : widget.tiklananindeks < 19
                                  ? Image.asset(
                                      "assets/virusler/virustemiz.png")
                                  : widget.tiklananindeks < 29
                                      ? Image.asset("assets/virusler/111.png")
                                      : widget.tiklananindeks < 39
                                          ? Image.asset(
                                              "assets/virusler/2temiz.png")
                                          : Image.asset(
                                              "assets/virusler/3temiz.png"),
                          onTap: null,
                        ),
                      )),
                      color: blokRenkListesi[blokrenkSira],
                    ));
                  } else if (index == widget.dostunYeri) {
                    return GridTile(
                        child: Card(
                      child: GestureDetector(
                        child: Icon(
                          Icons.home,
                          size: SizeConfig.safeBlockHorizontal *
                              60 /
                              widget.sutunSayisi.toDouble(),
                          color: Colors.black,
                        ),
                        onTap: null,
                      ),
                      color: Colors.blue,
                    ));
                  } else if (widget.taslar.contains(index)) {
                    return GridTile(
                        child: Card(
                      child: Center(
                          child: GestureDetector(
                        child: Image.asset("virusluyer.png"),
                        onTap: null,
                      )),
                      //color: Colors.black45,
                    ));
                  } else if (index == ates) {
                    return GridTile(
                        child: Card(
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.transparent, Colors.white])),
                        child: GestureDetector(
                          child: Image.asset(
                            "dezenfektantemiz.png",
                            height: SizeConfig.safeBlockHorizontal *
                                80 /
                                widget.sutunSayisi.toDouble(),
                            width: SizeConfig.safeBlockVertical *
                                80 /
                                widget.sutunSayisi.toDouble(),
                          ),
                          onTap: null,
                        ),
                      )),
                      color: blokRenkListesi[blokrenkSira],
                    ));
                  } else if (index == dezenfektanYeri) {
                    return GridTile(
                        child: Card(
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.transparent, Colors.white])),
                        child: GestureDetector(
                          child: Image.asset("dezenfektantemiz.png"),
                          onTap: null,
                        ),
                      )),
                      color: blokRenkListesi[blokrenkSira],
                    ));
                  } else {
                    return GridTile(
                        child: Card(
                      elevation: 20,
                      shadowColor: Colors.black,
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [Colors.transparent, Colors.white])),
                          child: GestureDetector(onTap: null)),
                      color: blokRenkListesi[blokrenkSira],
                    ));
                  }
                }),
              ),
            ),
          )),
    );
  }
}
