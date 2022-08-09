import 'package:dersasistan/FarkliCozunurlukAyarSinifi.dart';
import 'package:dersasistan/VeriTabani/Database.dart';
import 'package:flutter/material.dart';

class Siralama extends StatefulWidget {
  @override
  _SiralamaPageState createState() => _SiralamaPageState();
}

class _SiralamaPageState extends State<Siralama> {
  DbHelper _dbHelper;
  List enBuyukIndeks = [];

  @override
  void initState() {
    _dbHelper = DbHelper();
    if (_dbHelper != null) {
      _dbHelper.istatistikleriGetir().then((value) => value.forEach((element) {
            enBuyukIndeks.add(element.id);
          }));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Skor Tablosu"),
      ),
      body: Container(

        child: FutureBuilder(
          future: _dbHelper.istatistikleriGetir(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Istatistikler>> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data.isEmpty)
              return Text(
                "Henüz puan oluşmadı",
                style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 6),
                textAlign: TextAlign.center,
              );
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Istatistikler istatistikler = snapshot.data[index];
                  return ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            alignment: Alignment.center,
                            height: SizeConfig.blockSizeVertical * 10,
                            width: SizeConfig.blockSizeHorizontal * 10,
                            color: Colors.white,
                            child: Text("${istatistikler.id + 1}",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 5)))),
                    title: Container(

                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [Colors.blue[900],Colors.red[900]])),
                                  alignment: Alignment.center,
                                  height: SizeConfig.blockSizeVertical * 6,
                                  width: SizeConfig.blockSizeHorizontal * 35,
                                  //color: Colors.red[100],
                                  child: Text(
                                    "Altın:${istatistikler.sure}\nHarcanan :${istatistikler.harcananAltin != null ? istatistikler.harcananAltin : 0}",
                                    // "altın:${istatistikler.sure} maske: ${istatistikler.maske} görünmezlik: ${istatistikler.gorunmezlik} dezenfektan: ${istatistikler.dezenfektan} harcananaltin :${istatistikler.harcananAltin},harcananelmas :${istatistikler.harcananElmas}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal * 3),
                                  ))),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors:[Colors.blue[900],Colors.red[900]])),
                                  alignment: Alignment.center,
                                  height: SizeConfig.blockSizeVertical * 6,
                                  width: SizeConfig.blockSizeHorizontal * 35,
                                 // color: Colors.red[100],
                                  child: Text(
                                    "Elmas:${istatistikler.adim}\nHarcanan :${istatistikler.harcananElmas != null ? istatistikler.harcananElmas : 0}",
                                    style: TextStyle(
                                      color: Colors.white,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal * 3),
                                  )))
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
