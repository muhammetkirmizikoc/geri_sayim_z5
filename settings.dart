import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // TemaYonetici için

class AyarlarSayfasi extends StatefulWidget {
  @override
  _AyarlarSayfasiState createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  // Tüm verileri temizleme onayı
  void _temizleOnay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tüm Verileri Temizle'),
          content: Text('Bu işlem tüm sayaçları ve ayarları sıfırlayacak. Emin misiniz?'),
          actions: [
            TextButton(
              child: Text('İptal', style: TextStyle(color: Color.fromARGB(255, 33, 96, 243))),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Temizle', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Tüm verileri temizle
                Navigator.pop(context);
                Navigator.pop(context, 'temizle'); // main.dart'a sinyal gönder
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tüm veriler temizlendi')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final temaYonetici = Provider.of<TemaYonetici>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
        backgroundColor: Color.fromARGB(255, 33, 96, 243),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tema Ayarları
              Text(
                'Tema Ayarları',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text('Koyu Tema'),
                trailing: Switch(
                  value: temaYonetici.isDarkMode,
                  onChanged: (value) {
                    temaYonetici.setTheme(value);
                  },
                  activeColor: Color.fromARGB(255, 33, 96, 243),
                ),
              ),
              Divider(),

              // Veri Yönetimi
              Text(
                'Veri Yönetimi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text('Tüm Verileri Temizle', style: TextStyle(color: Colors.red)),
                onTap: () => _temizleOnay(context),
              ),
              Divider(),

              // Hakkında
              Text(
                'Hakkında',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text('Uygulama Sürümü'),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                title: Text('Geri Bildirim Gönder'),
                onTap: () {
                  // Geri bildirim ekranına yönlendirme veya e-posta uygulaması açma
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Geri bildirim özelliği henüz uygulanmadı')),
                  );
                },
              ),
              ListTile(
                title: Text('Geliştirici Bilgisi'),
                subtitle: Text('Muhammet tarafından geliştirildi'),
                onTap: () {
                  // Geliştirici bilgisi detay ekranı
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Geliştirici Bilgisi'),
                      content: Text('Bu uygulama Muhammet tarafından geliştirilmiştir.\nİletişim: muhammet@example.com'),
                      actions: [
                        TextButton(
                          child: Text('Tamam', style: TextStyle(color: Color.fromARGB(255, 33, 96, 243))),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}