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
-- Database: `uts_pbd_kelompok_6`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `rekap_nilai_per_mk` (IN `p_kode_mk` VARCHAR(10))   BEGIN
    DECLARE v_id INT;
    DECLARE v_nim VARCHAR(15);
    DECLARE v_tugas DECIMAL(5,2);
    DECLARE v_kuis DECIMAL(5,2);
    DECLARE v_uts DECIMAL(5,2);
    DECLARE v_akhir DECIMAL(5,2);
    DECLARE v_grade VARCHAR(2);
    DECLARE v_bobot DECIMAL(3,2);
    DECLARE v_status VARCHAR(15);
    
    DECLARE done INT DEFAULT FALSE;
    DECLARE total_terproses INT DEFAULT 0;

    -- Explicit Cursor dengan parameter filter kode mata kuliah dinamis
    DECLARE cur_nilai_mk CURSOR FOR 
        SELECT id_nilai, nim, nilai_tugas, nilai_kuis, nilai_uts 
        FROM nilai_praktikum 
        WHERE kode_mk = p_kode_mk;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur_nilai_mk;

    rekap_mk_loop: LOOP
        FETCH cur_nilai_mk INTO v_id, v_nim, v_tugas, v_kuis, v_uts;
        
        IF done THEN
            LEAVE rekap_mk_loop;
        END IF;

        -- Hitung rumus (Tugas 30%, Kuis 30%, UTS 40%)
        SET v_akhir = (v_tugas * 0.30) + (v_kuis * 0.30) + (v_uts * 0.40);

        -- Evaluasi Percabangan Skema Grade & Bobot Baru
        CASE 
            WHEN v_akhir BETWEEN 93.00 AND 100.00 THEN SET v_grade = 'A', v_bobot = 4.00, v_status = 'LULUS';
            WHEN v_akhir BETWEEN 85.00 AND 92.99 THEN SET v_grade = 'A-', v_bobot = 3.75, v_status = 'LULUS';
            WHEN v_akhir BETWEEN 81.00 AND 84.99 THEN SET v_grade = 'B+', v_bobot = 3.50, v_status = 'LULUS';
            WHEN v_akhir BETWEEN 75.00 AND 80.99 THEN SET v_grade = 'B', v_bobot = 3.25, v_status = 'LULUS';
            WHEN v_akhir BETWEEN 71.00 AND 74.99 THEN SET v_grade = 'B-', v_bobot = 3.00, v_status = 'LULUS';
            WHEN v_akhir BETWEEN 66.00 AND 70.99 THEN SET v_grade = 'C+', v_bobot = 2.75, v_status = 'LULUS';
            WHEN v_akhir BETWEEN 61.00 AND 65.99 THEN SET v_grade = 'C', v_bobot = 2.50, v_status = 'LULUS';
            WHEN v_akhir BETWEEN 56.00 AND 60.99 THEN SET v_grade = 'C-', v_bobot = 2.00, v_status = 'TIDAK LULUS';
            WHEN v_akhir BETWEEN 40.00 AND 55.99 THEN SET v_grade = 'D', v_bobot = 1.00, v_status = 'TIDAK LULUS';
            ELSE SET v_grade = 'E', v_bobot = 0.00, v_status = 'TIDAK LULUS';
        END CASE;

        -- Simpan hasil manipulasi data ke tabel nilai_praktikum
        UPDATE nilai_praktikum 
        SET nilai_akhir = v_akhir,
            grade = v_grade,
            bobot = v_bobot,
            status_lulus = v_status
        WHERE id_nilai = v_id;
        
        -- Catat aktivitas detail ke tabel log
        INSERT INTO log_rekap_nilai (nim, kode_mk, nilai_akhir, grade, bobot, status_lulus, keterangan)
        VALUES (v_nim, p_kode_mk, v_akhir, v_grade, v_bobot, v_status, CONCAT('Proses Rekap Spesifik MK: ', p_kode_mk));
        
        -- Counter penampung ROW_COUNT() internal
        IF ROW_COUNT() > 0 THEN
            SET total_terproses = total_terproses + 1;
        END IF;
        
    END LOOP rekap_mk_loop;

    CLOSE cur_nilai_mk;

    -- Tampilkan ringkasan total baris terubah yang aman ke antarmuka terminal phpMyAdmin
    SELECT total_terproses AS jumlah_data_diproses;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rekap_semua_nilai` ()   BEGIN
    -- Deklarasi Variabel Lokal (Poin 3 Halaman 8)
    DECLARE v_id INT;
    DECLARE v_nim VARCHAR(15);
    DECLARE v_kode_mk VARCHAR(10);
    DECLARE v_tugas DECIMAL(5,2);
    DECLARE v_kuis DECIMAL(5,2);
    DECLARE v_uts DECIMAL(5,2);
    DECLARE v_akhir DECIMAL(5,2);
    DECLARE v_grade VARCHAR(2);
    DECLARE v_bobot DECIMAL(3,2);
    DECLARE v_status VARCHAR(15);
    
    DECLARE done INT DEFAULT FALSE;
    DECLARE total_terproses INT DEFAULT 0;

    -- Explicit Cursor membaca data dari tabel nilai_praktikum (Poin 7 Halaman 9)
    DECLARE cur_nilai CURSOR FOR 
        SELECT id_nilai, nim, kode_mk, nilai_tugas, nilai_kuis, nilai_uts 
        FROM nilai_praktikum;
        
    -- Continue Handler untuk mengontrol kursor selesai
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur_nilai;

    rekap_loop: LOOP
        FETCH cur_nilai INTO v_id, v_nim, v_kode_mk, v_tugas, v_kuis, v_uts;
        
        IF done THEN
            LEAVE rekap_loop;
        END IF;

        -- RUMUS NILAI AKHIR: (Tugas*30%) + (Kuis*30%) + (UTS*40%) -> PERBAIKAN SOAL POIN I HAL 7
        SET v_akhir = (v_tugas * 0.30) + (v_kuis * 0.30) + (v_uts * 0.40);

        -- PERCABANGAN GRADE, BOBOT, & STATUS (Poin 4 Halaman 8 & Poin G/H Halaman 6)
        CASE 
            WHEN v_akhir BETWEEN 93.00 AND 100.00 THEN SET v_grade = 'A', v_bobot = 4.00, v_status = 'LULUS';
            WHEN v_akhir BETWEEN 85.00 AND 92.99 THEN SET v_grade = 'A-', v_bobot = 3.75, v_status = 'LULUS'; -- Sesuai PDF 3.75
            WHEN v_akhir BETWEEN 81.00 AND 84.99 THEN SET v_grade = 'B+', v_bobot = 3.50, v_status = 'LULUS'; -- Sesuai PDF 3.50
            WHEN v_akhir BETWEEN 75.00 AND 80.99 THEN SET v_grade = 'B', v_bobot = 3.25, v_status = 'LULUS';  -- Sesuai PDF 3.25
            WHEN v_akhir BETWEEN 71.00 AND 74.99 THEN SET v_grade = 'B-', v_bobot = 3.00, v_status = 'LULUS';
            WHEN v_akhir BETWEEN 66.00 AND 70.99 THEN SET v_grade = 'C+', v_bobot = 2.75, v_status = 'LULUS'; -- Sesuai PDF 2.75
            WHEN v_akhir BETWEEN 61.00 AND 65.99 THEN SET v_grade = 'C', v_bobot = 2.50, v_status = 'LULUS';  -- Sesuai PDF 2.50
            WHEN v_akhir BETWEEN 56.00 AND 60.99 THEN SET v_grade = 'C-', v_bobot = 2.00, v_status = 'TIDAK LULUS'; -- Sesuai PDF 2.00
            WHEN v_akhir BETWEEN 40.00 AND 55.99 THEN SET v_grade = 'D', v_bobot = 1.00, v_status = 'TIDAK LULUS';
            ELSE SET v_grade = 'E', v_bobot = 0.00, v_status = 'TIDAK LULUS';
        END CASE;

        -- Update ke tabel nilai_praktikum
        UPDATE nilai_praktikum 
        SET nilai_akhir = v_akhir,
            grade = v_grade,
            bobot = v_bobot,
            status_lulus = v_status
        WHERE id_nilai = v_id;
        
        -- Memasukkan detail riwayat ke tabel log_rekap_nilai per baris mahasiswa (Instruksi Hal 5 & 6)
        INSERT INTO log_rekap_nilai (nim, kode_mk, nilai_akhir, grade, bobot, status_lulus, keterangan)
        VALUES (v_nim, v_kode_mk, v_akhir, v_grade, v_bobot, v_status, 'Proses Rekap Massal via Explicit Cursor');
        
        -- Counter internal untuk menghitung total baris yang BERHASIL diubah nilainya
        IF ROW_COUNT() > 0 THEN
            SET total_terproses = total_terproses + 1;
        END IF;
        
    END LOOP rekap_loop;

    CLOSE cur_nilai;

    -- IMPLICIT CURSOR (ROW_COUNT): Menampilkan summary data yang terproses ke layar (Poin 6 Halaman 8-9)
    -- Kita bypass dengan menampilkan variable penampung ROW_COUNT() akumulatif agar nilainya tidak buyar/0.
    SELECT total_terproses AS jumlah_data_diproses;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `dosen`
--

CREATE TABLE `dosen` (
  `kode_dosen` varchar(10) NOT NULL,
  `nama_dosen` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `dosen`
--

INSERT INTO `dosen` (`kode_dosen`, `nama_dosen`, `email`) VALUES
('DP_ADSI', 'Fahmi Kurniawan, S.Kom., M.M.', 'fahmi.adsi@umbpalopo.ac.id'),
('DP_PBD', 'Abdul Malik, S.Kom., M.Cs.', 'malik.pbd@umbpalopo.ac.id'),
('DP_RPL', 'Hasanuddin, S.Kom., M.Kom.', 'hasan.rpl@umbpalopo.ac.id');

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

--
-- Dumping data untuk tabel `grade_nilai`
--

INSERT INTO `grade_nilai` (`grade`, `bobot`, `nilai_bawah`, `nilai_atas`) VALUES
('A', 4.00, 93.00, 100.00),
('A-', 3.75, 85.00, 92.99),
('B', 3.25, 75.00, 80.99),
('B+', 3.50, 81.00, 84.99),
('B-', 3.00, 71.00, 74.99),
('C', 2.50, 61.00, 65.99),
('C+', 2.75, 66.00, 70.99),
('C-', 2.00, 56.00, 60.99),
('D', 1.00, 40.00, 55.99),
('E', 0.00, 0.00, 39.99);

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

--
-- Dumping data untuk tabel `log_rekap_nilai`
--

INSERT INTO `log_rekap_nilai` (`id_log`, `nim`, `kode_mk`, `nilai_akhir`, `grade`, `bobot`, `status_lulus`, `keterangan`, `waktu_proses`) VALUES
(1, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:26'),
(2, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:26'),
(3, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:26'),
(4, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:26'),
(5, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:26'),
(6, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:26'),
(7, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:26'),
(8, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:38'),
(9, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:38'),
(10, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:38'),
(11, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:38'),
(12, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:38'),
(13, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:38'),
(14, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:38'),
(15, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:50'),
(16, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:50'),
(17, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:50'),
(18, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:50'),
(19, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:50'),
(20, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:50'),
(21, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:34:50'),
(22, 'IK2411042', 'MK_RPL', 92.20, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:35:15'),
(23, 'IK2411041', 'MK_RPL', 86.70, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:35:15'),
(24, 'IK2411052', 'MK_RPL', 80.80, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:35:15'),
(25, 'IK2411054', 'MK_RPL', 73.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:35:15'),
(26, 'IK2411022', 'MK_RPL', 67.80, 'C+', 2.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:35:15'),
(27, 'IK2411025', 'MK_RPL', 59.80, 'C-', 2.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:35:15'),
(28, 'IK2411005', 'MK_PAM', 35.00, 'E', 0.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PAM', '2026-06-06 02:35:26'),
(29, 'IK2411019', 'MK_PAM', 96.50, 'A', 4.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PAM', '2026-06-06 02:35:26'),
(30, 'IK2411037', 'MK_PAM', 84.20, 'B+', 3.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PAM', '2026-06-06 02:35:26'),
(31, 'IK2411002', 'MK_PAM', 79.20, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_PAM', '2026-06-06 02:35:26'),
(32, 'IK2411053', 'MK_PAM', 71.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PAM', '2026-06-06 02:35:26'),
(33, 'IK2411009', 'MK_PAM', 63.20, 'C', 2.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PAM', '2026-06-06 02:35:26'),
(34, 'IK2411027', 'MK_PAM', 49.80, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PAM', '2026-06-06 02:35:26'),
(35, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(36, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(37, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(38, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(39, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(40, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(41, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(42, 'IK2411042', 'MK_RPL', 92.20, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(43, 'IK2411041', 'MK_RPL', 86.70, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(44, 'IK2411052', 'MK_RPL', 80.80, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(45, 'IK2411054', 'MK_RPL', 73.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(46, 'IK2411022', 'MK_RPL', 67.80, 'C+', 2.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(47, 'IK2411025', 'MK_RPL', 59.80, 'C-', 2.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(48, 'IK2411005', 'MK_PAM', 35.00, 'E', 0.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(49, 'IK2411019', 'MK_PAM', 96.50, 'A', 4.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(50, 'IK2411037', 'MK_PAM', 84.20, 'B+', 3.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(51, 'IK2411002', 'MK_PAM', 79.20, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(52, 'IK2411053', 'MK_PAM', 71.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(53, 'IK2411009', 'MK_PAM', 63.20, 'C', 2.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(54, 'IK2411027', 'MK_PAM', 49.80, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:42'),
(55, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(56, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(57, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(58, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(59, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(60, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(61, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(62, 'IK2411042', 'MK_RPL', 92.20, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(63, 'IK2411041', 'MK_RPL', 86.70, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(64, 'IK2411052', 'MK_RPL', 80.80, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(65, 'IK2411054', 'MK_RPL', 73.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(66, 'IK2411022', 'MK_RPL', 67.80, 'C+', 2.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(67, 'IK2411025', 'MK_RPL', 59.80, 'C-', 2.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(68, 'IK2411005', 'MK_PAM', 35.00, 'E', 0.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(69, 'IK2411019', 'MK_PAM', 96.50, 'A', 4.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(70, 'IK2411037', 'MK_PAM', 84.20, 'B+', 3.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(71, 'IK2411002', 'MK_PAM', 79.20, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(72, 'IK2411053', 'MK_PAM', 71.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(73, 'IK2411009', 'MK_PAM', 63.20, 'C', 2.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(74, 'IK2411027', 'MK_PAM', 49.80, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:46'),
(75, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(76, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(77, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(78, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(79, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(80, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(81, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(82, 'IK2411042', 'MK_RPL', 92.20, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(83, 'IK2411041', 'MK_RPL', 86.70, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(84, 'IK2411052', 'MK_RPL', 80.80, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(85, 'IK2411054', 'MK_RPL', 73.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(86, 'IK2411022', 'MK_RPL', 67.80, 'C+', 2.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(87, 'IK2411025', 'MK_RPL', 59.80, 'C-', 2.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(88, 'IK2411005', 'MK_PAM', 35.00, 'E', 0.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(89, 'IK2411019', 'MK_PAM', 96.50, 'A', 4.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(90, 'IK2411037', 'MK_PAM', 84.20, 'B+', 3.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(91, 'IK2411002', 'MK_PAM', 79.20, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(92, 'IK2411053', 'MK_PAM', 71.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(93, 'IK2411009', 'MK_PAM', 63.20, 'C', 2.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(94, 'IK2411027', 'MK_PAM', 49.80, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:35:49'),
(95, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(96, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(97, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(98, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(99, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(100, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(101, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(102, 'IK2411042', 'MK_RPL', 92.20, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(103, 'IK2411041', 'MK_RPL', 86.70, 'A-', 3.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(104, 'IK2411052', 'MK_RPL', 80.80, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(105, 'IK2411054', 'MK_RPL', 73.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(106, 'IK2411022', 'MK_RPL', 67.80, 'C+', 2.75, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(107, 'IK2411025', 'MK_RPL', 59.80, 'C-', 2.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(108, 'IK2411005', 'MK_PAM', 35.00, 'E', 0.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(109, 'IK2411019', 'MK_PAM', 96.50, 'A', 4.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(110, 'IK2411037', 'MK_PAM', 84.20, 'B+', 3.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(111, 'IK2411002', 'MK_PAM', 79.20, 'B', 3.25, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(112, 'IK2411053', 'MK_PAM', 71.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(113, 'IK2411009', 'MK_PAM', 63.20, 'C', 2.50, 'LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(114, 'IK2411027', 'MK_PAM', 49.80, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Massal via Explicit Cursor', '2026-06-06 02:41:37'),
(115, 'IK2411042', 'MK_RPL', 92.20, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:41:47'),
(116, 'IK2411041', 'MK_RPL', 86.70, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:41:47'),
(117, 'IK2411052', 'MK_RPL', 80.80, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:41:47'),
(118, 'IK2411054', 'MK_RPL', 73.80, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:41:47'),
(119, 'IK2411022', 'MK_RPL', 67.80, 'C+', 2.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:41:47'),
(120, 'IK2411025', 'MK_RPL', 59.80, 'C-', 2.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_RPL', '2026-06-06 02:41:47'),
(121, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:44:22'),
(122, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:44:22'),
(123, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:44:22'),
(124, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:44:22'),
(125, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:44:22'),
(126, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:44:22'),
(127, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:44:22'),
(128, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:46:03'),
(129, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:46:03'),
(130, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:46:03'),
(131, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:46:03'),
(132, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:46:03'),
(133, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:46:03'),
(134, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:46:03'),
(135, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:52:28'),
(136, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:52:28'),
(137, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:52:28'),
(138, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:52:28'),
(139, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:52:28'),
(140, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:52:28'),
(141, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 02:52:28'),
(142, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:13:04'),
(143, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:13:04'),
(144, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:13:04'),
(145, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:13:04'),
(146, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:13:04'),
(147, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:13:04'),
(148, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:13:04'),
(149, 'IK2411044', 'MK_PBD', 93.50, 'A', 4.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:22:30'),
(150, 'IK2411062', 'MK_PBD', 85.50, 'A-', 3.75, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:22:30'),
(151, 'IK2411039', 'MK_PBD', 80.00, 'B', 3.25, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:22:30'),
(152, 'IK2411029', 'MK_PBD', 72.30, 'B-', 3.00, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:22:30'),
(153, 'IK2411030', 'MK_PBD', 64.70, 'C', 2.50, 'LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:22:30'),
(154, 'IK2411033', 'MK_PBD', 53.90, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:22:30'),
(155, 'IK2411061', 'MK_PBD', 42.30, 'D', 1.00, 'TIDAK LULUS', 'Proses Rekap Spesifik MK: MK_PBD', '2026-06-06 03:22:30');

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

--
-- Dumping data untuk tabel `mahasiswa`
--

INSERT INTO `mahasiswa` (`nim`, `nama`, `kelas`, `angkatan`) VALUES
('IK2411002', 'Elysia Florean A.L', 'A', 2024),
('IK2411005', 'Dzubian Fauzan S', 'A', 2024),
('IK2411009', 'Dinda Adista Putri', 'A', 2024),
('IK2411019', 'Muh. Ardiansyah', 'B', 2024),
('IK2411022', 'Muh. Afrizal Fahrezy', 'B', 2024),
('IK2411025', 'Arya Maha Putra', 'B', 2024),
('IK2411027', 'Hasbiah', 'A', 2024),
('IK2411029', 'Gefran', 'A', 2024),
('IK2411030', 'Zadly Baan', 'B', 2024),
('IK2411033', 'Ade Fanjaya', 'B', 2024),
('IK2411037', 'Andi Dewa Firdaus', 'A', 2024),
('IK2411039', 'Fauzan Azima', 'A', 2024),
('IK2411041', 'Mayfaizha Zulaicha L.', 'B', 2024),
('IK2411042', 'Azizah Cahya', 'B', 2024),
('IK2411044', 'Dimas Aprilino', 'A', 2024),
('IK2411052', 'Muh. Nur Alam', 'A', 2024),
('IK2411053', 'Sintia', 'B', 2024),
('IK2411054', 'Muh. Rizqi Maulana', 'B', 2024),
('IK2411061', 'Muh. Mahruf', 'A', 2024),
('IK2411062', 'Jack Stiven', 'A', 2024);

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

--
-- Dumping data untuk tabel `mata_kuliah`
--

INSERT INTO `mata_kuliah` (`kode_mk`, `nama_mk`, `sks`, `semester`, `kode_dosen`) VALUES
('MK_ADSI', 'Analisis Desain Sistem Informasi', 3, 4, 'DP_ADSI'),
('MK_PBD', 'Pemrograman Basis Data', 3, 4, 'DP_PBD'),
('MK_RPL', 'Rekayasa Perangkat Lunak', 3, 4, 'DP_RPL');

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
-- Dumping data untuk tabel `nilai_praktikum`
--

INSERT INTO `nilai_praktikum` (`id_nilai`, `nim`, `kode_mk`, `nilai_tugas`, `nilai_kuis`, `nilai_uts`, `nilai_akhir`, `grade`, `bobot`, `status_lulus`) VALUES
(1, 'IK2411044', 'MK_PBD', 95.00, 90.00, 95.00, 93.50, 'A', 4.00, 'LULUS'),
(2, 'IK2411062', 'MK_PBD', 85.00, 88.00, 84.00, 85.50, 'A-', 3.75, 'LULUS'),
(3, 'IK2411039', 'MK_PBD', 78.00, 82.00, 80.00, 80.00, 'B', 3.25, 'LULUS'),
(4, 'IK2411029', 'MK_PBD', 70.00, 75.00, 72.00, 72.30, 'B-', 3.00, 'LULUS'),
(5, 'IK2411030', 'MK_PBD', 65.00, 60.00, 68.00, 64.70, 'C', 2.50, 'LULUS'),
(6, 'IK2411033', 'MK_PBD', 55.00, 58.00, 50.00, 53.90, 'D', 1.00, 'TIDAK LULUS'),
(7, 'IK2411061', 'MK_PBD', 40.00, 45.00, 42.00, 42.30, 'D', 1.00, 'TIDAK LULUS'),
(8, 'IK2411042', 'MK_RPL', 92.00, 94.00, 91.00, NULL, NULL, NULL, NULL),
(9, 'IK2411041', 'MK_RPL', 88.00, 85.00, 87.00, NULL, NULL, NULL, NULL),
(10, 'IK2411052', 'MK_RPL', 80.00, 80.00, 82.00, NULL, NULL, NULL, NULL),
(11, 'IK2411054', 'MK_RPL', 74.00, 72.00, 75.00, NULL, NULL, NULL, NULL),
(12, 'IK2411022', 'MK_RPL', 68.00, 66.00, 69.00, NULL, NULL, NULL, NULL),
(13, 'IK2411025', 'MK_RPL', 60.00, 62.00, 58.00, NULL, NULL, NULL, NULL),
(14, 'IK2411005', 'MK_ADSI', 30.00, 40.00, 35.00, NULL, NULL, NULL, NULL),
(15, 'IK2411019', 'MK_ADSI', 96.00, 95.00, 98.00, NULL, NULL, NULL, NULL),
(16, 'IK2411037', 'MK_ADSI', 84.00, 86.00, 83.00, NULL, NULL, NULL, NULL),
(17, 'IK2411002', 'MK_ADSI', 79.00, 77.00, 81.00, NULL, NULL, NULL, NULL),
(18, 'IK2411053', 'MK_ADSI', 72.00, 70.00, 73.00, NULL, NULL, NULL, NULL),
(19, 'IK2411009', 'MK_ADSI', 63.00, 65.00, 62.00, NULL, NULL, NULL, NULL),
(20, 'IK2411027', 'MK_ADSI', 50.00, 52.00, 48.00, NULL, NULL, NULL, NULL);

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

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD CONSTRAINT `fk_mk_dosen` FOREIGN KEY (`kode_dosen`) REFERENCES `dosen` (`kode_dosen`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `nilai_praktikum`
--
ALTER TABLE `nilai_praktikum`
  ADD CONSTRAINT `fk_nilai_grade` FOREIGN KEY (`grade`) REFERENCES `grade_nilai` (`grade`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_nilai_mhs` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`nim`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_nilai_mk` FOREIGN KEY (`kode_mk`) REFERENCES `mata_kuliah` (`kode_mk`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
