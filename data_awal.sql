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

--
-- Dumping data untuk tabel `dosen`
--

INSERT INTO `dosen` (`kode_dosen`, `nama_dosen`, `email`) VALUES
('D001', 'Prof. Dr. Ahmad Subarjo', 'ahmad.subarjo@univ.ac.id'),
('D002', 'Dr. Siti Aminah', 'siti.aminah@univ.ac.id');

--
-- Dumping data untuk tabel `grade_nilai`
--

INSERT INTO `grade_nilai` (`grade`, `bobot`, `nilai_bawah`, `nilai_atas`) VALUES
('A', 4.00, 85.00, 100.00),
('B', 3.00, 70.00, 84.99),
('C', 2.00, 55.00, 69.99),
('D', 1.00, 40.00, 54.99),
('E', 0.00, 0.00, 39.99);

--
-- Dumping data untuk tabel `log_rekap_nilai`
--

INSERT INTO `log_rekap_nilai` (`id_log`, `nim`, `kode_mk`, `nilai_akhir`, `grade`, `bobot`, `status_lulus`, `keterangan`, `waktu_proses`) VALUES
(136, '24001', 'MK001', 86.50, 'A', 4.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(137, '24002', 'MK001', 75.50, 'B', 3.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(138, '24003', 'MK001', 63.50, 'C', 2.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(139, '24004', 'MK001', 48.00, 'D', 1.00, 'TIDAK LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(140, '24005', 'MK001', 34.50, 'E', 0.00, 'TIDAK LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(141, '24006', 'MK001', 93.00, 'A', 4.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(142, '24007', 'MK001', 81.00, 'B', 3.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(143, '24008', 'MK001', 69.50, 'C', 2.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(144, '24009', 'MK001', 52.00, 'D', 1.00, 'TIDAK LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(145, '24010', 'MK001', 25.00, 'E', 0.00, 'TIDAK LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(146, '24001', 'MK002', 82.50, 'B', 3.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(147, '24002', 'MK002', 68.50, 'C', 2.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(148, '24003', 'MK002', 54.50, 'D', 1.00, 'TIDAK LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(149, '24004', 'MK002', 37.00, 'E', 0.00, 'TIDAK LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(150, '24005', 'MK002', 90.00, 'A', 4.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(151, '24006', 'MK002', 77.00, 'B', 3.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(152, '24007', 'MK002', 63.50, 'C', 2.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(153, '24008', 'MK002', 49.50, 'D', 1.00, 'TIDAK LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(154, '24009', 'MK002', 29.00, 'E', 0.00, 'TIDAK LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19'),
(155, '24010', 'MK002', 85.00, 'A', 4.00, 'LULUS', 'Berhasil memperbarui nilai akhir, grade, dan status.', '2026-06-05 23:20:19');

--
-- Dumping data untuk tabel `mahasiswa`
--

INSERT INTO `mahasiswa` (`nim`, `nama`, `kelas`, `angkatan`) VALUES
('24001', 'Andi Wijaya', 'IK-2A', 2024),
('24002', 'Budi Santoso', 'IK-2A', 2024),
('24003', 'Citra Lestari', 'IK-2A', 2024),
('24004', 'Dedi Kurniawan', 'IK-2A', 2024),
('24005', 'Eka Putri', 'IK-2A', 2024),
('24006', 'Fajar Hidayat', 'IK-2B', 2024),
('24007', 'Gita Permata', 'IK-2B', 2024),
('24008', 'Hadi Saputra', 'IK-2B', 2024),
('24009', 'Indah Sari', 'IK-2B', 2024),
('24010', 'Joko Susilo', 'IK-2B', 2024);

--
-- Dumping data untuk tabel `mata_kuliah`
--

INSERT INTO `mata_kuliah` (`kode_mk`, `nama_mk`, `sks`, `semester`, `kode_dosen`) VALUES
('MK001', 'Pemrograman Basis Data', 3, 4, 'D001'),
('MK002', 'Sistem Informasi', 2, 4, 'D002');

--
-- Dumping data untuk tabel `nilai_praktikum`
--

INSERT INTO `nilai_praktikum` (`id_nilai`, `nim`, `kode_mk`, `nilai_tugas`, `nilai_kuis`, `nilai_uts`, `nilai_akhir`, `grade`, `bobot`, `status_lulus`) VALUES
(1, '24001', 'MK001', 85.00, 80.00, 90.00, 86.50, 'A', 4.00, 'LULUS'),
(2, '24002', 'MK001', 75.00, 70.00, 80.00, 75.50, 'B', 3.00, 'LULUS'),
(3, '24003', 'MK001', 65.00, 60.00, 65.00, 63.50, 'C', 2.00, 'LULUS'),
(4, '24004', 'MK001', 50.00, 45.00, 50.00, 48.00, 'D', 1.00, 'TIDAK LULUS'),
(5, '24005', 'MK001', 40.00, 30.00, 35.00, 34.50, 'E', 0.00, 'TIDAK LULUS'),
(6, '24006', 'MK001', 95.00, 90.00, 95.00, 93.00, 'A', 4.00, 'LULUS'),
(7, '24007', 'MK001', 80.00, 80.00, 82.00, 81.00, 'B', 3.00, 'LULUS'),
(8, '24008', 'MK001', 70.00, 65.00, 72.00, 69.50, 'C', 2.00, 'LULUS'),
(9, '24009', 'MK001', 55.00, 50.00, 52.00, 52.00, 'D', 1.00, 'TIDAK LULUS'),
(10, '24010', 'MK001', 30.00, 20.00, 25.00, 25.00, 'E', 0.00, 'TIDAK LULUS'),
(11, '24001', 'MK002', 80.00, 85.00, 82.00, 82.50, 'B', 3.00, 'LULUS'),
(12, '24002', 'MK002', 70.00, 65.00, 70.00, 68.50, 'C', 2.00, 'LULUS'),
(13, '24003', 'MK002', 55.00, 50.00, 57.00, 54.50, 'D', 1.00, 'TIDAK LULUS'),
(14, '24004', 'MK002', 40.00, 35.00, 37.00, 37.00, 'E', 0.00, 'TIDAK LULUS'),
(15, '24005', 'MK002', 90.00, 90.00, 90.00, 90.00, 'A', 4.00, 'LULUS'),
(16, '24006', 'MK002', 75.00, 78.00, 77.00, 77.00, 'B', 3.00, 'LULUS'),
(17, '24007', 'MK002', 65.00, 60.00, 65.00, 63.50, 'C', 2.00, 'LULUS'),
(18, '24008', 'MK002', 50.00, 48.00, 50.00, 49.50, 'D', 1.00, 'TIDAK LULUS'),
(19, '24009', 'MK002', 30.00, 25.00, 31.00, 29.00, 'E', 0.00, 'TIDAK LULUS'),
(20, '24010', 'MK002', 85.00, 85.00, 85.00, 85.00, 'A', 4.00, 'LULUS');

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;