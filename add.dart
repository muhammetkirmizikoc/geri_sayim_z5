import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart'; // Sayac sınıfı için

class SayacEklemeSayfasi extends StatefulWidget {
  @override
  _SayacEklemeSayfasiState createState() => _SayacEklemeSayfasiState();
}

class _SayacEklemeSayfasiState extends State<SayacEklemeSayfasi> {
  final _sayacAdiController = TextEditingController();
  final _notController = TextEditingController();
  DateTime? _selectedDateTime;
  String? _selectedKategori;
  Color? _selectedFlatColor;
  List<Color>? _selectedGradient;

  final _kategoriler = [
    {'ad': 'Hesap Kesim', 'ikon': Icons.account_balance},
    {'ad': 'Son Ödeme', 'ikon': Icons.payment},
    {'ad': 'Toplantı', 'ikon': Icons.business_center},
    {'ad': 'Etkinlik', 'ikon': Icons.event},
    {'ad': 'Görev', 'ikon': Icons.task},
    {'ad': 'Hatırlatma', 'ikon': Icons.notifications},
    {'ad': 'Randevu', 'ikon': Icons.schedule},
    {'ad': 'Diğer', 'ikon': Icons.more_horiz},
  ];

  final _duzRenkler = [
    Color.fromARGB(255, 33, 96, 243),
    Color(0xFF9ACD32),
    Color(0xFFFF8C00),
    Color(0xFF20B2AA),
    Color(0xFFE91E63),
    Color(0xFF4CAF50),
  ];

  final _gradyanlar = [
    [Colors.blue, Colors.black],
    [Colors.purple, Colors.pink],
    [Colors.teal, Colors.greenAccent],
    [Colors.red, Colors.orange],
    [Colors.indigo, Colors.cyan],
    [Colors.amber, Colors.deepOrange],
  ];

  @override
  void dispose() {
    _sayacAdiController.dispose();
    _notController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 33, 96, 243)),
        ),
        child: child!,
      ),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? now),
        builder: (context, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 33, 96, 243)),
          ),
          child: child!,
        ),
      );
      if (pickedTime != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (newDateTime.isBefore(now)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Geçmiş bir tarih seçilemez')),
          );
          return;
        }
        setState(() {
          _selectedDateTime = newDateTime;
        });
      }
    }
  }

  void _sayacEkle() {
    if (_sayacAdiController.text.isEmpty ||
        _selectedDateTime == null ||
        _selectedKategori == null ||
        (_selectedFlatColor == null && _selectedGradient == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm zorunlu alanları doldurun')),
      );
      return;
    }

    IconData? categoryIcon;
    for (var kategori in _kategoriler) {
      if (kategori['ad'] == _selectedKategori) {
        categoryIcon = kategori['ikon'] as IconData;
        break;
      }
    }

    final yeniSayac = Sayac(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isim: _sayacAdiController.text,
      tarihSaat: _selectedDateTime!,
      kategori: _selectedKategori!,
      flatColor: _selectedFlatColor,
      gradientColors: _selectedGradient,
      not: _notController.text,
      categoryIcon: categoryIcon,
    );

    Navigator.pop(context, yeniSayac);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Sayaç Ekle'),
        backgroundColor: Color.fromARGB(255, 33, 96, 243),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _sayacAdiController,
              decoration: InputDecoration(
                labelText: 'Sayaç Adı',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.label, size: 28),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: _selectDateTime,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Tarih ve Saat',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.calendar_today, size: 28),
                    suffixIcon: Icon(Icons.arrow_drop_down, size: 28),
                  ),
                  controller: TextEditingController(
                    text: _selectedDateTime != null ? dateFormat.format(_selectedDateTime!) : '',
                  ),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedKategori,
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.category, size: 28),
              ),
              items: _kategoriler.map((k) {
                return DropdownMenuItem<String>(
                  value: k['ad'] as String,
                  child: Row(
                    children: [
                      Icon(k['ikon'] as IconData, color: Color.fromARGB(255, 33, 96, 243), size: 28),
                      SizedBox(width: 12),
                      Text(k['ad'] as String, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedKategori = value),
            ),
            SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Düz Renkler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _duzRenkler.map((renk) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFlatColor = renk;
                          _selectedGradient = null;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: renk,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24),
                Text('Gradyan Renkler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _gradyanlar.map((renkler) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGradient = renkler;
                          _selectedFlatColor = null;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: renkler),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 24),
            TextField(
              controller: _notController,
              decoration: InputDecoration(
                labelText: 'Not (İsteğe Bağlı)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.note, size: 28),
              ),
              maxLines: 2,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _sayacEkle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 33, 96, 243),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 1,
              ),
              child: Text(
                'Sayaç Ekle',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}