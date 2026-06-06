##  Sistem Rekap Nilai Praktikum Mahasiswa
> **Projek Praktik / Coding Test — Ujian Tengah Semester (UTS) Pemrograman Basis Data**
> **Program Studi S1 Informatika — Fakultas Ilmu Komputer — Universitas Mega Buana Palopo (2026)**

---

##  Anggota Kelompok 6 (Informatika A)
1. **Dimas Aprilino** - `IK2411044`
        Kontribusi: Membuat perhitungan nilai akhir menggunakan variabel
2. **Jack Stiven** - `IK2411062`
        Kontribusi: Membuat dokumentasi, laporan PDF, README GitHub, dan pengujian 
        program 
3. **Fauzan Azima** - `IK2411039`
        Kontribusi: Membuat implicit cursor, explicit cursor, dan cursor dengan parameter
4. **Gefran** - `IK2411029`
        Kontribusi: Membuat database, tabel, relasi, dan data awal 
5. **Zadly Baan** - `IK2411030`
        Kontribusi: Membuat percabangan grade, bobot, status kelulusan, dan perulangan

---

##  Deskripsi Sistem
Projek ini merupakan implementasi sistem database relasional untuk otomatisasi pengelolaan nilai praktikum mahasiswa menggunakan **MySQL/MariaDB** di phpMyAdmin. 

Sistem ini mentransformasi proses kalkulasi manual (seperti penggunaan Excel) ke dalam mesin otomatisasi database lewat *Stored Procedure*. Saat prosedur dieksekusi, database secara mandiri membaca nilai mentah (Tugas, Kuis, UTS), menghitung nilai akhir, menentukan grade beserta bobotnya, mendeteksi status kelulusan, dan mencatat seluruh jejak riwayat proses (*audit trail*) ke dalam tabel log secara real-time.

###  Fitur & Konsep PL/SQL yang Diterapkan:
- **Variabel Lokal:** Berfungsi menampung memori kalkulasi sementara saat rumus persentase nilai sedang diproses.
- **Struktur Percabangan (`CASE WHEN`):** Menerapkan logika klasifikasi grade dan ambang batas kelulusan berdasarkan regulasi akademik.
- **Perulangan & Explicit Cursor:** Membaca dan memproses kumpulan data nilai mahasiswa baris demi baris di memori secara aman tanpa ada data yang terlewat.
- **Cursor dengan Parameter:** Fitur filtrasi modular untuk mengeksekusi rekapitulasi data secara spesifik per mata kuliah.
- **Implicit Cursor (`ROW_COUNT()`):** Memberikan output ringkasan di layar mengenai jumlah total baris data yang berhasil dimanipulasi.

---

##  Struktur & Relasi Tabel
Sistem dibangun di atas database `uts_pbd_kelompok_6` yang mengintegrasikan 6 tabel utama secara konsisten:

1. **`mahasiswa`**: Menyimpan identitas mahasiswa (NIM, Nama, Kelas, Angkatan).
2. **`dosen`**: Menyimpan data dosen pengampu.
3. **`mata_kuliah`**: Menyimpan data mata kuliah yang berelasi ke tabel `dosen` via *Foreign Key*.
4. **`grade_nilai`**: Menyimpan acuan baku rentang nilai bawah, nilai atas, huruf mutu, dan bobot.
5. **`nilai_praktikum`**: Menyimpan record nilai akademis (kolom hasil kalkulasi dikosongkan/`NULL` di awal dan diisi otomatis oleh prosedur).
6. **`log_rekap_nilai`**: Menyimpan riwayat eksekusi sistem sebagai dokumentasi keamanan data nilai.

###  Pemetaan Dosen & Mata Kuliah (1 MK = 1 Dosen)
Untuk akurasi data, relasi dosen pengampu telah dikonfigurasi secara seimbang:
- **`MK_PBD`** (Pemrograman Basis Data) ➡️ **Abdul Malik, S.Kom., M.Cs.**
- **`MK_RPL`** (Rekayasa Perangkat Lunak) ➡️ **Hasanuddin, S.Kom., M.Kom.**
- **`MK_ADSI`** (Analisis Desain Sistem Informasi) ➡️ **Fahmi Kurniawan, S.Kom., M.M.**

---

##  Logika Perhitungan & Aturan Akademik

