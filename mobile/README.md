# BloodConnect - Aplikasi Mobile Flutter 🩸

BloodConnect adalah aplikasi mobile berbasis Flutter yang dirancang untuk menghubungkan para pendonor darah dengan pasien yang membutuhkan transfusi darah. Aplikasi ini menggunakan pendekatan **Clean Architecture** dan pola desain modern untuk memastikan performa yang cepat, aman, dan mudah dikembangkan.

## 🎯 Gambaran Proyek

Tujuan utama dari BloodConnect adalah mempermudah pencarian darah dalam kondisi darurat maupun sukarela. Setiap pengguna (*masyarakat*) dapat berperan ganda: sebagai **Peminta Darah** (jika ada keluarga/kerabat yang sakit) maupun sebagai **Pendonor Darah** (menawarkan diri secara sukarela).

## 📱 Fitur Utama

- **Sistem Otentikasi (Login & Register)** - Pendaftaran dan masuk akun dengan aman menggunakan *JWT Token*.
- **Eksplorasi Darah (Ruang Publik)** - Fitur *Global Feed* untuk melihat daftar orang yang sedang "Membutuhkan Darah" atau orang yang "Siap Donor".
- **Pencarian & Filter Cerdas** - Mencari berdasarkan Nama, Lokasi/Daerah, serta filter spesifik untuk **Golongan Darah** dan **Rhesus**.
- **Aktivitas Saya (Ruang Pribadi)** - Pembuatan dan manajemen postingan khusus milik Anda. Anda bisa menekan tombol "Tandai Selesai" jika darah sudah terpenuhi, sehingga postingan Anda hilang dari ruang publik.
- **Hubungi via WhatsApp** - Integrasi langsung untuk menghubungi peminta atau penawar donor melalui WhatsApp.
- **Profil Pengguna** - Kelola data diri dan lihat riwayat aktivitas donor Anda.
- **UI Modern** - Antarmuka yang bersih, intuitif, dan menggunakan Material Design 3.

## Fitur Role Admin
📊 Dashboard
Melihat total pengguna
Melihat jumlah request Pending & Completed
Melihat jumlah pendonor aktif

👥 Manajemen Pengguna
Melihat daftar pengguna
Melihat detail pengguna
Mencari dan memfilter pengguna

🩸 Manajemen Blood Request
Melihat seluruh blood request
Melihat detail blood request
Mencari dan memfilter request

📈 Laporan & Statistik
Statistik jumlah donor
Statistik berdasarkan golongan darah
Statistik berdasarkan tingkat urgensi
Grafik aktivitas harian, mingguan, dan bulanan


## 🏗️ Arsitektur

### Pola Clean Architecture
Proyek ini dipisahkan menjadi beberapa lapisan (*layers*) agar kode lebih rapi:
```
lib/
├── core/                          # Lapisan Inti (Konfigurasi, Tema, Router, Konstanta, Network)
├── shared/                        # Lapisan Berbagi (Widget yang sering dipakai ulang seperti Tombol, Form, Loading)
├── features/                      # Lapisan Fitur Utama
│   ├── auth/                      # (Otentikasi, Login, Register)
│   ├── blood_request/             # (Manajemen Permintaan Darah)
│   ├── donor_post/                # (Manajemen Tawaran Donor)
│   ├── home/                      # (Beranda)
│   ├── explore/                   # (Eksplorasi Publik)
│   └── profile/                   # (Profil Pengguna)
├── presentation/                  # Lapisan UI Utama (Scaffold, Navigasi Bawah)
└── main.dart                      # Titik awal jalannya aplikasi
```

## 🎨 Sistem Desain

- **Warna Utama**: #C62828 (Merah Gelap) & #E53935 (Merah Terang)
- **Status**: Hijau (Success), Kuning/Oranye (Warning/Searching), Merah (Critical/Error), Biru (Pending).
- **Tipografi**: Menggunakan font **Poppins** (dari Google Fonts).

## 📦 Teknologi & Library yang Digunakan

- **State Management**: `flutter_riverpod` (Manajemen state reaktif dan modern)
- **Navigasi**: `go_router` (Routing yang deklaratif dan mendukung *deep linking*)
- **Jaringan / API**: `dio` (HTTP client handal) & `pretty_dio_logger`
- **Penyimpanan**: `flutter_secure_storage` (Untuk menyimpan token keamanan lokal)
- **Code Generation**: `freezed` & `json_serializable` (Pembuatan model data *immutable*)
- **UI & Desain**: `flutter_screenutil` (Agar UI responsif di segala ukuran layar), `iconsax` (Ikon modern).

## 🚀 Cara Menjalankan Aplikasi

### Persyaratan Sistem
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Emulator Android / iOS atau perangkat asli.

### Langkah-langkah Instalasi

1. **Kloning Repositori**
```bash
git clone https://github.com/krizzell/blood_connect.git
cd blood_connect/mobile
```

2. **Unduh Dependensi**
```bash
flutter pub get
```

3. **Jalankan Code Generation** (Sangat penting karena kita menggunakan *Freezed*)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Jalankan Aplikasi**
```bash
flutter run
```

## 🔐 Keamanan (Security)
- Semua komunikasi ke *backend API* (Golang) menggunakan HTTPS.
- Pengamanan sesi menggunakan **JWT (JSON Web Tokens)** yang disisipkan melalui *Dio Interceptor*.
- Penyimpanan token JWT di enkripsi melalui `flutter_secure_storage`.

## 👥 Kontributor
- **Tim Pengembang BloodConnect**

---
*Dibuat untuk memudahkan setiap tetes darah menemukan mereka yang membutuhkan.* ❤️
