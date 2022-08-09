import 'dart:async';

import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder, "Istatistikler.db");

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    return await db.execute(
        "CREATE TABLE Istatistikler(id INTEGER PRIMARY KEY, adim TEXT, sure TEXT, dezenfektan TEXT, maske TEXT, gorunmezlik TEXT, orumcekAdam TEXT, batman TEXT, superman TEXT, harcananAltin TEXT, harcananElmas TEXT)");
  }

  Future<List<Istatistikler>> istatistikleriGetir() async {
    var dbClient = await db;
    var result = await dbClient.query("Istatistikler", orderBy: "id");
    return result.map((data) => Istatistikler.fromMap(data)).toList();
  }

  Future<int> kalinanBolum() async {
    var dbClient = await db;
    var result = await dbClient.query("Istatistikler", orderBy: "id");

    return result.map((data) => Istatistikler.fromMap(data)).last.id;
  }

  Future<int> istatistikEkle(Istatistikler istatistikler) async {
    var dbClient = await db;
    return await dbClient.insert("Istatistikler", istatistikler.toMap());
  }

  Future<void> istatistikSil(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete("Istatistikler", where: "id=?", whereArgs: [id]);
  }

  Future<void> istatistikGuncelle(Istatistikler istatistikler) async {
    var dbClient = await db;
    return await dbClient.update("Istatistikler", istatistikler.toMap(),
        where: "id=?", whereArgs: [istatistikler.id]);
  }

  Future<void> veriTabaniSil() async {
    var dbClient = await db;
    return await dbClient.delete("Istatistikler");
  }
}

class Istatistikler {
  int id;
  String adim;
  String sure;
  String dezenfektan;
  String maske;
  String gorunmezlik;
  String orumcekAdam;
  String batman;
  String superman;
  String harcananAltin;
  String harcananElmas;

  static List<Istatistikler> istatistikler = [];

  Istatistikler({
    this.id,
    this.adim,
    this.sure,
    this.dezenfektan,
    this.maske,
    this.gorunmezlik,
    this.superman,
    this.batman,
    this.orumcekAdam,
    this.harcananAltin,
    this.harcananElmas,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["adim"] = adim;
    map["sure"] = sure;
    map["dezenfektan"] = dezenfektan;
    map["maske"] = maske;
    map["gorunmezlik"] = gorunmezlik;
    map["orumcekAdam"] = orumcekAdam;
    map["batman"] = batman;
    map["superman"] = superman;
    map["harcananAltin"] = harcananAltin;
    map["harcananElmas"] = harcananElmas;

    return map;
  }

  Istatistikler.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    adim = map["adim"];
    sure = map["sure"];
    dezenfektan = map["dezenfektan"];
    maske = map["maske"];
    gorunmezlik = map["gorunmezlik"];
    orumcekAdam = map["orumcekAdam"];
    batman = map["batman"];
    superman = map["superman"];
    harcananAltin = map["harcananAltin"];
    harcananElmas = map["harcananElmas"];
  }
}
