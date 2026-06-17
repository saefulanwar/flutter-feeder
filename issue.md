# Task: Implementasi Fitur Ticketing Aduan Data (Frontend - Flutter)

## 1. Latar Belakang & Tujuan
Fitur ini bertujuan untuk memfasilitasi mahasiswa dalam menyampaikan aduan apabila terjadi ketidaksesuaian data pada PDDIKTI (seperti biodata, riwayat pendidikan, nilai, dll). Sistem menggunakan pendekatan *ticketing* agar aduan terdokumentasi dan memungkinkan adanya komunikasi dua arah (balasan/tanggapan).

**Penting:** Backend (API) untuk fitur ini **sudah selesai dibuat**. Tugas Anda di issue ini HANYA mengerjakan implementasi antarmuka di sisi **Frontend (Aplikasi Mobile / Flutter)**.

---

## 2. Referensi API (Backend Settings)
Berikut adalah daftar endpoint API yang sudah tersedia dan wajib Anda gunakan di aplikasi Flutter. Pastikan setiap *request* menyertakan header `Authorization: Bearer <token_mahasiswa>`. Base URL adalah `/api/mahasiswa`.

### A. GET `/tickets`
- **Fungsi**: Mengambil daftar tiket milik mahasiswa yang sedang login.
- **Response**: Array of ticket objects (diurutkan dari yang terbaru).

### B. GET `/tickets/{id}`
- **Fungsi**: Mengambil detail satu tiket beserta seluruh percakapan/balasannya.
- **Response**: Object tiket tunggal yang di dalamnya terdapat *array* `replies` (termasuk informasi pengirimnya).

### C. POST `/tickets`
- **Fungsi**: Membuat aduan/tiket baru.
- **Payload (Gunakan `multipart/form-data`)**:
  - `kategori` (String, Required): Pilihannya: `biodata`, `nilai`, `status_kuliah`, `kelulusan`, `lainnya`.
  - `judul` (String, Required): Maksimal 255 karakter.
  - `deskripsi` (String, Required): Isi aduan/keluhan secara lengkap.
  - `lampiran` (File, Optional): Gambar/PDF (maksimal 2MB).

### D. POST `/tickets/{id}/replies`
- **Fungsi**: Menambahkan balasan/pesan baru pada percakapan tiket.
- **Payload (Gunakan `multipart/form-data`)**:
  - `pesan` (String, Required): Isi teks balasan.
  - `lampiran` (File, Optional): Gambar/PDF pendukung (maksimal 2MB).

---

## 3. Alur Pengguna (User Flow) & Panduan UI/UX
Fokus utama adalah memberikan pengalaman pengguna (UX) yang sangat mudah, *user friendly*, dan intuitif. Desain dibuat senyaman mungkin bagi mahasiswa.

### Halaman 1: Daftar Tiket (Ticket List Screen)
- **Tampilan Utama**: *List view* menggunakan *Card* untuk menampilkan daftar aduan.
- **Informasi pada Card**: 
  - Judul aduan (Cetak tebal).
  - Label Kategori (Gunakan *badge* warna-warni yang berbeda untuk tiap kategori agar mudah diidentifikasi. Misal: Merah untuk 'Nilai', Biru untuk 'Biodata').
  - Status Tiket (Indikator visual. Contoh: warna Hijau untuk 'Open', Abu-abu untuk 'Closed').
  - Tanggal tiket dibuat atau diperbarui.
- **Aksi**: *Floating Action Button* (FAB) besar dengan ikon `+` di pojok kanan bawah untuk "Buat Aduan Baru".
- **UX Tambahan**: 
  - Tampilkan efek *shimmer loading* saat aplikasi sedang mengambil data.
  - Tampilkan ilustrasi *empty state* yang menarik jika mahasiswa belum pernah membuat aduan sama sekali.
  - Pasang fitur *Pull-to-Refresh* agar mahasiswa mudah memperbarui data terbaru.

### Halaman 2: Buat Aduan Baru (Create Ticket Screen)
- **Konsep**: Form *input* yang rapi dan terarah (hindari desain form yang kaku).
- **Komponen Input**:
  - **Kategori**: Gunakan *Dropdown* atau *Bottom Sheet Picker*.
  - **Judul**: *TextField* standar (satu baris).
  - **Deskripsi**: *TextField* area multi-baris (minimal 4-5 baris). Berikan *placeholder* yang membantu, contoh: "Ceritakan secara detail bagian mana dari data Anda yang tidak sesuai...".
  - **Lampiran (Opsional)**: Area khusus untuk *upload*. Beri opsi untuk memotret dari Kamera, memilih gambar dari Galeri, atau unggah dokumen PDF. 
    - *Feedback visual*: Tampilkan *thumbnail* gambar atau ikon nama file PDF jika file sudah berhasil dipilih. Sediakan tombol (X) untuk menghapus file terpilih sebelum *submit*.
