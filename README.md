# MyPortfolio Mobile

Aplikasi portofolio pribadi multiplatform yang dibuat dengan Flutter dan Dart. Halaman utama menampilkan identitas pemilik, menu Skills dan Experience, aksi tambah, serta Logout dengan konfirmasi. Komponen halaman dan kartu dipisahkan di `lib/menu.dart`; `lib/main.dart` menjadi entry point aplikasi.

## Fitur

- Kartu profil berisi NPM, nama, dan kelas.
- Lima kartu aksi dengan warna berbeda (Lihat Skills, Lihat Experience, Tambah Skill, Tambah Experience, Logout).
- SnackBar muncul saat kartu ditekan dengan pesan sesuai nama tombol.
- Bottom sheet detail untuk Skills dan Experience.
- Dialog konfirmasi sebelum Logout.

## Struktur Proyek

```text
lib/
├── main.dart   # entry point dan MaterialApp
└── menu.dart   # MyHomePage, InfoCard, ItemCard, ItemHomepage
```

## Menjalankan Proyek

Pastikan Flutter SDK sudah terpasang dan `flutter doctor` tidak menunjukkan kendala untuk platform yang akan digunakan. Versi yang dipakai: [hasil `flutter --version`].

```bash
flutter pub get
flutter run
```

Untuk memeriksa kualitas kode dari root proyek:

```bash
flutter analyze
```

## Progres Mingguan

- **Tutorial 08:** setup Flutter, pemisahan `menu.dart`, `InfoCard` dan `ItemCard`.
- **Tugas 7:** profil pribadi, 5 kartu aksi berwarna, SnackBar, bottom sheet detail, konfirmasi Logout.

## Pertanyaan Reflektif

### Tugas 7

1. **Widget tree** adalah susunan widget yang membentuk antarmuka Flutter. Setiap widget dapat memiliki widget anak dan menjadi bagian dari pohon yang berakar pada widget aplikasi. Pada proyek ini, `MyApp` membangun `MaterialApp`, yang menampilkan `MyHomePage`. Halaman tersebut membangun `Scaffold` dengan `AppBar` dan body. Body berisi `Container`, `SingleChildScrollView`, dan `Column`; di dalamnya terdapat kartu profil dan grid `ItemCard`. Hubungan induk-anak menentukan tata letak, batasan ukuran, dan bagaimana properti seperti tema atau konteks diwariskan.

2. **Widget yang digunakan dan fungsinya:**
   - `MaterialApp` mengatur kerangka aplikasi Material, tema, dan halaman awal.
   - `Scaffold` menyediakan struktur halaman seperti AppBar, body, serta tempat bagi SnackBar.
   - `AppBar` menampilkan judul halaman.
   - `Container` menggambar latar gradien.
   - `SingleChildScrollView` memungkinkan halaman digulir pada layar kecil.
   - `Column` dan `Row` menyusun konten secara vertikal dan horizontal.
   - `Card` dan `Padding` membentuk kartu profil beserta ruang di dalamnya.
   - `CircleAvatar` dan `Icon` menampilkan avatar dan ikon.
   - `Expanded` membagi ruang pada baris profil; `SizedBox` mengatur jarak dan lebar.
   - `Center` memusatkan isi kartu aksi.
   - `GridView.count` menyusun menu aksi dalam dua kolom.
   - `Text` menampilkan label dan isi informasi.
   - `Material` dan `InkWell` membentuk kartu aksi dengan efek ripple saat disentuh.
   - `ScaffoldMessenger` menampilkan dan mengelola SnackBar.
   - `SnackBar` memberi umpan balik saat tombol ditekan.
   - `showDialog`, `AlertDialog`, dan `TextButton` menyediakan konfirmasi Logout.
   - `showModalBottomSheet` menampilkan detail Skills dan Experience dari bawah layar.
   - `SafeArea` menjaga isi bottom sheet dari area sistem; `ListTile` menyusun setiap detail.
   - `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard` adalah widget buatan proyek untuk mengatur aplikasi, halaman, informasi profil, dan kartu aksi.

3. **Fungsi `MaterialApp`:** widget ini menyiapkan fitur dasar aplikasi bergaya Material, termasuk tema dan navigasi. Ia umumnya menjadi root widget karena menjadi induk bagi halaman lain dan menyediakan konfigurasi yang dibutuhkan widget turunannya. Pada proyek ini, `MyApp` mengembalikan `MaterialApp` dengan `MyHomePage` sebagai halaman awal.

4. **Perbedaan `StatelessWidget` dan `StatefulWidget`:** `StatelessWidget` cocok untuk tampilan yang bergantung pada konfigurasi dan data yang tidak berubah selama umur widget. `StatefulWidget` digunakan ketika tampilan perlu berubah sebagai respons terhadap state lokal, misalnya nilai penghitung atau status pilihan. `MyHomePage`, `InfoCard`, dan `ItemCard` menggunakan `StatelessWidget`; dialog dan bottom sheet dikelola oleh framework dan tidak memerlukan state lokal pada kartu.

5. **`BuildContext`:** objek ini mewakili lokasi sebuah widget di dalam widget tree. Melalui konteks, widget dapat menemukan konfigurasi dari leluhurnya, seperti tema, navigator, atau `ScaffoldMessenger`. Metode `build(BuildContext context)` menerima konteks tersebut agar widget dapat membangun tampilan dan mengakses layanan yang tepat. Konteks sebaiknya tidak dipakai sembarangan setelah operasi asynchronous; proyek ini memeriksa `context.mounted` setelah menunggu dialog Logout.

6. **Hot reload dan hot restart:** hot reload menerapkan perubahan kode Dart ke aplikasi yang sedang berjalan dan umumnya mempertahankan state saat ini. Hot restart memulai ulang aplikasi Flutter dari `main` dan menghapus state dalam memori. Hot reload tidak cukup untuk perubahan yang memerlukan inisialisasi ulang, misalnya mengubah konstanta global seperti `pine` atau `sage` (inisialisasi variabel global tidak dijalankan ulang), kode native, atau konfigurasi plugin platform. Perubahan tersebut memerlukan hot restart atau menghentikan lalu menjalankan ulang aplikasi (full restart).

## Pengungkapan Penggunaan AI

**Tools:** OpenAI Codex di ChatGPT digunakan sebagai pendamping selama pengerjaan. Bagian yang dibantu AI:
- Saran palet warna hex (pine, sage, gold, ivory, ink, cream, soft mint) dan pemilihan ikon.
- Saran tata letak: kartu profil dengan avatar, grid 2 kolom, rasio kartu, dan posisi Logout.
- Pengecekan kesesuaian kode terhadap checklist dan rubrik tugas.
- Peninjauan README ini.