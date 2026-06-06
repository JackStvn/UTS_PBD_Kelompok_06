# 📊 Sistem Rekap Nilai Praktikum Mahasiswa
> **Projek Praktik / Coding Test - Ujian Tengah Semester (UTS) Pemrograman Basis Data**
> **Program Studi S1 Informatika - Universitas Mega Buana Palopo (2026)**

---

## 👥 Anggota Kelompok 6 (Informatika A)
1. **Dimas Aprilino** - `IK2411044`
2. **Jack Stiven** - `IK2411062`
3. **Fauzan Azima** - `IK2411039`
4. **Gefran** - `IK2411029`
5. **Zadly Baan** - `IK2411030`

---

## 📝 Deskripsi Projek
Projek ini merupakan implementasi database sistem pengelolaan dan rekapitulasi nilai praktikum mahasiswa berbasis **MySQL (MariaDB)** melakui phpMyAdmin. Sistem ini dirancang untuk mengotomatisasi perhitungan nilai akhir praktikum, penentuan grade, bobot, status kelulusan mahasiswa, serta mencatat setiap riwayat pemrosesan data ke dalam tabel log secara real-time.

### 🎯 Fitur & Konsep PL/SQL yang Digunakan:
- **Stored Procedure Massal**: Menggunakan *Explicit Cursor* untuk memproses rekapitulasi nilai seluruh mahasiswa sekaligus.
- **Stored Procedure Spesifik (Berparameter)**: Menggunakan *Explicit Cursor dengan Parameter* untuk menyaring dan memproses rekapitulasi khusus per mata kuliah tertentu.
- **Otomatisasi Log Historis**: Mencatat jejak kalkulasi nilai ke tabel log lengkap dengan cap waktu (`TIMESTAMP`) otomatis.
- **Kontrol Aliran Data & Penanganan Error**: Memanfaatkan struktur `CASE WHEN` untuk akurasi grade serta `CONTINUE HANDLER FOR NOT FOUND` untuk menghentikan perulangan kursor secara aman.

---

## 🛠️ Struktur Relasi Tabel (Skema Database)
Database `uts_pbd_kelompok_6` terdiri dari 5 tabel utama yang saling berelasi secara interdependen:

1. **`mahasiswa`**: Menyimpan data identitas mahasiswa (NIM, Nama, Kelas, Angkatan).
2. **`dosen`**: Menyimpan data dosen pengampu praktikum.
3. **`mata_kuliah`**: Menyimpan data mata kuliah yang tersedia.
4. **`grade_nilai`**: Tabel acuan batas atas/bawah nilai untuk penentuan grade & bobot.
5. **`nilai_praktikum`**: Tabel transaksi nilai tugas, kuis, UTS, nilai akhir, grade, dan status lulus.
6. **`log_rekap_nilai`**: Tabel pencatatan riwayat (audit trail) dari eksekusi stored procedure.

### 📐 Pemetaan Dosen & Mata Kuliah (Prinsip 1 MK = 1 Dosen)
Sistem dikonfigurasi dengan pembagian pengajar yang ideal sebagai berikut:
- **`MK_PBD`** (Pemrograman Basis Data) ➡️ **Abdul Malik, S.Kom., M.Cs.**
- **`MK_RPL`** (Rekayasa Perangkat Lunak) ➡️ **Hasanuddin, S.Kom., M.Kom.**
- **`MK_ADSI`** (Analisis Desain Sistem Informasi) ➡️ **Fahmi Kurniawan, S.Kom., M.M.**

---

## 🧮 Rumus Perhitungan Nilai Akhir
Kalkulasi nilai akhir dilakukan secara otomatis di dalam Stored Procedure dengan bobot penilaian:
$$\text{Nilai Akhir} = (\text{Tugas} \times 30\%) + (\text{Kuis} \times 30\%) + (\text{UTS} \times 40\%)$$

### 📊 Skema Batas Grade, Bobot, & Kelulusan
- **A** (4.00) : 93.00 - 100.00 👉 *LULUS*
- **A-** (3.75) : 85.00 - 92.99 👉 *LULUS*
- **B+** (3.50) : 81.00 - 84.99 👉 *LULUS*
- **B** (3.25) : 75.00 - 80.99 👉 *LULUS*
- **B-** (3.00) : 71.00 - 74.99 👉 *LULUS*
- **C+** (2.75) : 66.00 - 70.99 👉 *LULUS*
- **C** (2.50) : 61.00 - 65.99 👉 *LULUS*
- **C-** (2.00) : 56.00 - 60.99 👉 *TIDAK LULUS*
- **D** (1.00) : 40.00 - 55.99 👉 *TIDAK LULUS*
- **E** (0.00) : 0.00 - 39.99 👉 *TIDAK LULUS*

---

## 🚀 Cara Instalasi & Penggunaan di phpMyAdmin

### 1. Import Database
1. Buka **XAMPP Control Panel** dan aktifkan modul **Apache** dan **MySQL**.
2. Masuk ke browser lalu buka `localhost/phpmyadmin`.
3. Buat database baru dengan nama `uts_pbd_kelompok_6`.
4. Pilih database tersebut, masuk ke tab **Import**, pilih file `uts_pbd_kelompok_6.sql` dari repository ini, lalu klik **Go**.

### 2. Menguji Stored Procedure Massal (Semua Nilai)
Untuk mengalkulasi dan merapikan seluruh data mahasiswa di semua mata kuliah sekaligus, jalankan perintah SQL ini:
```sql
CALL rekap_semua_nilai();