- **Aksi**: Tombol "Kirim Aduan". 
  - *Feedback visual*: Ubah tombol menjadi animasi *loading* atau nonaktifkan tombol sementara saat *request API* berjalan untuk mencegah pengiriman data berulang (*multiple submit*). 
  - Tampilkan *Snackbar* "Sukses" dan arahkan kembali ke layar Daftar Tiket setelah *response* berhasil.

### Halaman 3: Detail Tiket & Percakapan (Ticket Detail & Chat Screen)
- **Konsep**: Desain antarmuka dibuat semirip mungkin dengan aplikasi perpesanan (contoh: WhatsApp/Telegram) agar intuitif.
- **Header Section**: Menampilkan ringkasan singkat: Judul Aduan, *Badge* Kategori, dan Status Tiket.
- **Body Section (Daftar Chat Bubble)**:
  - Gunakan daftar berbasis gulir (`ListView`).
  - **Pesan Mahasiswa**: Tampilkan di sisi **Kanan** (gunakan warna identitas aplikasi/kampus untuk *bubble*-nya).
  - **Pesan Admin/Kampus**: Tampilkan di sisi **Kiri** (gunakan warna netral seperti abu-abu terang).
  - **Penanganan Lampiran**: Jika ada *URL* lampiran di pesan, tampilkan gambar (*CachedNetworkImage*) yang bisa di-*tap* untuk diperbesar (*full-screen preview*), atau berikan tombol "Unduh/Buka" untuk PDF.
- **Footer Section**: 
  - Kolom *TextField* untuk mengetik balasan baru.
  - Diapit oleh tombol *attachment* (ikon klip kertas) untuk melampirkan file tambahan.
  - Tombol Kirim (ikon pesawat kertas) untuk men- *submit* balasan.

---

## 4. Instruksi Implementasi untuk Flutter Developer (Junior Level)
Silakan ikuti urutan *checklist* ini agar pekerjaan Anda lebih terstruktur dan mengurangi kemungkinan *error*:

- [ ] **Langkah 1: Persiapan Model Data (Dart)**
  - Buat model Dart (contoh: `TicketModel` dan `TicketReplyModel`) yang sesuai dengan struktur JSON dari *backend*. Anda dapat menggunakan `json_serializable`, `freezed`, atau generator *online* seperti Quicktype untuk meminimalisasi *typo*.

- [ ] **Langkah 2: Integrasi API Service (HTTP Client)**
  - Buat file layanan (contoh: `ticket_service.dart`) untuk menangani fungsi HTTP `GET` dan `POST`.
  - Baik Anda menggunakan `http` maupun `dio`, pastikan pengiriman data *form* beserta gambar/file ditangani menggunakan `FormData` / `MultipartRequest`.

- [ ] **Langkah 3: Persiapan State Management**
  - Implementasikan *state management* yang dipakai di proyek ini (contoh: Provider, BLoC/Cubit, atau GetX) untuk mengatur alur data. Pastikan *state* *Loading*, *Success*, dan *Error* tertangani dengan baik, agar UI tidak terkesan "*nge-hang*" saat menunggu API.

- [ ] **Langkah 4: Selesaikan Halaman Daftar Tiket**
  - Susun antarmuka untuk menampilkan daftar, buat *widget card* yang interaktif. Jangan lupa sisipkan logika navigasi menuju Halaman Detail Tiket ketika *card* ditekan.

- [ ] **Langkah 5: Selesaikan Halaman Form Tiket Baru**
  - Pasang *package* pendukung seperti `image_picker` dan `file_picker`.
  - Buat form validasi (Judul, Kategori, dan Deskripsi tidak boleh kosong). Pastikan berhasil mengembalikan pengguna ke halaman utama jika simpan ke *backend* berhasil.

- [ ] **Langkah 6: Selesaikan Halaman Detail Tiket & Balasan**
  - Pastikan urutan pesan benar (apakah perlu di-*reverse* sesuai indeks atau dari susunan JSON API).
  - Sambungkan logika tombol *kirim balasan* pada *Footer* dengan endpoint `storeReply`. Jika respons berhasil, segeralah memperbarui antarmuka (tambahkan *chat* baru) tanpa perlu me-*refresh* seluruh halaman.

- [ ] **Langkah 7: Pengujian Terpadu (Testing Akhir)**
  - Coba tes seluruh alur kerja pada *emulator* atau perangkat asli: 
    1. Tarik-ke-bawah (pull-to-refresh) di layar daftar tiket.
    2. Tambah aduan baru (tes dengan lampiran gambar dan tanpa lampiran).
    3. Buka tiket tersebut, cobalah balas pesan (juga tes dengan melampirkan gambar).
  - Pastikan tidak ada isu layar terpotong pada *keyboard* (gunakan `resizeToAvoidBottomInset: true` di Scaffold jika diperlukan).
