# Tugas Rutin 3: Kalkulator IP Semester

## Identitas
- Nama: <ISI NAMA>
- NIM: <ISI NIM>
- Kelas: <ISI KELAS>
- Mata Kuliah: <ISI MATA KULIAH>

## Cara menjalankan
1. Pastikan Dart SDK sudah terpasang.
2. Buka terminal di folder proyek.
3. Jalankan perintah berikut:
   ```bash
   dart run
   ```

## Tempat tangkapan layar
- screenshot.png

## Penjelasan
Program ini memanfaatkan higher-order function seperti `fold` pada `totalSks()` dan `hitungIp()` untuk menghitung akumulasi SKS dan bobot nilai, serta `where` pada `daftarPerluDiperbaiki()` untuk menyeleksi mata kuliah yang perlu diperbaiki. Fungsi `cetakKhs()` juga memakai `sort` dengan fungsi pembanding untuk mengurutkan data dari nilai tertinggi tanpa mengubah list asli. Di sisi error handling, `validasiSks()` dan `validasiNilai()` melempar `FormatException`, lalu ditangkap di `main()` dengan `try/on FormatException catch` agar data yang tidak valid diabaikan dan program tetap berjalan tanpa crash.

## Pernyataan penggunaan AI
<ISI PERNYATAAN>
