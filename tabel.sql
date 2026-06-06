-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 06 Jun 2026 pada 07.20
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------

--
-- Struktur dari tabel `dosen`
--

CREATE TABLE `dosen` (
  `kode_dosen` varchar(10) NOT NULL,
  `nama_dosen` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `grade_nilai`
--

CREATE TABLE `grade_nilai` (
  `grade` varchar(2) NOT NULL,
  `bobot` decimal(3,2) NOT NULL,
  `nilai_bawah` decimal(5,2) NOT NULL,
  `nilai_atas` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_rekap_nilai`
--

CREATE TABLE `log_rekap_nilai` (
  `id_log` int(11) NOT NULL,
  `nim` varchar(15) DEFAULT NULL,
  `kode_mk` varchar(10) DEFAULT NULL,
  `nilai_akhir` decimal(5,2) DEFAULT NULL,
  `grade` varchar(2) DEFAULT NULL,
  `bobot` decimal(3,2) DEFAULT NULL,
  `status_lulus` varchar(15) DEFAULT NULL,
  `keterangan` varchar(255) NOT NULL,
  `waktu_proses` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `nim` varchar(15) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `kelas` varchar(10) NOT NULL,
  `angkatan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `mata_kuliah`
--

CREATE TABLE `mata_kuliah` (
  `kode_mk` varchar(10) NOT NULL,
  `nama_mk` varchar(100) NOT NULL,
  `sks` int(11) NOT NULL,
  `semester` int(11) NOT NULL,
  `kode_dosen` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `nilai_praktikum`
--

CREATE TABLE `nilai_praktikum` (
  `id_nilai` int(11) NOT NULL,
  `nim` varchar(15) DEFAULT NULL,
  `kode_mk` varchar(10) DEFAULT NULL,
  `nilai_tugas` decimal(5,2) NOT NULL,
  `nilai_kuis` decimal(5,2) NOT NULL,
  `nilai_uts` decimal(5,2) NOT NULL,
  `nilai_akhir` decimal(5,2) DEFAULT NULL,
  `grade` varchar(2) DEFAULT NULL,
  `bobot` decimal(3,2) DEFAULT NULL,
  `status_lulus` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `dosen`
--
ALTER TABLE `dosen`
  ADD PRIMARY KEY (`kode_dosen`);

--
-- Indeks untuk tabel `grade_nilai`
--
ALTER TABLE `grade_nilai`
  ADD PRIMARY KEY (`grade`);

--
-- Indeks untuk tabel `log_rekap_nilai`
--
ALTER TABLE `log_rekap_nilai`
  ADD PRIMARY KEY (`id_log`);

--
-- Indeks untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`nim`);

--
-- Indeks untuk tabel `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD PRIMARY KEY (`kode_mk`),
  ADD KEY `fk_mk_dosen` (`kode_dosen`);

--
-- Indeks untuk tabel `nilai_praktikum`
--
ALTER TABLE `nilai_praktikum`
  ADD PRIMARY KEY (`id_nilai`),
  ADD KEY `fk_nilai_mhs` (`nim`),
  ADD KEY `fk_nilai_mk` (`kode_mk`),
  ADD KEY `fk_nilai_grade` (`grade`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `log_rekap_nilai`
--
ALTER TABLE `log_rekap_nilai`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=156;

--
-- AUTO_INCREMENT untuk tabel `nilai_praktikum`
--
ALTER TABLE `nilai_praktikum`
  MODIFY `id_nilai` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;