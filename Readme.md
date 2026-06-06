#  Sistem Rekap Nilai Praktikum Mahasiswa

###  Projek Praktik / Coding Test — Ujian Tengah Semester (UTS) Pemrograman Basis Data
###  Program Studi S1 Informatika — Fakultas Ilmu Komputer — Universitas Mega Buana Palopo (2026)

---

##  Profil Kelompok
* **Nama Kelompok:** Kelompok 6
* **Kelas:** Reguler

### Daftar Anggota Kelompok:
1. **Dimas Aprilino** - `IK2411044`
2. **Jack Stiven** - `IK2411062`
3. **Fauzan Azima** - `IK2411039`
4. **Gefran** - `IK2411029`
5. **Zadly Baan** - `IK2411030`

---

##  Deskripsi Sistem
Projek ini merupakan implementasi sistem database relasional untuk mengotomatisasi pengelolaan rekapitulasi nilai praktikum mahasiswa menggunakan **MySQL/MariaDB** di phpMyAdmin. 

Sistem ini mentransformasi proses kalkulasi manual konvensional (seperti penggunaan spreadsheet) ke dalam mesin otomatisasi database lewat *Stored Procedure*. Saat prosedur dieksekusi, database secara mandiri memindai kumpulan data menggunakan *Explicit Cursor*, membaca nilai mentah (Tugas, Kuis, UTS), menghitung nilai akhir dengan bobot persentase tertentu, menentukan grade beserta bobotnya menggunakan percabangan `CASE WHEN`, mendeteksi status kelulusan, dan mencatat seluruh jejak riwayat pemrosesan (*audit trail*) ke dalam tabel log secara real-time.

---

##  Struktur Tabel
Sistem ini dibangun di atas database `uts_pbd_kelompok_6` yang mengintegrasikan 6 tabel utama dengan aturan *Foreign Key Constraints* untuk menjaga integritas data relasional:

1. **`mahasiswa`**: Menyimpan identitas induk mahasiswa (NIM, Nama, Kelas, Angkatan).
2. **`dosen`**: Menyimpan data induk identitas dosen pengampu.
3. **`mata_kuliah`**: Menyimpan data mata kuliah praktikum yang terhubung ke tabel dosen pengampunya.
4. **`grade_nilai`**: Tabel master acuan baku rentang nilai bawah, nilai atas, huruf mutu, bobot indeks, dan status kelulusan.
5. **`nilai_praktikum`**: Tabel transaksi utama yang menampung nilai mentah (Tugas, Kuis, UTS) serta kolom kalkulasi otomatis (`nilai_akhir`, `grade`, `bobot`, `status`).
6. **`log_rekap_nilai`**: Tabel historis logging untuk mencatat jejak eksekusi sistem (*audit trail*).

---

##  Cara Menjalankan Program

### 1. Persiapan Database
1. Aktifkan modul **Apache** dan **MySQL** pada **XAMPP Control Panel**.
2. Buka web browser Anda dan akses alamat URL `localhost/phpmyadmin`.
3. Buat sebuah database baru dengan nama `uts_pbd_kelompok_6`.
4. Klik pada nama database tersebut, pilih tab **Import**, pilih berkas `uts_pbd_kelompok_6.sql` dari direktori penyimpanan komputer Anda, kemudian klik tombol **Go / Kirim**.

### 2. Menguji Eksekusi Program
* **Prosedur Massal:** Buka tab SQL di phpMyAdmin, panggil prosedur rekap semua nilai, lalu tekan tombol kirim untuk melakukan perhitungan otomatis bagi seluruh baris record mahasiswa secara bersamaan.
* **Prosedur Berparameter:** Buka tab SQL di phpMyAdmin, panggil prosedur rekap per mata kuliah dengan memasukkan parameter kode mata kuliah spesifik (Pilihan valid: `MK_PBD`, `MK_RPL`, atau `MK_ADSI`) di dalam tanda kurung untuk memproses baris data secara terfilter.
* **Pemeriksaan Log:** Buka tab SQL atau buka langsung tabel log untuk memverifikasi entri aktivitas pemrosesan nilai yang berhasil terekam otomatis oleh sistem.

---

##  Daftar Stored Procedure
Sistem database kelompok kami mengimplementasikan dua jenis objek prosedural utama:

1. **`rekap_semua_nilai`**
   * **Deskripsi:** Prosedur massal tanpa parameter yang memanfaatkan *Explicit Cursor* untuk memproses kalkulasi seluruh record mahasiswa yang ada pada tabel nilai, memperbarui status, dan mencatat ringkasan manipulasi baris via fungsi perhitungan modifikasi internal.
2. **`rekap_nilai_per_mk`**
   * **Deskripsi:** Prosedur modular yang menerima parameter input berupa kode mata kuliah, berfungsi memfilter proses kalkulasi data nilai secara spesifik untuk memproses kelas atau mata kuliah praktikum tertentu saja.

---

##  Pembagian Tugas Anggota

* **Dimas Aprilino** (`IK2411044`)
  Kontribusi: Membuat perhitungan nilai akhir menggunakan variabel.

* **Jack Stiven** (`IK2411062`)
  Kontribusi: Membuat dokumentasi, laporan PDF, README GitHub, dan pengujian program.

* **Fauzan Azima** (`IK2411039`)
  Kontribusi: Membuat implicit cursor, explicit cursor, dan cursor dengan parameter.

* **Gefran** (`IK2411029`)
  Kontribusi: Membuat database, tabel, relasi, dan data awal.

* **Zadly Baan** (`IK2411030`)
  Kontribusi: Membuat percabangan grade, bobot, status kelulusan, dan perulangan.

---

* **Dosen Pengampu:** Abdul Malik, S.Kom., M.Cs.
* **Program Studi:** S1 Informatika
* **Universitas:** Universitas Mega Buana Palopo
