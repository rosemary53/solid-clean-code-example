# solid-clean-code-example

## Ürün Sınıfı Sorumluluğunu Belirle : SRP

Ürün Sınıfının sorumluluğu sadece ilgili nesneye ait temel özellikleri tanımlamak olarak belirlendi.

## DijitalUrun Sınıfının Kullanmadığı Metod Durumu : ISP

DijitalUrun sınıfının sorumluluğunda olmayan yani kullanmadığı bir metoda bağlı kalmasının önüne geçildi.

## ISiparisIslemleri sınıfının içinde birden fazla Metod Olması: ISP

ISiparisIslemleri metodunun içinde farklı sınıfların sorumluluğunda olan birçok metod bulunuyordu. Bu metodların sorumluluğunda olmayan sınıflar tarafında zorla çağrılmasını engellemek amacıyla daha küçük abstract classlara ayrıldı.