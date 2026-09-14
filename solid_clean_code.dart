class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);
}

//SOLID ISP: Bir sınıf kullanmadığı metoda bağımlı kalmamalıdır.
abstract class KargoUcretiHesaplayici {
  double kargoUcretiHesapla(String tip);
}

class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok) : super(id, ad, fiyat, stok, "Dijital");
}

//ISP
// Bu metodların sorumluluğu tek bir sınıfa ait değil bundan dolayı tek bir sınıfta hepsi çağrılmamalı bundan dolayı da küçük abstract classlarda tanımlamalıyız.
abstract class SiparisKaydedici {
  void siparisKaydet(String orderId, double tutar);
}

abstract class OdemeYapici {
  void odemeYap(String tip, double tutar);
}

abstract class KargoGonderici {
  void kargoGonder(String orderId, String adres);
}

abstract class MailGonderici {
  void mailGonder(String email, String mesaj);
}

abstract class SmsGonderici {
  void smsGonder(String tel, String mesaj);
}

abstract class FaturaYazdirici {
  void faturaYazdir(String orderId);
}

// DIP: Buradaki örnekte veritabanı işlemlerinde sadece Sqlite a bağımlı kalmak istemiyorum belki hibrit bir sistem kullancağım ve bulutta çalışacağım bundan dolayı veritabanı işlemlerini birden fazla alternatif ile geliştirebilmeliyim.

abstract class VeritabaniServisi {
  void kaydet(String sql);
}

class SqliteVeritabani implements VeritabaniServisi {
  @override
  void kaydet(String sql) {
    print("Sqlite veri tabani calistirildi: " + sql);
  }
}

class FirebaseVeritabani implements VeritabaniServisi {
  @override
  void kaydet(String sql) {
    print("Firebase veri tabanicalistirildi: " + sql);
  }
}

abstract class MailAtmaServisi {
  void mailAt(String to, String body);
}

class SmtpMailServisi implements MailAtmaServisi {
  void mailAt(String to, String body) {
    print("SMTP Mail gonderildi: " + to);
  }
}

abstract class SmsIletmeServisi {
  void smsYolla(String gsm, String text);
}

class NetgsmSmsServisi implements SmsIletmeServisi {
  void smsYolla(String gsm, String text) {
    print("SMS iletildi: " + gsm);
  }
}

//SiparisYoneticisi sınıfını daha küçük sorumluluk içeren sınıflara bölüyoruz.
class SiparisKaydet implements SiparisKaydedici {
  final VeritabaniServisi vt;
  SiparisKaydet(this.vt);
  @override
  void siparisKaydet(String orderId, double tutar) {
    vt.kaydet("INSERT INTO siparisler VALUES ('$orderId', $tutar)");
  }
}

class OdemeYap implements OdemeYapici {
  @override
  void odemeYap(String tip, double tutar) {
    if (tip == "KREDI_KARTI") {
      print("$tutar TL Kredi kartindan POS ile cekildi.");
    } else if (tip == "HAVALE") {
      print("$tutar TL Havale kontrol edildi.");
    } else if (tip == "KAPIDA_ODEME") {
      print("$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).");
    } else if (tip == "CRYPTO") {
      print("$tutar TL USDT transferi onaylandi.");
    } else {
      print("Gecersiz odeme yontemi");
    }
  }
}

class KargoGonder implements KargoGonderici {
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }
}

class MailGonder implements MailGonderici {
  final MailAtmaServisi mailServisi;
  MailGonder(this.mailServisi);

  @override
  void mailGonder(String email, String mesaj) {
    mailServisi.mailAt(email, mesaj);
  }
}

class SmsGonder implements SmsGonderici {
  final SmsIletmeServisi smsServisi;
  SmsGonder(this.smsServisi);

  @override
  void smsGonder(String tel, String mesaj) {
    smsServisi.smsYolla(tel, mesaj);
  }
}

class FaturaYazdir implements FaturaYazdirici {
  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }
}

class Siparis {
  String orderId;
  List<Urun> sepet;

  Siparis(this.orderId, this.sepet);
}

class StokHesaplamaServisi {
  bool stokDurumuKontrolu(List<Urun> sepet) {
    for (int i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tukenmis!");
        return false;
      }
    }
    return true;
  }

  void stokAzalt(List<Urun> sepet) {
    for (int i = 0; i < sepet.length; i++) {
      sepet[i].stok--;
    }
  }
}

class SabitKargoUcretiHesapla implements KargoUcretiHesaplayici {
  @override
  double kargoUcretiHesapla(String tip) {
    if (tip != "DIJITAL") return 29.90;
    return 0;
  }
}

