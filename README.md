# solid-clean-code-example

## Ürün Sınıfı Sorumluluğunu Belirle : SRP

Ürün Sınıfının sorumluluğu sadece ilgili nesneye ait temel özellikleri tanımlamak olarak belirlendi.

## DijitalUrun Sınıfının Kullanmadığı Metod Durumu : ISP

DijitalUrun sınıfının sorumluluğunda olmayan yani kullanmadığı bir metoda bağlı kalmasının önüne geçildi.

## ISiparisIslemleri sınıfının içinde birden fazla Metod Olması: ISP

ISiparisIslemleri metodunun içinde farklı sınıfların sorumluluğunda olan birçok metod bulunuyordu. Bu metodların sorumluluğunda olmayan sınıflar tarafında zorla çağrılmasını engellemek amacıyla daha küçük abstract classlara ayrıldı.

## Veritabanı İşlemlerinde Birden Fazla Alternatifin Kullanılması Durumu : DIP

Spagetti Code'da veri tabanı işlemlerinde yalnızca Sqlite'a bir bağımlılık söz konusu idi. Ancak sisteme sonradan eklenecek olan alternatif veri tabanları için örneğin Firebase,Supabase vb. kodda değişiklik yapılması gerekiyordu. Bu durumu engellemek için VeritabanıServisi abstract classı oluşturuldu. Bu sayede istenen veri tabanı sistemde esnek bir şekilde dahil edildi.

## Mail, Sms İşlemlerinde de Bağımlılığın ortadan kaldırılması

## Stok durumu,Stok Azaltma, Sipariş Fiyatı gibi sorumlulukların Siparis Yöneticisi sınıfından ayrılması : SRP

Siparis yöneticisi sınıfında birbirinden farklı durumların sorumluluğunu yerine getiren metodların yer almasından ve bu durum kodu fazla şişirdiğinden dolayı ayrı hizmetlere ayrıldı.