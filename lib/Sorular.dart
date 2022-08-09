

class SoruFormati {
  String soru;
  String aYaniti;
  String bYaniti;
  String cYaniti;
  String cevap;

  SoruFormati({String q, String a, String b, String c, String cvp}) {
    soru = q;
    aYaniti = a;
    bYaniti = b;
    cYaniti = c;
    cevap = cvp;
  }
}

class SorularSinifi {
  List<SoruFormati> sorular = [
    SoruFormati(
        q: 'Sosyal mesafe en az ne kadar olmalı',
        a: '30 cm',
        b: '50 cm',
        c: '150 cm',
        cvp: '150 cm'),
    SoruFormati(
        q: 'Hangisi virüsten korunmak için yapılmalıdır',
        a: 'Temiz olmak',
        b: 'Kalabalığa karışmak',
        c: 'Maske takmamak',
        cvp: 'Temiz olmak'),
    SoruFormati(
        q: 'Kalabalık bir yere girmek gerekirse hangisi öncelikle yapılmalıdır?',
        a: 'İnsanlara kolonya sıkmak',
        b: 'Maskemizi takmak',
        c: 'Tanıdıklarla tokalaşmak',
        cvp: 'Maskemizi takmak'),
    SoruFormati(
        q: 'Hangisi doğrudur?',
        a: 'Maskeler tekrar tekrar kullanılabilir',
        b: 'Dışarıdan eve gelince el yıkamaya gerek yoktur ',
        c: 'Hapşırırken bir mendile veya kolumuzun iç kısmına hapşırmalyız',
        cvp: 'Hapşırırken bir mendile veya kolumuzun iç kısmına hapşırmalyız'),
    SoruFormati(
        q: 'Hangisi yanlıştır?',
        a: 'Maske kullanımı virüsten korunmak için çok önemlidir.',
        b: 'Sosyal mesafe virüslerden korunmak için çok önemlidir.',
        c: 'Kapalı mekanlarda havalandırmaya gerek yoktur.',
        cvp: 'Kapalı mekanlarda havalandırmaya gerek yoktur.'),
    SoruFormati(
        q: 'El temizliği için hangisi yapılmamalıdır?',
        a: 'Ellerimizi temizlemek için üzerimize silmeliyiz',
        b: 'Eller sabunlu su ile yıkanmalı',
        c: 'Eller kolonya ile dezenfekte edilebilir',
        cvp: 'Ellerimizi temizlemek için üzerimize silmeliyiz'),
    SoruFormati(
        q: 'Maske kullanımı ile ilgili hangisi doğrudur?',
        a: 'Virüslerden korunmak için maske tek başına yeterlidir',
        b: 'Bir maskenin defalarca kullanılması doğru değildir',
        c: 'Maskemiz yere düşse de tekrar takabiliriz',
        cvp: 'Bir maskenin defalarca kullanılması doğru değildir'),
    SoruFormati(
        q: 'Hangisi vürslerden korunmak için alınacak önlemlerden değildir?',
        a: 'Ellerimiz temiz değilken ellerimizle ağzımıza ve burnumuza dokunmamak',
        b: 'Bol sıvı tüketmek ve dengeli beslenmek',
        c: 'Sürekli evde kalmak',
        cvp: 'Sürekli evde kalmak'),

  ];
}