class SiparisFiyatHesaplayici {
  final KargoUcretiHesaplayici kargoUcreti;
  SiparisFiyatHesaplayici(this.kargoUcreti);

  double hesapla(List<Urun> sepet) {
    double toplam = 0;
    for (int i = 0; i < sepet.length; i++) {
      if (sepet[i].stok > 0) {
        toplam += sepet[i].fiyat;
        toplam += kargoUcreti.kargoUcretiHesapla(sepet[i].tip);
      }
    }
    return toplam;
  }

  double indirimliHesapla(double toplam, String kuponKodu) {
    if (kuponKodu == "INDIRIM10") return toplam * 0.9;

    if (kuponKodu == "YAZ20") {
      return toplam * 0.8;
    }

    if (kuponKodu == "SEPETTE50") {
      return toplam - 50;
    }

    return toplam;
  }

  double kdvHesapla(double toplam) {
    return toplam * 0.20;
  }
}

class SiparisYoneticisi {
  final SiparisKaydedici siparisKaydedici;
  final OdemeYapici odemeYapici;
  final KargoGonderici kargoGonderici;
  final MailGonderici mailGonderici;
  final SmsGonderici smsGonderici;
  final FaturaYazdirici faturaYazdirici;
  final StokHesaplamaServisi stokServisi;
  final SiparisFiyatHesaplayici siparisHesaplayici;

  SiparisYoneticisi({
    required this.siparisKaydedici,
    required this.odemeYapici,
    required this.kargoGonderici,
    required this.mailGonderici,
    required this.smsGonderici,
    required this.faturaYazdirici,
    required this.stokServisi,
    required this.siparisHesaplayici,
  });

  void siparisTamamla({
    required Siparis siparis,
    required String odemeTipi,
    required String musteriAdi,
    required String email,
    required String tel,
    required String adres,
    required String kuponKodu,
  }) {
    final stokVarMi = stokServisi.stokDurumuKontrolu(siparis.sepet);
    if (!stokVarMi) return;
    double toplam = siparisHesaplayici.hesapla(siparis.sepet);
    toplam = siparisHesaplayici.indirimliHesapla(toplam, kuponKodu);
    final kdv = siparisHesaplayici.kdvHesapla(toplam);
    final sonTutar = toplam + kdv;
    odemeYapici.odemeYap(odemeTipi, sonTutar);
    siparisKaydedici.siparisKaydet(siparis.orderId, sonTutar);
    stokServisi.stokAzalt(siparis.sepet);
    faturaYazdirici.faturaYazdir(siparis.orderId);
    mailGonderici.mailGonder(email, "Sayın $musteriAdi, " "siparişiniz alındı. " "Tutar: $sonTutar TL");
    smsGonderici.smsGonder(tel, "Siparişiniz onaylandı: ${siparis.orderId}");
    kargoGonderici.kargoGonder(siparis.orderId, adres);
  }
}

void main() {
  var urun1 = Urun("1", "Kablosuz Mouse", 450.0, 5, "FIZIKSEL");
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var sepet = <Urun>[urun1, urun2];

  var siparis = Siparis("SP-9921", sepet);

  var veritabani = SqliteVeritabani();
  var mailServisi = SmtpMailServisi();
  var smsServisi = NetgsmSmsServisi();

  var siparisKaydet = SiparisKaydet(veritabani);
  var odemeYap = OdemeYap();
  var kargoGonder = KargoGonder();
  var mailGonder = MailGonder(mailServisi);
  var smsGonder = SmsGonder(smsServisi);
  var faturaYazdir = FaturaYazdir();
  var stokServisi = StokHesaplamaServisi();

  var kargoUcretiHesaplayici = SabitKargoUcretiHesapla();
  var siparisFiyatHesaplayici = SiparisFiyatHesaplayici(kargoUcretiHesaplayici);

  var siparisci = SiparisYoneticisi(
    siparisKaydedici: siparisKaydet,
    odemeYapici: odemeYap,
    kargoGonderici: kargoGonder,
    mailGonderici: mailGonder,
    smsGonderici: smsGonder,
    faturaYazdirici: faturaYazdir,
    stokServisi: stokServisi,
    siparisHesaplayici: siparisFiyatHesaplayici,
  );

  siparisci.siparisTamamla(
    siparis: siparis,
    odemeTipi: "KREDI_KARTI",
    musteriAdi: "Selahaddin",
    email: "selahaddin@kodvance.com",
    tel: "05551112233",
    adres: "Kadikoy / Istanbul",
    kuponKodu: "INDIRIM10",
  );
}
