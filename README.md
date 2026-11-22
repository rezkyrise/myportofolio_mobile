# MyPortfolio Mobile

Aplikasi portofolio pribadi multiplatform yang dibuat dengan Flutter dan Dart. Halaman utama menampilkan identitas pemilik, menu Skills dan Experience, aksi tambah, serta Logout dengan konfirmasi. Halaman berada di `lib/screens/`, sedangkan drawer dan kartu aksi berada di `lib/widgets/`; `lib/main.dart` menjadi entry point aplikasi.

## Fitur

- Kartu profil berisi NPM, nama, dan kelas.
- Lima kartu aksi untuk melihat Skill dan Experience, menambah data, serta membuka konfirmasi Logout.
- SnackBar dan bottom sheet untuk melihat Skill dan Experience yang tersimpan.
- Form Tambah Skill dengan validasi nama, kategori, tingkat kemahiran, dan dialog ringkasan.
- Form Tambah Experience dengan validasi kolom, kategori, tanggal, URL thumbnail, serta dialog ringkasan.
- Pratinjau gambar dari URL thumbnail yang valid.
- Data Skill dan Experience yang baru ditambahkan muncul di daftar selama sesi aplikasi.
- Drawer bersama untuk berpindah antara Home, Tambah Skill, dan Tambah Experience.
- Tata letak formulir yang dapat digulir pada layar sempit atau saat keyboard terbuka.

## Struktur Proyek

```text
myportofolio_mobile/
├── android/                  # berkas platform Android
├── ios/                      # berkas platform iOS
├── linux/                    # berkas platform Linux
├── macos/                    # berkas platform macOS
├── web/                      # berkas platform Web
├── windows/                  # berkas platform Windows
├── lib/
│   ├── main.dart                    # entry point, MyApp, dan tema aplikasi
│   ├── data/
│   │   ├── experience_store.dart    # penyimpanan Experience selama sesi
│   │   └── skill_store.dart        # penyimpanan Skill selama sesi
│   ├── models/
│   │   ├── experience.dart          # model dan kategori Experience
│   │   └── skill.dart               # model, kategori, dan tingkat Skill
│   ├── screens/
│   │   ├── menu.dart                # halaman utama dan daftar portofolio
│   │   ├── skill_form.dart          # formulir tambah Skill
│   │   └── experience_form.dart     # formulir tambah Experience
│   ├── theme/
│   │   └── portfolio_colors.dart   # palet warna dan latar bersama
│   └── widgets/
│       ├── left_drawer.dart        # drawer navigasi bersama
│       └── action_card.dart        # model item dan kartu aksi
├── test/
│   └── widget_test.dart            # tes navigasi, validasi, dan penyimpanan
├── .gitignore                      # berkas/folder yang diabaikan Git
├── .metadata                       # metadata proyek Flutter
├── analysis_options.yaml           # aturan analisis Dart
├── pubspec.yaml                    # metadata, dependensi, dan aset
├── pubspec.lock                    # versi dependensi yang terkunci
└── README.md                       # dokumentasi dan refleksi tugas
```

Folder `.git/` menyimpan metadata repositori. Folder `build/` dan `.dart_tool/` dibuat otomatis saat proyek dibangun atau dianalisis; semuanya tidak dicantumkan sebagai sumber utama aplikasi.

## Menjalankan Proyek

Pastikan Flutter SDK sudah terpasang dan `flutter doctor` tidak menunjukkan kendala untuk platform yang akan digunakan.

```bash
flutter pub get
flutter run
```

Untuk memeriksa kualitas kode dari root proyek:

```bash
flutter analyze
```

Analisis terakhir pada proyek ini menghasilkan `No issues found`.

## Progres Mingguan

- **Tutorial 08:** setup Flutter, `InfoCard` dan `ItemCard`.
- **Tugas 7:** profil pribadi, 5 kartu aksi berwarna, SnackBar, bottom sheet detail, konfirmasi Logout.
- **Tutorial 09:** drawer, navigasi dan form tambah skill; halaman dan widget dirapikan ke folder terpisah.
- **Tugas 8:** membuat formulir Experience dengan validasi judul, organisasi, deskripsi, kategori, tanggal, dan URL thumbnail; menampilkan ringkasan isian setelah valid; menambahkan pratinjau thumbnail; menghubungkan formulir ke kartu Home dan drawer; menyimpan Skill dan Experience selama sesi aplikasi agar tampil di daftar masing-masing; serta menguji alur formulir dan layout layar sempit.

## Pertanyaan Reflektif

### Tugas 7

1. **Widget tree** adalah susunan widget yang membentuk antarmuka Flutter. Sebuah widget dapat memiliki nol atau lebih widget anak dan menjadi bagian dari pohon yang berakar pada widget aplikasi. Pada proyek ini, `MyApp` membangun `MaterialApp`, yang menampilkan `MyHomePage`. Halaman tersebut membangun `Scaffold` dengan `AppBar` dan body. Body berisi `Container`, `SingleChildScrollView`, dan `Column`; di dalamnya terdapat kartu profil dan grid `ItemCard`. Hubungan induk-anak menentukan tata letak, batasan ukuran, dan bagaimana properti seperti tema atau konteks diwariskan.

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
   - `SnackBar` memberi umpan balik saat tombol ditekan; `SnackBarAction` menawarkan aksi untuk membuka detail.
   - `AlertDialog` dan `TextButton` membentuk tampilan konfirmasi Logout.
   - `SafeArea` menjaga isi bottom sheet dari area sistem; `ListTile` menyusun setiap detail.
   - `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard` adalah widget buatan proyek untuk mengatur aplikasi, halaman, informasi profil, dan kartu aksi.

