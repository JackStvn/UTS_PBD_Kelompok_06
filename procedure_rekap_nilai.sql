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
