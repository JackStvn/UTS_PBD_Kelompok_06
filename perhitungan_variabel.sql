-- 1. Mendeklarasikan variabel lokal di dalam blok BEGIN ... END
DECLARE v_tugas DECIMAL(5,2);
DECLARE v_kuis  DECIMAL(5,2);
DECLARE v_uts   DECIMAL(5,2);
DECLARE v_akhir DECIMAL(5,2); -- Variabel penampung hasil akhir

-- 2. Mengambil data nilai mentah dari cursor/tabel dimasukkan ke dalam variabel
-- (Proses ini terjadi di dalam perulangan LOOP Stored Procedure Anda)
FETCH cur_rekap INTO v_id, v_nim, v_kode_mk, v_tugas, v_kuis, v_uts;

-- 3. Melakukan perhitungan nilai akhir menggunakan rumus variabel (Inti Tugas)
-- Bobot: Tugas 30% (0.30), Kuis 30% (0.30), dan UTS 40% (0.40)
SET v_akhir = (v_tugas * 0.30) + (v_kuis * 0.30) + (v_uts * 0.40);

-- 4. Menyimpan data yang sudah matang di variabel v_akhir ke kolom fisik tabel
UPDATE nilai_praktikum 
SET nilai_akhir = v_akhir 
WHERE id_nilai = v_id;