### 1. Rumus Nilai Akhir
Nilai Akhir = (Nilai Tugas * 30%) + (Nilai Kuis * 30%) + (Nilai UTS * 40%)

### 2. Standar Klasifikasi Batas Grade & Bobot
* **A** (Bobot: 4.00) ➡️ Rentang: 93.00 - 100.00
* **A-** (Bobot: 3.75) ➡️ Rentang: 85.00 - 92.99
* **B+** (Bobot: 3.50) ➡️ Rentang: 81.00 - 84.99
* **B** (Bobot: 3.25) ➡️ Rentang: 75.00 - 80.99
* **B-** (Bobot: 3.00) ➡️ Rentang: 71.00 - 74.99
* **C+** (Bobot: 2.75) ➡️ Rentang: 66.00 - 70.99
* **C** (Bobot: 2.50) ➡️ Rentang: 61.00 - 65.99
* **C-** (Bobot: 2.00) ➡️ Rentang: 56.00 - 60.99
* **D** (Bobot: 1.00) ➡️ Rentang: 40.00 - 55.99
* **E** (Bobot: 0.00) ➡️ Rentang: 0.00 - 39.99

### 3. Batas Ambang Kelulusan
* **LULUS**: Jika mendapatkan Grade **A, A-, B+, B, B-, C+, C** (Batas minimal kelulusan adalah Grade C).
* **TIDAK LULUS**: Jika mendapatkan Grade **C-, D, E**.

---

##  Panduan Instalasi & Pengujian Program

### 1. Persiapan Database (Import Skema & Data Awal)
1. Aktifkan modul **Apache** dan **MySQL** pada **XAMPP Control Panel**.
2. Buka browser dan arahkan ke alamat URL `localhost/phpmyadmin`.
3. Buat database baru dengan nama `uts_pbd_kelompok_6`.
4. Klik database tersebut, beralih ke tab **Import**, pilih file `uts_pbd_kelompok_6.sql` dari direktori komputer Anda, kemudian tekan tombol **Go/Kirim**.

### 2. Menguji Stored Procedure Massal (Seluruh Mahasiswa)
Proses ini digunakan untuk memproses kalkulasi nilai seluruh mahasiswa di semua mata kuliah secara sekaligus melalui tab SQL phpMyAdmin. Sistem secara otomatis akan memproses seluruh baris data di dalam tabel nilai, menerapkan rumus penilaian, memperbarui kolom hasil kalkulasi, memunculkan informasi ringkasan jumlah baris data yang berhasil dimanipulasi, serta mencatat riwayat eksekusinya ke dalam tabel log pemrosesan.

### 3. Menguji Stored Procedure Filter (Per Mata Kuliah)
Proses ini digunakan untuk melakukan rekapitulasi nilai mahasiswa secara spesifik pada satu jenis mata kuliah pilihan tertentu saja dengan memasukkan parameter yang sesuai pada tab SQL phpMyAdmin.

>  **Catatan:** Pilihan kode mata kuliah pengujian yang valid dan terdaftar di dalam sistem database kelompok kami meliputi:
> - `MK_PBD` untuk mata kuliah Pemrograman Basis Data.
> - `MK_RPL` untuk mata kuliah Rekayasa Perangkat Lunak.
> - `MK_ADSI` untuk mata kuliah Analisis Desain Sistem Informasi.

---

## 🗂️ Daftar File Repository
* 📂 `uts_pbd_kelompok_6.sql` ➡️ Backup database utama yang berisi struktur skema tabel, data awal bervariasi, dan seluruh kode *Stored Procedure*.
* 📂 `UTS_PBD_Kelompok_06.pdf` ➡️ Laporan dokumentasi resmi projek kelompok.
* 📂 `README.md` ➡️ Panduan komprehensif sistem database ini.

---

##  Surat Pernyataan Kontribusi
Dengan ini kami menyatakan bahwa projek UTS Pemrograman Basis Data ini dikerjakan oleh kelompok kami sendiri. Setiap anggota telah berkontribusi sesuai dengan pembagian tugas masing-masing. Apabila di kemudian hari ditemukan tindakan plagiasi atau ketidakjujuran akademik, kami siap menerima segala konsekuensi penilaian dari dosen pengampu.

* **Dosen Pengampu:** Abdul Malik, S.Kom., M.Cs.
* **Program Studi:** S1 Informatika
* **Universitas:** Universitas Mega Buana Palopo