3. **Fungsi `MaterialApp`:** widget ini menyiapkan fitur dasar aplikasi bergaya Material, termasuk tema dan navigasi. Ia umumnya menjadi root widget karena menjadi induk bagi halaman lain dan menyediakan konfigurasi yang dibutuhkan widget turunannya. Pada proyek ini, `MyApp` mengembalikan `MaterialApp` dengan `MyHomePage` sebagai halaman awal.

4. **Perbedaan `StatelessWidget` dan `StatefulWidget`:** `StatelessWidget` cocok untuk tampilan yang bergantung pada konfigurasi dan data yang tidak berubah selama umur widget. `StatefulWidget` digunakan ketika tampilan perlu berubah sebagai respons terhadap state lokal, misalnya nilai penghitung atau status pilihan. `MyHomePage`, `InfoCard`, dan `ItemCard` menggunakan `StatelessWidget`; dialog dan bottom sheet dikelola oleh framework dan tidak memerlukan state lokal pada kartu.

5. **`BuildContext`:** objek ini mewakili lokasi sebuah widget di dalam widget tree. Melalui konteks, widget dapat menemukan konfigurasi dari leluhurnya, seperti tema, navigator, atau `ScaffoldMessenger`. Metode `build(BuildContext context)` menerima konteks tersebut agar widget dapat membangun tampilan dan mengakses layanan yang tepat. Konteks sebaiknya tidak dipakai sembarangan setelah operasi asynchronous; proyek ini memeriksa `context.mounted` setelah menunggu dialog Logout.

6. **Hot reload dan hot restart:** hot reload menerapkan perubahan kode Dart ke aplikasi yang sedang berjalan, membangun ulang widget tree, dan umumnya mempertahankan state. Hot restart menjalankan ulang aplikasi dari `main` dan menghapus state dalam memori. Perubahan nilai `const` seperti warna `pine` atau `sage` dapat diterapkan melalui hot reload. Perubahan initializer variabel global atau field statis yang menyimpan state memerlukan hot restart; perubahan kode native memerlukan full restart. Lihat [panduan resmi Flutter tentang hot reload](https://docs.flutter.dev/tools/hot-reload).

### Pengungkapan Penggunaan AI — Tugas 7

**Tools:** OpenAI Codex di ChatGPT digunakan sebagai pendamping selama pengerjaan. Bagian yang dibantu AI:
- Saran palet warna hex (pine, sage, gold, ivory, ink, cream, soft mint) dan pemilihan ikon.
- Saran tata letak: kartu profil dengan avatar, grid 2 kolom, rasio kartu, dan posisi Logout.
- Pengecekan kesesuaian kode terhadap checklist dan rubrik tugas.
- Peninjauan README ini.

### Tugas 8

**1.**

| Metode | Perbedaan |
|---|---|
| `Navigator.push()` | Menambahkan halaman baru di atas halaman aktif. |
| `Navigator.pushReplacement()` | Mengganti halaman aktif dengan halaman baru. |
| `Navigator.pop()` | Menutup halaman teratas dan kembali ke halaman sebelumnya. |

Kartu **Tambah Experience** memakai `Navigator.push()`. Opsi **Home** pada drawer menutup drawer dan kembali ke halaman utama melalui `Navigator.pop()` sesuai susunan halaman yang dibuka. Dari formulir Experience, `Navigator.popUntil()` digunakan untuk kembali ke route pertama, yaitu Home.

**2.**

`Scaffold` menyediakan kerangka halaman yang menampung `AppBar`, `Drawer`, dan body. Pemakaian susunan yang sama di Home dan formulir membuat navigasi serta bagian atas halaman mudah dikenali. Contohnya, warna pine digunakan pada `AppBar` Home dan halaman Tambah Experience.

**3.**

`ListView` dipilih agar seluruh formulir dapat digulir saat layar sempit atau keyboard terbuka. `Padding` memberi ruang dari tepi layar, sedangkan `SizedBox` mengatur jarak antarkolom. Dengan begitu, tombol Simpan tetap dapat dicapai dengan menggulir.

**4.**

`GlobalKey<FormState>` memberi akses ke state Form. Setiap `validator` memeriksa nilai field dan mengembalikan pesan kesalahan atau `null`. Tombol Simpan memanggil `validate()` untuk menjalankan semua validator sebelum data diproses. Contohnya, organisasi yang hanya berisi spasi ditolak setelah `trim()`. `TextInputType.url` hanya membantu menampilkan papan ketik URL. Pengguna tetap dapat menempelkan teks yang tidak valid, sehingga URL harus diperiksa oleh validator.

### Pengungkapan Penggunaan AI — Tugas 8

**Tools:** OpenAI Codex di ChatGPT digunakan sebagai pendamping selama pengerjaan. Bagian yang dibantu AI:
- Memnyarankan validator seperti kolom wajib, batas karakter, URL thumbnail, tanggal mulai, dan tanggal selesai.
- Menjelaskan dan membantu membuat showDatePicker() dan FormField<DateTime> bekerja, termasuk pilihan tanggal selesai yang tidak boleh lebih awal dari tanggal mulai.
- Menambahkan pratinjau gambar dari URL thumbnail yang valid serta pesan jika gambar gagal dimuat.
- Membantu menghubungkan data Skill dan Experience yang disimpan selama sesi ke daftar Lihat Skills dan Lihat Experience.
- Pengecekan kesesuaian kode terhadap checklist dan rubrik tugas.
