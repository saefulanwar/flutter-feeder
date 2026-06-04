# Setup Project Flutter & Inisialisasi Dependensi

## Deskripsi Tugas
Buat project Flutter baru di dalam direktori ini dan persiapkan arsitektur dasar aplikasi menggunakan package-package yang telah ditentukan. Tugas ini mencakup inisialisasi awal project, instalasi dependensi, dan penyusunan struktur folder yang scalable.

## Instruksi High-Level
1. **Inisialisasi Project**: Buat project Flutter baru langsung di root direktori ini.
2. **Setup Dependensi**: Tambahkan library berikut ke dalam `pubspec.yaml` dan pastikan berhasil di-resolve (`flutter pub get`):
   - **Networking & Data**: `dio`, `either_dart`
   - **State Management**: `flutter_bloc`
   - **Local Storage**: `flutter_secure_storage`
   - **Routing**: `go_router`
   - **UI & Media**: `flutter_widget_from_html`, `webview_flutter`, `flutter_rating_bar`, `image_picker`
   - **Code Generation**: `freezed` (pastikan menambahkan juga `freezed_annotation` dan `build_runner` di dev_dependencies).
3. **Struktur Arsitektur**: Tentukan dan buat struktur folder (misalnya berbasis fitur atau layer arsitektur standar seperti presentation, domain, dan data) sebagai fondasi project.
4. **Konfigurasi Awal (Boilerplate)**:
   - Buat setup dasar routing menggunakan `go_router` yang mengarah ke halaman awal sederhana.
   - Buat file konfigurasi dasar untuk klien API (menggunakan `dio`).

## Kriteria Selesai
- Project Flutter berhasil digenerate dan dapat dijalankan tanpa error.
- Semua package yang diinstruksikan terdaftar dengan versi yang kompatibel di `pubspec.yaml`.
- Kerangka folder arsitektur dan konfigurasi dasar (router & networking) sudah tersedia.
