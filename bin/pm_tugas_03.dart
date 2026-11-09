import 'dart:io';

typedef MataKuliah = ({String nama, int sks, String nilai});

// Membaca satu baris input dari terminal dengan aman terhadap nilai null.
String? bacaInput(String label) {
  stdout.write(label);
  return stdin.readLineSync();
}

// Validasi SKS harus berupa bilangan bulat 1 sampai 6.
int validasiSks(String input) {
  final nilai = input.trim();
  if (nilai.isEmpty) {
    throw const FormatException('SKS harus berupa angka 1-6.');
  }

  final sks = int.tryParse(nilai);
  if (sks == null || sks < 1 || sks > 6) {
    throw FormatException('SKS harus berupa angka 1-6, bukan "$input".');
  }

  return sks;
}

// Validasi nilai huruf harus berada di rentang A sampai E.
String validasiNilai(String input) {
  final nilai = input.trim();
  if (nilai.isEmpty) {
    throw const FormatException('Nilai harus berupa huruf A-E.');
  }

  final huruf = nilai.toUpperCase();
  if (!['A', 'B', 'C', 'D', 'E'].contains(huruf)) {
    throw FormatException('Nilai harus berupa huruf A-E, bukan "$input".');
  }

  return huruf;
}

// Mengubah huruf nilai menjadi bobot yang dipakai saat menghitung IP.
int bobot(String nilai) {
  return switch (nilai.trim().toUpperCase()) {
    'A' => 4,
    'B' => 3,
    'C' => 2,
    'D' => 1,
    'E' => 0,
    _ => throw FormatException('Nilai tidak valid: "$nilai".'),
  };
}

// Menjumlahkan seluruh SKS dengan fold agar lebih ringkas.
int totalSks(List<MataKuliah> data) {
  return data.fold<int>(0, (total, item) => total + item.sks);
}

// Menghitung IP dengan mengakumulasi SKS x bobot lalu membaginya dengan total SKS.
double hitungIp(List<MataKuliah> data) {
  final jumlahSks = totalSks(data);
  if (jumlahSks == 0) {
    return 0.0;
  }

  final totalBobot = data.fold<double>(
    0,
    (result, item) => result + (item.sks * bobot(item.nilai)).toDouble(),
  );

  return totalBobot / jumlahSks;
}

// Menentukan predikat IP berdasarkan rentang nilai yang sudah ditetapkan.
String predikat(double ip) {
  return switch (ip) {
    >= 3.51 => 'Dengan Pujian',
    >= 3.00 => 'Memuaskan',
    >= 2.00 => 'Cukup',
    _ => 'Kurang',
  };
}

// Menyaring mata kuliah dengan bobot di bawah 2 untuk ditampilkan sebagai perbaikan.
List<String> daftarPerluDiperbaiki(List<MataKuliah> data) {
  return data
      .where((item) => bobot(item.nilai) < 2)
      .map((item) => item.nama)
      .toList();
}

// Mencetak tampilan KHS, dengan opsi pengurutan sesuai permintaan user.
void cetakKhs(List<MataKuliah> data, {bool urutkan = false}) {
  final daftarTampil = urutkan
      ? ([...data]..sort((a, b) {
          final urutanNilai = bobot(b.nilai).compareTo(bobot(a.nilai));
          if (urutanNilai != 0) {
            return urutanNilai;
          }
          return a.nama.compareTo(b.nama);
        }))
      : data;

  print('\nMata Kuliah                SKS  Nilai');
  print('--------------------------------------');
  for (final item in daftarTampil) {
    print(
      '${item.nama.padRight(28)} ${item.sks.toString().padLeft(3)} ${item.nilai.padLeft(5)}',
    );
  }
  print('--------------------------------------');

  final jumlahSks = totalSks(daftarTampil);
  final ip = hitungIp(daftarTampil);
  print('Total SKS : $jumlahSks');
  print('IP        : ${ip.toStringAsFixed(2)} (${predikat(ip)})');

  final perluDiperbaiki = daftarPerluDiperbaiki(daftarTampil);
  if (perluDiperbaiki.isNotEmpty) {
    print('Perlu diperbaiki: ${perluDiperbaiki.join(', ')}');
  }
}

// Program utama untuk mengumpulkan data, validasi input, dan menampilkan KHS.
void main() {
  final data = <MataKuliah>[];

  print('Masukkan data mata kuliah. Kosongkan nama untuk selesai.');

  while (true) {
    final namaInput = bacaInput('Nama MK : ');
    if (namaInput == null || namaInput.trim().isEmpty) {
      break;
    }

    try {
      final sksInput = bacaInput('SKS     : ');
      if (sksInput == null) {
        break;
      }
      final sks = validasiSks(sksInput.trim());

      final nilaiInput = bacaInput('Nilai   : ');
      if (nilaiInput == null) {
        break;
      }
      final nilai = validasiNilai(nilaiInput.trim());

      data.add((nama: namaInput.trim(), sks: sks, nilai: nilai));
    } on FormatException catch (error) {
      print('Data diabaikan: ${error.message}');
    }
  }

  if (data.isEmpty) {
    print('Tidak ada data mata kuliah.');
    return;
  }

  final jawaban = bacaInput('Urutkan dari nilai tertinggi? (y/t) ')
      ?.trim()
      .toLowerCase();
  cetakKhs(data, urutkan: jawaban == 'y');
}
