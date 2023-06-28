-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 28, 2023 at 07:51 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uas_pemKomputer`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `masuk_buku` (`b_nama` VARCHAR(50), `b_jenis` VARCHAR(10), `b_penerbit` VARCHAR(20))   BEGIN
INSERT INTO buku
(nama_buku, jenis, penerbit) 
VALUES(b_nama, b_jenis, b_penerbit);
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `uid_buku` (`tglmasuk_buku` DATE, `jenis_buku` VARCHAR(8)) RETURNS VARCHAR(10) CHARSET latin1 COLLATE latin1_swedish_ci  BEGIN
DECLARE tahun CHAR(2);
DECLARE bulan CHAR(2);
DECLARE kodeJ CHAR(2);
DECLARE urut CHAR(4);
DECLARE v_id_buku CHAR(10);
SELECT RIGHT(YEAR(tglmasuk_buku), 2) INTO tahun;
SELECT RIGHT (MONTH(tglmasuk_buku)+100, 2) INTO bulan;
SELECT RIGHT (COUNT(*)+10001, 3) INTO urut FROM buku WHERE LEFT(tanggal_masuk, 7) = LEFT(tglmasuk_buku, 7) AND jenis = jenis_buku;
CASE 
WHEN jenis_buku = 'Fiksi' THEN SET kodeJ = '0F';
WHEN jenis_buku = 'NonFiksi' THEN SET kodeJ = 'NF';
ELSE SET kodeJ = 'UN';
END CASE; 
SELECT CONCAT('B', tahun, bulan, kodeJ, urut) INTO v_id_buku;
RETURN v_id_buku;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `uid_logaktivitas` (`tabelnya` VARCHAR(12), `aksinya` VARCHAR(6)) RETURNS VARCHAR(10) CHARSET latin1 COLLATE latin1_swedish_ci  BEGIN
DECLARE urut CHAR(6);
DECLARE kode CHAR(1);
DECLARE uniq CHAR(3);
DECLARE v_idlog CHAR(10);
CASE 
WHEN aksinya = 'Insert' THEN SET uniq = 'INS';
WHEN aksinya = 'Update' THEN SET uniq = 'UPD';
WHEN aksinya = 'Delete' THEN SET uniq = 'DEL';
ELSE SET uniq = 'ERR';
END CASE;
SELECT LEFT(tabelnya, 1) INTO kode;
SELECT RIGHT(COUNT(*)+10000001, 6) INTO urut FROM log_aktivitas WHERE aksi = aksinya AND tabel = tabelnya;
SELECT CONCAT(uniq, kode, urut) INTO v_idlog;
RETURN v_idlog;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `uid_peminjaman` (`uid_pmahasiswa` VARCHAR(10)) RETURNS VARCHAR(10) CHARSET latin1 COLLATE latin1_swedish_ci  BEGIN
DECLARE nimMHS CHAR(7);
DECLARE urut CHAR(2);
DECLARE v_idPinjam CHAR(10);
SELECT RIGHT(uid_pmahasiswa, 7) INTO nimMHS;
SELECT RIGHT(COUNT(*)+1001, 2) INTO urut FROM peminjaman WHERE mahasiswa_id_nim = uid_pmahasiswa;
SELECT CONCAT('P',nimMHS,urut) INTO v_idPinjam;
RETURN v_idPinjam;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` char(10) NOT NULL,
  `tanggal_masuk` date DEFAULT current_timestamp(),
  `nama_buku` varchar(50) NOT NULL,
  `jenis` varchar(10) NOT NULL,
  `penerbit` varchar(30) NOT NULL,
  `tanggal_edit` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `tanggal_masuk`, `nama_buku`, `jenis`, `penerbit`, `tanggal_edit`) VALUES
('B20020F001', '2020-02-01', 'promise', 'Fiksi', 'loveable', '2023-01-18'),
('B20020F002', '2020-02-02', 'rumah kacaku', 'Fiksi', 'lentera dipantera', '2023-01-18'),
('B20020F003', '2020-02-04', 'laskar pelangi', 'Fiksi', 'bentang pustaka ', '2021-02-03'),
('B20020F004', '2020-02-06', '5 cm', 'Fiksi', 'pt.grasindo', '2021-02-04'),
('B20020F005', '2020-02-07', 'memahami film', 'Fiksi', 'homerian pustaka', '2021-02-05'),
('B20020F006', '2020-02-08', 'sangkuriang', 'Fiksi', 'cv.pustaka ceria ', '2021-02-06'),
('B20020F007', '2020-02-09', 'milea, suara dilan', 'Fiksi', 'pastel books', '2021-02-07'),
('B20020F008', '2020-02-10', 'Ibu', 'Fiksi', 'bentang pustaka ', '2023-01-19'),
('B20050F001', '2020-05-01', 'rindu', 'Fiksi', 'republika', '2021-02-09'),
('B20050F002', '2020-05-02', 'london Kristend', 'Fiksi', 'pt.gramedia', '2021-02-10'),
('B20050F003', '2020-05-03', 'surat kecil untuk tuhan', 'Fiksi', 'inandra published', '2021-02-11'),
('B20050F004', '2020-05-04', 'sang pemimpi', 'Fiksi', 'bentang pustaka ', '2023-01-19'),
('B20050F005', '2020-05-05', 'negeri 5 menara', 'Fiksi', 'pt.gramedia', '2021-02-13'),
('B20050F006', '2020-05-06', 'funiculi funicula', 'Fiksi', 'pt.gramedia', '2021-02-14'),
('B20050F007', '2020-05-07', 'manusia urban', 'Fiksi', 'pt.gramedia', '2021-02-15'),
('B20050F009', '2020-05-09', 'pasta kacang merah', 'Fiksi', 'pt.gramedia', '2021-02-17'),
('B20050F010', '2020-05-10', 'jakarta sebelum pagi', 'Fiksi', 'pt.grameidia', '2021-02-18'),
('B2005NF001', '2020-05-08', 'logika dan himpunan', 'NonFiksi', 'hanggar kreator', '2021-02-19'),
('B2005NF002', '2020-05-09', 'super genius olimpiade matematika', 'NonFiksi', 'pustaka widyatama', '2021-02-20'),
('B2005NF003', '2020-05-10', 'filsafat pendidikan islam', 'NonFiksi', 'cv pustaka setia bandung', '2021-02-21'),
('B2005NF004', '2020-05-11', 'anatomi dan fisiologi', 'NonFiksi', 'gosyen publishing', '2021-02-22'),
('B2005NF005', '2020-05-12', 'algoritma dan pemrograman dengan c++', 'NonFiksi', 'graha ilmu', '2021-02-23'),
('B2005NF006', '2020-05-13', 'mohammad hatta', 'NonFiksi', 'pt.gramedia', '2021-02-24'),
('B2005NF007', '2020-05-14', 'soekarno', 'NonFiksi', 'pt.gramedia', '2021-02-25'),
('B2005NF008', '2020-05-15', 'gus dur', 'NonFiksi', 'pt.gramedia', '2021-02-26'),
('B2005NF009', '2020-05-16', 'becoming', 'NonFiksi', 'pt.gramedia', '2021-02-27'),
('B2005NF010', '2020-05-17', 'rudy:kisah muda sang visioner', 'NonFiksi', 'pt.gramedia', '2021-02-28'),
('B2005NF011', '2020-05-18', 'mahatma gandhi', 'NonFiksi', 'pt.gramedia', '2021-03-01'),
('B2005NF012', '2020-05-19', 'tan malaka', 'NonFiksi', 'pt.gramedia', '2021-03-02'),
('B2005NF013', '2020-05-20', 'untuk negeriku', 'NonFiksi', 'pt.gramedia', '2021-03-03'),
('B2005NF014', '2020-05-21', 'agatha christie', 'NonFiksi', 'pt.gramedia', '2021-03-04'),
('B2005NF015', '2020-05-22', 'inspirasi & motivasi b.j.habibie', 'NonFiksi', 'pt.gramedia', '2021-03-05'),
('B20090F001', '2020-09-02', 'satria november', 'Fiksi', 'pt.gramedia', '2021-03-06'),
('B20090F002', '2020-09-03', 'rangking 1', 'Fiksi', 'pt.gramedia', '2021-03-07'),
('B20090F003', '2020-09-04', 'different', 'Fiksi', 'pt.gramedia', '2021-03-08'),
('B20090F004', '2020-09-05', 'delicious lips', 'Fiksi', 'pt.gramedia', '2021-03-09'),
('B20090F005', '2020-09-06', 'turning page', 'Fiksi', 'pt.gramedia', '2021-03-10'),
('B20090F006', '2020-09-07', 'keajaiban toko kelontong', 'Fiksi', 'pt.gramedia', '2021-03-11'),
('B20090F007', '2020-09-08', 'must be a happy ending', 'Fiksi', 'pt.gramedia', '2021-03-12'),
('B20090F008', '2020-09-10', 'saat saat  jauh', 'Fiksi', 'pt.gramedia', '2021-03-13'),
('B20090F009', '2020-09-11', 'paint', 'Fiksi', 'pt.gramedia', '2021-03-14'),
('B20090F010', '2020-09-12', 'almost 10 years ago', 'Fiksi', 'pt.gramedia', '2021-03-15'),
('B20090F011', '2020-09-13', 'kita pergi hari ini', 'Fiksi', 'pt.gramedia', '2021-03-16'),
('B20090F012', '2020-09-14', 'perpustakaan tengah malam ', 'Fiksi', 'pt.gramedia', '2021-03-17'),
('B20090F013', '2020-09-15', 'dikta & hukum', 'Fiksi', 'pt.gramedia', '2021-03-18'),
('B20090F014', '2020-09-16', 'janji', 'Fiksi', 'pt.gramedia', '2021-03-19'),
('B20090F015', '2020-09-17', 'ikhlas paling serius ', 'Fiksi', 'pt.gramedia', '2021-03-20'),
('B20090F016', '2020-09-18', 'hilmi milan ', 'Fiksi', 'pt.gramedia', '2021-03-21'),
('B20090F017', '2020-09-19', 'septihan', 'Fiksi', 'pt.gramedia', '2021-03-22'),
('B20090F018', '2020-09-20', 'ancika', 'Fiksi', 'pt.gramedia', '2021-03-23'),
('B20090F019', '2020-09-21', 'tengah hari di yenisehir', 'Fiksi', 'pt.gramedia', '2021-03-24'),
('B20090F020', '2020-09-22', 'si anak Cerdas', 'Fiksi', 'pt.gramedia', '2023-01-19'),
('B21040F001', '2021-04-09', 'senja dan pagi', 'Fiksi', 'pt.gramedia', '2022-03-26'),
('B21040F002', '2021-04-10', 'hujan', 'Fiksi', 'pt.gramedia', '2022-03-27'),
('B21040F003', '2021-04-11', 'jingga dan senja', 'Fiksi', 'pt.gramedia', '2022-03-28'),
('B21040F004', '2021-04-12', 'segi tiga ', 'Fiksi', 'pt.gramedia', '2022-03-29'),
('B21040F005', '2021-04-13', 'haru no sora', 'Fiksi', 'pt.gramedia', '2022-03-30'),
('B21040F006', '2021-04-14', 'infinitely yours', 'Fiksi', 'pt.gramedia', '2022-03-31'),
('B21040F007', '2021-04-15', 'one little thing called hope', 'Fiksi', 'pt.gramedia', '2022-04-01'),
('B21040F008', '2021-04-16', 'bowl of happiness', 'Fiksi', 'pt.gramedia', '2022-04-02'),
('B21040F009', '2021-04-17', 'good night stories for rebel girls', 'Fiksi', 'pt.gramedia', '2022-04-03'),
('B21040F010', '2021-04-18', 'kata', 'Fiksi', 'pt.gramedia', '2022-04-04'),
('B21040F011', '2021-04-19', 'sunshine becomes you', 'Fiksi', 'pt.gramedia', '2022-04-05'),
('B21040F012', '2021-04-20', 'milea', 'Fiksi', 'pt.gramedia', '2022-04-06'),
('B23010F001', '2023-01-13', 'Jajaran', 'Fiksi', 'Pustaka Media', '2023-01-18'),
('B23010F002', '2023-01-15', 'Bumi Kita', 'Fiksi', 'Gramedia', '2023-01-18'),
('B23010F003', '2023-01-15', 'Pedoman', 'Fiksi', 'hiudpku', '2023-01-18'),
('B23010F004', '2023-01-15', 'Happy Ending', 'Fiksi', 'Mang', '2023-01-18'),
('B23010F007', '2023-01-18', 'Pejuang', 'Fiksi', 'pejuangID', '2023-01-18'),
('B23010F012', '2023-01-19', 'Dilan 1993', 'Fiksi', 'Dilanku', '2023-01-19'),
('B23010F014', '2023-01-19', 'Dilan 1992', 'Fiksi', 'ser', '2023-01-19'),
('B23010F015', '2023-01-19', 'Jingga', 'Fiksi', 'Junggul Utama', '2023-01-19'),
('B2301NF001', '2023-01-15', 'padaku', 'NonFiksi', 'padamu', '2023-01-18'),
('B2301NF002', '2023-01-08', 'logika dan himpunan', 'NonFiksi', 'hanggar kreator', '2023-01-18'),
('B2301NF003', '2023-01-08', 'super genius olimpiade matematika', 'NonFiksi', 'pustaka widyatama', '2023-01-18'),
('B2301NF004', '2023-01-08', 'filsafat pendidikan islam', 'NonFiksi', 'cv pustaka', '2023-01-18'),
('B2301NF005', '2023-01-08', 'anatomi dan fisiologi', 'NonFiksi', 'gosyen publishing', '2023-01-18'),
('B2301NF006', '2023-01-08', 'algoritma dan pemrograman dengan c++', 'NonFiksi', 'graha ilmu', '2023-01-18'),
('B2301NF007', '2023-01-08', 'mohammad hatta', 'NonFiksi', 'pt.gramedia', '2023-01-18'),
('B2301NF008', '2023-01-08', 'soekarno', 'NonFiksi', 'pt.gramedia', '2023-01-18'),
('B2301NF009', '2023-01-08', 'gus dur', 'NonFiksi', 'pt.gramedia', '2023-01-18'),
('B2301NF010', '2023-01-08', 'becoming', 'NonFiksi', 'pt.gramedia', '2023-01-18'),
('B2301NF012', '2023-01-19', 'Kimia 1', 'NonFiksi', 'Komindo', '2023-06-29');

--
-- Triggers `buku`
--
DELIMITER $$
CREATE TRIGGER `dekete_buku` AFTER DELETE ON `buku` FOR EACH ROW BEGIN
INSERT INTO log_aktivitas (tabel, aksi, keterangan)
VALUE('Buku', 'Delete',
CONCAT('Telah dilakukan penghapusan data pada buku : ', OLD.nama_buku));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `masuk_id_buku` BEFORE INSERT ON `buku` FOR EACH ROW BEGIN
DECLARE n_id_buku CHAR(10);
SELECT uid_buku(NEW.tanggal_masuk, NEW.jenis) INTO n_id_buku;
SET NEW.id_buku = n_id_buku;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambah_buku` AFTER INSERT ON `buku` FOR EACH ROW BEGIN
INSERT INTO log_aktivitas (tanggal,tabel,aksi,keterangan)
VALUES(NEW.tanggal_masuk, 'Buku', 'Insert',
CONCAT('Masuk buku baru dengan nama :', NEW.nama_buku,' Jenis :', NEW.jenis));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_buku` AFTER UPDATE ON `buku` FOR EACH ROW BEGIN
INSERT INTO log_aktivitas (tabel, aksi, keterangan)
VALUE('Buku', 'Update',
CONCAT('Telah dilakukan pengupdatean data pada buku : ', OLD.nama_buku));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_bukuku` BEFORE UPDATE ON `buku` FOR EACH ROW BEGIN
DECLARE tanggal DATE;
SELECT CURRENT_DATE() INTO tanggal;
SET NEW.tanggal_edit = tanggal;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_peminjaman`
--

CREATE TABLE `detail_peminjaman` (
  `id_detail` char(10) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `buku_id_buku` char(10) NOT NULL,
  `peminjaman_id_peminjaman` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_peminjaman`
--

INSERT INTO `detail_peminjaman` (`id_detail`, `jumlah`, `buku_id_buku`, `peminjaman_id_peminjaman`) VALUES
('D200100101', 1, 'B20020F001', 'P200100101'),
('D200100102', 1, 'B20020F002', 'P200100102'),
('D200100201', 1, 'B20020F003', 'P200100201'),
('D200100301', 1, 'B20020F004', 'P200100301'),
('D200100501', 1, 'B20020F006', 'P200100501'),
('D200100601', 1, 'B20020F007', 'P200100601'),
('D200100701', 1, 'B20020F008', 'P200100701'),
('D200100702', 1, 'B20020F009', 'P200100702'),
('D200100801', 1, 'B20020F010', 'P200100801'),
('D200100901', 1, 'B20050F001', 'P200100901'),
('D200100902', 1, 'B20050F002', 'P200100902'),
('D200101001', 1, 'B20050F003', 'P200101001'),
('D200101101', 1, 'B20050F004', 'P200101101'),
('D200101201', 1, 'B20050F005', 'P200101201'),
('D200101301', 1, 'B20050F006', 'P200101301'),
('D200101401', 1, 'B20050F007', 'P200101401'),
('D200101601', 1, 'B20050F009', 'P200101601'),
('D200101701', 1, 'B20050F010', 'P200101701'),
('D200102001', 1, 'B2005NF003', 'P200102001'),
('D200102101', 1, 'B2005NF004', 'P200102101'),
('D200102401', 1, 'B2005NF005', 'P200102401'),
('D200300101', 1, 'B2005NF006', 'P200300101'),
('D200300102', 1, 'B2005NF007', 'P200300102'),
('D200300201', 1, 'B2005NF008', 'P200300201'),
('D200300301', 1, 'B2005NF009', 'P200300301'),
('D200300401', 1, 'B2005NF010', 'P200300401'),
('D200300501', 1, 'B2005NF011', 'P200300501'),
('D200300601', 1, 'B2005NF012', 'P200300601'),
('D200300701', 1, 'B2005NF013', 'P200300701'),
('D200300801', 1, 'B2005NF014', 'P200300801'),
('D200300901', 1, 'B2005NF015', 'P200300901'),
('D200301001', 1, 'B20090F001', 'P200301001'),
('D200301101', 1, 'B20090F002', 'P200301101'),
('D200301201', 1, 'B20090F003', 'P200301201'),
('D200301301', 1, 'B20090F004', 'P200301301'),
('D200301401', 1, 'B20090F005', 'P200301401'),
('D200301501', 1, 'B20090F006', 'P200301501'),
('D200301601', 1, 'B20090F007', 'P200301601'),
('D200301801', 1, 'B20090F009', 'P200301801'),
('D200301901', 1, 'B20090F010', 'P200301901'),
('D200302001', 1, 'B20090F011', 'P200302001'),
('D200302101', 1, 'B20090F012', 'P200302101'),
('D200302201', 1, 'B20090F013', 'P200302201'),
('D200302301', 1, 'B20090F014', 'P200302301'),
('D200302401', 1, 'B20090F015', 'P200302401'),
('D200302501', 1, 'B20090F016', 'P200302501'),
('D200302601', 1, 'B20090F017', 'P200302601'),
('D200302701', 1, 'B20090F018', 'P200302701'),
('D200400101', 1, 'B20090F019', 'P200400101'),
('D200400201', 1, 'B20090F020', 'P200400201'),
('D200400301', 1, 'B20090F021', 'P200400301'),
('D200400401', 1, 'B21040F001', 'P200400401'),
('D200400501', 1, 'B21040F002', 'P200400501'),
('D200400601', 1, 'B21040F003', 'P200400601'),
('D200400701', 1, 'B21040F004', 'P200400701'),
('D200400801', 1, 'B21040F005', 'P200400801'),
('D200400901', 1, 'B21040F006', 'P200400901'),
('D200401001', 1, 'B21040F007', 'P200401001'),
('D200401101', 1, 'B21040F008', 'P200401101'),
('D200401201', 1, 'B21040F009', 'P200401201'),
('D200401301', 1, 'B21040F010', 'P200401301'),
('D200401401', 1, 'B21040F011', 'P200401401'),
('D200401501', 1, 'B21040F012', 'P200401501'),
('D200401601', 1, 'B2301NF001', 'P200401601'),
('D200401701', 1, 'B2301NF002', 'P200401701'),
('D200401801', 1, 'B2301NF003', 'P200401801'),
('D200401901', 1, 'B2301NF004', 'P200401901'),
('D200402001', 1, 'B2301NF005', 'P200402001'),
('D200402101', 1, 'B2301NF006', 'P200402101'),
('D200402201', 1, 'B2301NF007', 'P200402201'),
('D200402301', 1, 'B2301NF008', 'P200402301'),
('D200402401', 1, 'B2301NF009', 'P200402401'),
('D200402601', 1, 'B21040F005', 'P200402601'),
('D200402701', 1, 'B21040F006', 'P200402701'),
('D200402801', 1, 'B21040F007', 'P200402801'),
('D200500101', 1, 'B21040F008', 'P200500101'),
('D200500201', 1, 'B21040F009', 'P200500201'),
('D200500301', 1, 'B21040F010', 'P200500301'),
('D200500401', 1, 'B21040F011', 'P200500401'),
('D200500501', 1, 'B21040F012', 'P200500501'),
('D200500601', 1, 'B2301NF001', 'P200500601'),
('D200500701', 1, 'B2301NF002', 'P200500701'),
('D200500801', 1, 'B2301NF003', 'P200500801'),
('D200500901', 1, 'B2301NF004', 'P200500901'),
('D200501001', 1, 'B2301NF005', 'P200501001'),
('D200501101', 1, 'B2301NF006', 'P200501101'),
('D200501201', 1, 'B2301NF007', 'P200501201'),
('D200501301', 1, 'B2301NF008', 'P200501301'),
('D200501401', 1, 'B2301NF009', 'P200501401'),
('D200501601', 1, 'B21040F005', 'P200501601'),
('D200501701', 1, 'B21040F006', 'P200501701'),
('D200501801', 1, 'B21040F007', 'P200501801'),
('D200501901', 1, 'B21040F008', 'P200501901'),
('D200502001', 1, 'B21040F009', 'P200502001'),
('D200502101', 1, 'B21040F010', 'P200502101'),
('D200502201', 1, 'B21040F011', 'P200502201'),
('D200502301', 1, 'B21040F012', 'P200502301'),
('D200502401', 1, 'B2301NF001', 'P200502401'),
('D200502501', 1, 'B2301NF002', 'P200502501'),
('D200502601', 1, 'B2301NF003', 'P200502601'),
('D200502701', 1, 'B2301NF004', 'P200502701'),
('D200502801', 1, 'B2301NF005', 'P200502801'),
('D200700101', 1, 'B2301NF006', 'P200700101'),
('D200700201', 1, 'B2301NF007', 'P200700201'),
('D200700301', 1, 'B2301NF008', 'P200700301'),
('D200700401', 1, 'B2301NF009', 'P200700401'),
('D200700601', 1, 'B21040F005', 'P200700601'),
('D200700701', 1, 'B21040F006', 'P200700701'),
('D200700801', 1, 'B21040F007', 'P200700801'),
('D200700901', 1, 'B21040F008', 'P200700901'),
('D200701001', 1, 'B21040F009', 'P200701001'),
('D200701101', 1, 'B21040F010', 'P200701101'),
('D200701201', 1, 'B21040F011', 'P200701201'),
('D200701301', 1, 'B21040F012', 'P200701301'),
('D200701401', 1, 'B2301NF001', 'P200701401'),
('D200701501', 1, 'B2301NF002', 'P200701501'),
('D200701601', 1, 'B2301NF003', 'P200701601'),
('D200701701', 1, 'B2301NF004', 'P200701701'),
('D200701801', 1, 'B2301NF005', 'P200701801'),
('D200701901', 1, 'B2301NF006', 'P200701901'),
('D200702001', 1, 'B2301NF007', 'P200702001');

--
-- Triggers `detail_peminjaman`
--
DELIMITER $$
CREATE TRIGGER `detPeminjamanQ` BEFORE INSERT ON `detail_peminjaman` FOR EACH ROW BEGIN
DECLARE nimM CHAR(9);
DECLARE v_idDetPinjam CHAR(10);
SELECT RIGHT(NEW.peminjaman_id_peminjaman, 9) INTO nimM;
SELECT CONCAT('D',nimM) INTO v_idDetPinjam;
SET NEW.id_detail = v_idDetPinjam;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `log_aktivitas`
--

CREATE TABLE `log_aktivitas` (
  `nomor` char(10) NOT NULL,
  `tanggal` date DEFAULT current_timestamp(),
  `tabel` varchar(20) DEFAULT NULL,
  `aksi` varchar(10) DEFAULT NULL,
  `keterangan` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `log_aktivitas`
--

INSERT INTO `log_aktivitas` (`nomor`, `tanggal`, `tabel`, `aksi`, `keterangan`) VALUES
('DELB000001', '2023-01-18', 'Buku', 'Delete', 'Telah dilakukan penghapusan data pada buku : kekasih musim gugur'),
('DELB000002', '2023-01-19', 'Buku', 'Delete', 'Telah dilakukan penghapusan data pada buku : Dilan 1991'),
('DELB000003', '2023-01-19', 'Buku', 'Delete', 'Telah dilakukan penghapusan data pada buku : Dilan'),
('DELB000004', '2023-01-19', 'Buku', 'Delete', 'Telah dilakukan penghapusan data pada buku : Mencari Cinta Sejati'),
('DELB000005', '2023-01-19', 'Buku', 'Delete', 'Telah dilakukan penghapusan data pada buku : Fisika'),
('DELB000006', '2023-06-29', 'Buku', 'Delete', 'Telah dilakukan penghapusan data pada buku : serve'),
('DELB000007', '2023-06-29', 'Buku', 'Delete', 'Telah dilakukan penghapusan data pada buku : Fisika 1'),
('INSB000001', '2020-02-01', 'Buku', 'Insert', 'Masuk buku baru dengan nama :promise Jenis :Fiksi'),
('INSB000002', '2020-02-02', 'Buku', 'Insert', 'Masuk buku baru dengan nama :rumah kaca Jenis :Fiksi'),
('INSB000003', '2020-02-03', 'Buku', 'Insert', 'Masuk buku baru dengan nama :koala kumal Jenis :Fiksi'),
('INSB000004', '2020-02-04', 'Buku', 'Insert', 'Masuk buku baru dengan nama :laskar pelangi Jenis :Fiksi'),
('INSB000005', '2020-02-05', 'Buku', 'Insert', 'Masuk buku baru dengan nama :tentang kamu Jenis :Fiksi'),
('INSB000006', '2020-02-06', 'Buku', 'Insert', 'Masuk buku baru dengan nama :5 cm Jenis :Fiksi'),
('INSB000007', '2020-02-07', 'Buku', 'Insert', 'Masuk buku baru dengan nama :memahami film Jenis :Fiksi'),
('INSB000008', '2020-02-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :sangkuriang Jenis :Fiksi'),
('INSB000009', '2020-02-09', 'Buku', 'Insert', 'Masuk buku baru dengan nama :milea, suara dilan Jenis :Fiksi'),
('INSB000010', '2020-02-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :ayah dan Ibu Jenis :Fiksi'),
('INSB000011', '2020-05-01', 'Buku', 'Insert', 'Masuk buku baru dengan nama :rindu Jenis :Fiksi'),
('INSB000012', '2020-05-02', 'Buku', 'Insert', 'Masuk buku baru dengan nama :london Kristen Jenis :Fiksi'),
('INSB000013', '2020-05-03', 'Buku', 'Insert', 'Masuk buku baru dengan nama :surat kecil untuk tuhan Jenis :Fiksi'),
('INSB000014', '2020-05-04', 'Buku', 'Insert', 'Masuk buku baru dengan nama :sanh pemimpi Jenis :Fiksi'),
('INSB000015', '2020-05-05', 'Buku', 'Insert', 'Masuk buku baru dengan nama :negeri 5 menara Jenis :Fiksi'),
('INSB000016', '2020-05-06', 'Buku', 'Insert', 'Masuk buku baru dengan nama :funiculi funicula Jenis :Fiksi'),
('INSB000017', '2020-05-07', 'Buku', 'Insert', 'Masuk buku baru dengan nama :manusia urban Jenis :Fiksi'),
('INSB000018', '2020-05-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :kekasih musim gugur Jenis :Fiksi'),
('INSB000019', '2020-05-09', 'Buku', 'Insert', 'Masuk buku baru dengan nama :pasta kacang merah Jenis :Fiksi'),
('INSB000020', '2020-05-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :jakarta sebelum pagi Jenis :Fiksi'),
('INSB000021', '2020-05-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :logika dan himpunan Jenis :NonFiksi'),
('INSB000022', '2020-05-09', 'Buku', 'Insert', 'Masuk buku baru dengan nama :super genius olimpiade matematika Jenis :NonFiksi'),
('INSB000023', '2020-05-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :filsafat pendidikan islam Jenis :NonFiksi'),
('INSB000024', '2020-05-11', 'Buku', 'Insert', 'Masuk buku baru dengan nama :anatomi dan fisiologi Jenis :NonFiksi'),
('INSB000025', '2020-05-12', 'Buku', 'Insert', 'Masuk buku baru dengan nama :algoritma dan pemrograman dengan c++ Jenis :NonFiksi'),
('INSB000026', '2020-05-13', 'Buku', 'Insert', 'Masuk buku baru dengan nama :mohammad hatta Jenis :NonFiksi'),
('INSB000027', '2020-05-14', 'Buku', 'Insert', 'Masuk buku baru dengan nama :soekarno Jenis :NonFiksi'),
('INSB000028', '2020-05-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :gus dur Jenis :NonFiksi'),
('INSB000029', '2020-05-16', 'Buku', 'Insert', 'Masuk buku baru dengan nama :becoming Jenis :NonFiksi'),
('INSB000030', '2020-05-17', 'Buku', 'Insert', 'Masuk buku baru dengan nama :rudy:kisah muda sang visioner Jenis :NonFiksi'),
('INSB000031', '2020-05-18', 'Buku', 'Insert', 'Masuk buku baru dengan nama :mahatma gandhi Jenis :NonFiksi'),
('INSB000032', '2020-05-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :tan malaka Jenis :NonFiksi'),
('INSB000033', '2020-05-20', 'Buku', 'Insert', 'Masuk buku baru dengan nama :untuk negeriku Jenis :NonFiksi'),
('INSB000034', '2020-05-21', 'Buku', 'Insert', 'Masuk buku baru dengan nama :agatha christie Jenis :NonFiksi'),
('INSB000035', '2020-05-22', 'Buku', 'Insert', 'Masuk buku baru dengan nama :inspirasi & motivasi b.j.habibie Jenis :NonFiksi'),
('INSB000036', '2020-09-02', 'Buku', 'Insert', 'Masuk buku baru dengan nama :satria november Jenis :Fiksi'),
('INSB000037', '2020-09-03', 'Buku', 'Insert', 'Masuk buku baru dengan nama :rangking 1 Jenis :Fiksi'),
('INSB000038', '2020-09-04', 'Buku', 'Insert', 'Masuk buku baru dengan nama :different Jenis :Fiksi'),
('INSB000039', '2020-09-05', 'Buku', 'Insert', 'Masuk buku baru dengan nama :delicious lips Jenis :Fiksi'),
('INSB000040', '2020-09-06', 'Buku', 'Insert', 'Masuk buku baru dengan nama :turning page Jenis :Fiksi'),
('INSB000041', '2020-09-07', 'Buku', 'Insert', 'Masuk buku baru dengan nama :keajaiban toko kelontong Jenis :Fiksi'),
('INSB000042', '2020-09-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :must be a happy ending Jenis :Fiksi'),
('INSB000043', '2020-09-09', 'Buku', 'Insert', 'Masuk buku baru dengan nama :the architecture of love Jenis :Fiksi'),
('INSB000044', '2020-09-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :saat saat  jauh Jenis :Fiksi'),
('INSB000045', '2020-09-11', 'Buku', 'Insert', 'Masuk buku baru dengan nama :paint Jenis :Fiksi'),
('INSB000046', '2020-09-12', 'Buku', 'Insert', 'Masuk buku baru dengan nama :almost 10 years ago Jenis :Fiksi'),
('INSB000047', '2020-09-13', 'Buku', 'Insert', 'Masuk buku baru dengan nama :kita pergi hari ini Jenis :Fiksi'),
('INSB000048', '2020-09-14', 'Buku', 'Insert', 'Masuk buku baru dengan nama :perpustakaan tengah malam  Jenis :Fiksi'),
('INSB000049', '2020-09-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :dikta & hukum Jenis :Fiksi'),
('INSB000050', '2020-09-16', 'Buku', 'Insert', 'Masuk buku baru dengan nama :janji Jenis :Fiksi'),
('INSB000051', '2020-09-17', 'Buku', 'Insert', 'Masuk buku baru dengan nama :ikhlas paling serius  Jenis :Fiksi'),
('INSB000052', '2020-09-18', 'Buku', 'Insert', 'Masuk buku baru dengan nama :hilmi milan  Jenis :Fiksi'),
('INSB000053', '2020-09-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :septihan Jenis :Fiksi'),
('INSB000054', '2020-09-20', 'Buku', 'Insert', 'Masuk buku baru dengan nama :ancika Jenis :Fiksi'),
('INSB000055', '2020-09-21', 'Buku', 'Insert', 'Masuk buku baru dengan nama :tengah hari di yenisehir Jenis :Fiksi'),
('INSB000056', '2020-09-22', 'Buku', 'Insert', 'Masuk buku baru dengan nama :si anak kuat Jenis :Fiksi'),
('INSB000057', '2021-04-09', 'Buku', 'Insert', 'Masuk buku baru dengan nama :senja dan pagi Jenis :Fiksi'),
('INSB000058', '2021-04-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :hujan Jenis :Fiksi'),
('INSB000059', '2021-04-11', 'Buku', 'Insert', 'Masuk buku baru dengan nama :jingga dan senja Jenis :Fiksi'),
('INSB000060', '2021-04-12', 'Buku', 'Insert', 'Masuk buku baru dengan nama :segi tiga  Jenis :Fiksi'),
('INSB000061', '2021-04-13', 'Buku', 'Insert', 'Masuk buku baru dengan nama :haru no sora Jenis :Fiksi'),
('INSB000062', '2021-04-14', 'Buku', 'Insert', 'Masuk buku baru dengan nama :infinitely yours Jenis :Fiksi'),
('INSB000063', '2021-04-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :one little thing called hope Jenis :Fiksi'),
('INSB000064', '2021-04-16', 'Buku', 'Insert', 'Masuk buku baru dengan nama :bowl of happiness Jenis :Fiksi'),
('INSB000065', '2021-04-17', 'Buku', 'Insert', 'Masuk buku baru dengan nama :good night stories for rebel girls Jenis :Fiksi'),
('INSB000066', '2021-04-18', 'Buku', 'Insert', 'Masuk buku baru dengan nama :kata Jenis :Fiksi'),
('INSB000067', '2021-04-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :sunshine becomes you Jenis :Fiksi'),
('INSB000068', '2021-04-20', 'Buku', 'Insert', 'Masuk buku baru dengan nama :milea Jenis :Fiksi'),
('INSB000069', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :logika dan himpunan Jenis :NonFiksi'),
('INSB000070', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :super genius olimpiade matematika Jenis :NonFiksi'),
('INSB000071', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :filsafat pendidikan islam Jenis :NonFiksi'),
('INSB000072', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :anatomi dan fisiologi Jenis :NonFiksi'),
('INSB000073', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :algoritma dan pemrograman dengan c++ Jenis :NonFiksi'),
('INSB000074', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :mohammad hatta Jenis :NonFiksi'),
('INSB000075', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :soekarno Jenis :NonFiksi'),
('INSB000076', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :gus dur Jenis :NonFiksi'),
('INSB000077', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :becoming Jenis :NonFiksi'),
('INSB000078', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :rudy:kisah muda sang visioner Jenis :NonFiksi'),
('INSB000079', '2023-01-13', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Jajaran Jenis :Fiksi'),
('INSB000080', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Bumi Kita Jenis :Fiksi'),
('INSB000081', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :ww Jenis :Fiksi'),
('INSB000082', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Pedoman Jenis :Fiksi'),
('INSB000083', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Happy Ending Jenis :Fiksi'),
('INSB000084', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Rapuh Jenis :Fiksi'),
('INSB000085', '2020-02-01', 'Buku', 'Insert', 'Masuk buku baru dengan nama :promisest Jenis :Fiksi'),
('INSB000086', '2020-02-02', 'Buku', 'Insert', 'Masuk buku baru dengan nama :rumah kaca Jenis :Fiksi'),
('INSB000087', '2020-02-04', 'Buku', 'Insert', 'Masuk buku baru dengan nama :laskar pelangi Jenis :Fiksi'),
('INSB000088', '2020-02-06', 'Buku', 'Insert', 'Masuk buku baru dengan nama :5 cm Jenis :Fiksi'),
('INSB000089', '2020-02-07', 'Buku', 'Insert', 'Masuk buku baru dengan nama :memahami film Jenis :Fiksi'),
('INSB000090', '2020-02-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :sangkuriang Jenis :Fiksi'),
('INSB000091', '2020-02-09', 'Buku', 'Insert', 'Masuk buku baru dengan nama :milea, suara dilan Jenis :Fiksi'),
('INSB000092', '2020-02-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :ayah dan Ibu Jenis :Fiksi'),
('INSB000093', '2020-05-01', 'Buku', 'Insert', 'Masuk buku baru dengan nama :rindu Jenis :Fiksi'),
('INSB000094', '2020-05-02', 'Buku', 'Insert', 'Masuk buku baru dengan nama :london Kristend Jenis :Fiksi'),
('INSB000095', '2020-05-03', 'Buku', 'Insert', 'Masuk buku baru dengan nama :surat kecil untuk tuhan Jenis :Fiksi'),
('INSB000096', '2020-05-04', 'Buku', 'Insert', 'Masuk buku baru dengan nama :sanh pemimpi Jenis :Fiksi'),
('INSB000097', '2020-05-05', 'Buku', 'Insert', 'Masuk buku baru dengan nama :negeri 5 menara Jenis :Fiksi'),
('INSB000098', '2020-05-06', 'Buku', 'Insert', 'Masuk buku baru dengan nama :funiculi funicula Jenis :Fiksi'),
('INSB000099', '2020-05-07', 'Buku', 'Insert', 'Masuk buku baru dengan nama :manusia urban Jenis :Fiksi'),
('INSB000100', '2020-05-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :kekasih musim gugur Jenis :Fiksi'),
('INSB000101', '2020-05-09', 'Buku', 'Insert', 'Masuk buku baru dengan nama :pasta kacang merah Jenis :Fiksi'),
('INSB000102', '2020-05-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :jakarta sebelum pagi Jenis :Fiksi'),
('INSB000103', '2020-05-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :logika dan himpunan Jenis :NonFiksi'),
('INSB000104', '2020-05-09', 'Buku', 'Insert', 'Masuk buku baru dengan nama :super genius olimpiade matematika Jenis :NonFiksi'),
('INSB000105', '2020-05-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :filsafat pendidikan islam Jenis :NonFiksi'),
('INSB000106', '2020-05-11', 'Buku', 'Insert', 'Masuk buku baru dengan nama :anatomi dan fisiologi Jenis :NonFiksi'),
('INSB000107', '2020-05-12', 'Buku', 'Insert', 'Masuk buku baru dengan nama :algoritma dan pemrograman dengan c++ Jenis :NonFiksi'),
('INSB000108', '2020-05-13', 'Buku', 'Insert', 'Masuk buku baru dengan nama :mohammad hatta Jenis :NonFiksi'),
('INSB000109', '2020-05-14', 'Buku', 'Insert', 'Masuk buku baru dengan nama :soekarno Jenis :NonFiksi'),
('INSB000110', '2020-05-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :gus dur Jenis :NonFiksi'),
('INSB000111', '2020-05-16', 'Buku', 'Insert', 'Masuk buku baru dengan nama :becoming Jenis :NonFiksi'),
('INSB000112', '2020-05-17', 'Buku', 'Insert', 'Masuk buku baru dengan nama :rudy:kisah muda sang visioner Jenis :NonFiksi'),
('INSB000113', '2020-05-18', 'Buku', 'Insert', 'Masuk buku baru dengan nama :mahatma gandhi Jenis :NonFiksi'),
('INSB000114', '2020-05-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :tan malaka Jenis :NonFiksi'),
('INSB000115', '2020-05-20', 'Buku', 'Insert', 'Masuk buku baru dengan nama :untuk negeriku Jenis :NonFiksi'),
('INSB000116', '2020-05-21', 'Buku', 'Insert', 'Masuk buku baru dengan nama :agatha christie Jenis :NonFiksi'),
('INSB000117', '2020-05-22', 'Buku', 'Insert', 'Masuk buku baru dengan nama :inspirasi & motivasi b.j.habibie Jenis :NonFiksi'),
('INSB000118', '2020-09-02', 'Buku', 'Insert', 'Masuk buku baru dengan nama :satria november Jenis :Fiksi'),
('INSB000119', '2020-09-03', 'Buku', 'Insert', 'Masuk buku baru dengan nama :rangking 1 Jenis :Fiksi'),
('INSB000120', '2020-09-04', 'Buku', 'Insert', 'Masuk buku baru dengan nama :different Jenis :Fiksi'),
('INSB000121', '2020-09-05', 'Buku', 'Insert', 'Masuk buku baru dengan nama :delicious lips Jenis :Fiksi'),
('INSB000122', '2020-09-06', 'Buku', 'Insert', 'Masuk buku baru dengan nama :turning page Jenis :Fiksi'),
('INSB000123', '2020-09-07', 'Buku', 'Insert', 'Masuk buku baru dengan nama :keajaiban toko kelontong Jenis :Fiksi'),
('INSB000124', '2020-09-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :must be a happy ending Jenis :Fiksi'),
('INSB000125', '2020-09-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :saat saat  jauh Jenis :Fiksi'),
('INSB000126', '2020-09-11', 'Buku', 'Insert', 'Masuk buku baru dengan nama :paint Jenis :Fiksi'),
('INSB000127', '2020-09-12', 'Buku', 'Insert', 'Masuk buku baru dengan nama :almost 10 years ago Jenis :Fiksi'),
('INSB000128', '2020-09-13', 'Buku', 'Insert', 'Masuk buku baru dengan nama :kita pergi hari ini Jenis :Fiksi'),
('INSB000129', '2020-09-14', 'Buku', 'Insert', 'Masuk buku baru dengan nama :perpustakaan tengah malam  Jenis :Fiksi'),
('INSB000130', '2020-09-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :dikta & hukum Jenis :Fiksi'),
('INSB000131', '2020-09-16', 'Buku', 'Insert', 'Masuk buku baru dengan nama :janji Jenis :Fiksi'),
('INSB000132', '2020-09-17', 'Buku', 'Insert', 'Masuk buku baru dengan nama :ikhlas paling serius  Jenis :Fiksi'),
('INSB000133', '2020-09-18', 'Buku', 'Insert', 'Masuk buku baru dengan nama :hilmi milan  Jenis :Fiksi'),
('INSB000134', '2020-09-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :septihan Jenis :Fiksi'),
('INSB000135', '2020-09-20', 'Buku', 'Insert', 'Masuk buku baru dengan nama :ancika Jenis :Fiksi'),
('INSB000136', '2020-09-21', 'Buku', 'Insert', 'Masuk buku baru dengan nama :tengah hari di yenisehir Jenis :Fiksi'),
('INSB000137', '2020-09-22', 'Buku', 'Insert', 'Masuk buku baru dengan nama :si anak kuat Jenis :Fiksi'),
('INSB000138', '2021-04-09', 'Buku', 'Insert', 'Masuk buku baru dengan nama :senja dan pagi Jenis :Fiksi'),
('INSB000139', '2021-04-10', 'Buku', 'Insert', 'Masuk buku baru dengan nama :hujan Jenis :Fiksi'),
('INSB000140', '2021-04-11', 'Buku', 'Insert', 'Masuk buku baru dengan nama :jingga dan senja Jenis :Fiksi'),
('INSB000141', '2021-04-12', 'Buku', 'Insert', 'Masuk buku baru dengan nama :segi tiga  Jenis :Fiksi'),
('INSB000142', '2021-04-13', 'Buku', 'Insert', 'Masuk buku baru dengan nama :haru no sora Jenis :Fiksi'),
('INSB000143', '2021-04-14', 'Buku', 'Insert', 'Masuk buku baru dengan nama :infinitely yours Jenis :Fiksi'),
('INSB000144', '2021-04-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :one little thing called hope Jenis :Fiksi'),
('INSB000145', '2021-04-16', 'Buku', 'Insert', 'Masuk buku baru dengan nama :bowl of happiness Jenis :Fiksi'),
('INSB000146', '2021-04-17', 'Buku', 'Insert', 'Masuk buku baru dengan nama :good night stories for rebel girls Jenis :Fiksi'),
('INSB000147', '2021-04-18', 'Buku', 'Insert', 'Masuk buku baru dengan nama :kata Jenis :Fiksi'),
('INSB000148', '2021-04-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :sunshine becomes you Jenis :Fiksi'),
('INSB000149', '2021-04-20', 'Buku', 'Insert', 'Masuk buku baru dengan nama :milea Jenis :Fiksi'),
('INSB000150', '2023-01-13', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Jajaran Jenis :Fiksi'),
('INSB000151', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Bumi Kita Jenis :Fiksi'),
('INSB000152', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :padaku Jenis :NonFiksi'),
('INSB000153', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Pedoman Jenis :Fiksi'),
('INSB000154', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Happy Ending Jenis :Fiksi'),
('INSB000155', '2023-01-15', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Rapuh Jenis :Fiksi'),
('INSB000156', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :logika dan himpunan Jenis :NonFiksi'),
('INSB000157', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :super genius olimpiade matematika Jenis :NonFiksi'),
('INSB000158', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :filsafat pendidikan islam Jenis :NonFiksi'),
('INSB000159', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :anatomi dan fisiologi Jenis :NonFiksi'),
('INSB000160', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :algoritma dan pemrograman dengan c++ Jenis :NonFiksi'),
('INSB000161', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :mohammad hatta Jenis :NonFiksi'),
('INSB000162', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :soekarno Jenis :NonFiksi'),
('INSB000163', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :gus dur Jenis :NonFiksi'),
('INSB000164', '2023-01-08', 'Buku', 'Insert', 'Masuk buku baru dengan nama :becoming Jenis :NonFiksi'),
('INSB000165', '2023-01-18', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Mencari Cinta Sejati Jenis :Fiksi'),
('INSB000166', '2023-01-18', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Pejuang Jenis :Fiksi'),
('INSB000167', '2023-01-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :serve Jenis :NonFiksi'),
('INSB000168', '2023-01-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Dilan 1990 Jenis :Fiksi'),
('INSB000169', '2023-01-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Dilan 1991 Jenis :Fiksi'),
('INSB000170', '2023-01-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Dilan 1992 Jenis :Fiksi'),
('INSB000171', '2023-01-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Dilan Jenis :Fiksi'),
('INSB000172', '2023-01-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Jingga Jenis :Fiksi'),
('INSB000173', '2023-01-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Kimia Jenis :NonFiksi'),
('INSB000174', '2023-01-19', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Kimia Jenis :NonFiksi'),
('INSB000175', '2023-06-29', 'Buku', 'Insert', 'Masuk buku baru dengan nama :Fisika 2 Jenis :NonFiksi'),
('INSM000001', '2020-01-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Bonang S'),
('INSM000002', '2020-01-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Meliana'),
('INSM000003', '2020-01-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ilman'),
('INSM000004', '2020-01-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama kuspartono'),
('INSM000005', '2020-01-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MUHAMMAD FARIS FIKR'),
('INSM000006', '2020-01-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Fajri Abdul Ghani'),
('INSM000007', '2020-01-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ali Imron '),
('INSM000008', '2020-01-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TRIYONO NGADIYANTO'),
('INSM000009', '2020-01-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama BEJO'),
('INSM000010', '2020-01-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama M. BIL MAHRUS'),
('INSM000011', '2020-01-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama HAFIDH GIGIH PURWAJI'),
('INSM000012', '2020-01-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RIYAN BAYU SAPUTRA'),
('INSM000013', '2020-01-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Sahuria'),
('INSM000014', '2020-01-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DIKA DZIKRI PRATAMA'),
('INSM000015', '2020-01-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ali Sujito'),
('INSM000016', '2020-01-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama JONATHAN ARDI NUGRAHA'),
('INSM000017', '2020-01-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SRIYADI MUJIONO.M'),
('INSM000018', '2020-01-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama HAERUDIN'),
('INSM000019', '2020-01-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Firman ade candra'),
('INSM000020', '2020-01-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MOHAMAD IDHAM BAHRI'),
('INSM000021', '2020-01-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Muhammad Arya Putra'),
('INSM000022', '2020-01-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Aji Jagat Saputra'),
('INSM000023', '2020-01-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SULAEMAN'),
('INSM000024', '2020-01-31', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DEDDI EKO SANTOSO'),
('INSM000025', '2020-02-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama FARID FAKHRI DARMAWAN'),
('INSM000026', '2020-02-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ANGGIT HARYO WICAKSONO'),
('INSM000027', '2020-02-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Aas Sugiyanto'),
('INSM000028', '2020-02-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Budi Hendra Santosa'),
('INSM000029', '2020-02-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ahmad Daryitno'),
('INSM000030', '2020-02-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NATHANAEL BAGAS SETYAWAN'),
('INSM000031', '2020-02-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Dwiko Mahardika'),
('INSM000032', '2020-02-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Entang Sukrisman'),
('INSM000033', '2020-02-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RUSDI'),
('INSM000034', '2020-02-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama HARIJADI'),
('INSM000035', '2020-02-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ADRIYAN BAGUS KRISNAYANDHI'),
('INSM000036', '2020-02-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama M ROY SAMSUL AKBAR'),
('INSM000037', '2020-02-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Achmad Solihin'),
('INSM000038', '2020-02-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MUHAMMAD NURHUDA'),
('INSM000039', '2020-02-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama AIDA NUR KUSUMA WATI'),
('INSM000040', '2020-02-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Syahrini '),
('INSM000041', '2020-02-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama LULU NADHIATUN ANISA'),
('INSM000042', '2020-02-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ernawati'),
('INSM000043', '2020-02-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama KARTIKA DEVIANI'),
('INSM000044', '2020-02-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SULASTRI'),
('INSM000045', '2020-02-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NIKEN WAHYU SETYOWULAN'),
('INSM000046', '2020-02-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MEILUNA KARISSA PUTRI'),
('INSM000047', '2020-02-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Safira Ali Nur Andini'),
('INSM000048', '2020-02-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama FAUZIAH'),
('INSM000049', '2020-02-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Yeti Herawati'),
('INSM000050', '2020-02-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Warniti'),
('INSM000051', '2020-02-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ni\'mah Athafarisya'),
('INSM000052', '2020-02-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RETNO PURWONINGSIH'),
('INSM000053', '2020-02-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ASIH KHAMIDAH'),
('INSM000054', '2020-03-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama LARAS AYUNINGTYAS'),
('INSM000055', '2020-03-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Putri silvia'),
('INSM000056', '2020-03-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Lia Annisa Fitri'),
('INSM000057', '2020-03-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DIVA FIKRI AYUDIANI'),
('INSM000058', '2020-03-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama QORI\'AH PURWAJI'),
('INSM000059', '2020-03-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MEI SURYANI'),
('INSM000060', '2020-03-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Asihfa Fazwati'),
('INSM000061', '2020-03-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nur Laela '),
('INSM000062', '2020-03-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Echa Triansah Putri'),
('INSM000063', '2020-03-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama HARTINI'),
('INSM000064', '2020-03-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NOMA ARIYANTI'),
('INSM000065', '2020-03-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TA\'INAH'),
('INSM000066', '2020-03-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Yusuf Habibie'),
('INSM000067', '2020-03-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama IMAN NUROFIQ'),
('INSM000068', '2020-03-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Naufal Najmuddin'),
('INSM000069', '2020-03-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Faiz Khasbi Azami'),
('INSM000070', '2020-03-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MOHAMMAD SANDI DAVID'),
('INSM000071', '2020-03-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MOHAMMAD DIVA ATALARIK'),
('INSM000072', '2020-03-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Adib Munajib'),
('INSM000073', '2020-03-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Avriansyah Bahtiar'),
('INSM000074', '2020-03-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ROWI'),
('INSM000075', '2020-03-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NUR SHOLIH SA\'DUL KHOLQI'),
('INSM000076', '2020-03-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama IMAM ASHARI'),
('INSM000077', '2020-03-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Yunus Anis'),
('INSM000078', '2020-03-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SAKRI'),
('INSM000079', '2020-03-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Sudi Mulyanto'),
('INSM000080', '2020-03-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TORIDIN'),
('INSM000081', '2020-03-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SERENO SYA\'BANA'),
('INSM000082', '2020-03-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Abdul Gofur'),
('INSM000083', '2020-03-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama CIPTO HARIYONO'),
('INSM000084', '2020-03-31', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama WARIS'),
('INSM000085', '2020-04-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RAFFI ARJUN NAJWA'),
('INSM000086', '2020-04-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Abdullah'),
('INSM000087', '2020-04-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Somadi'),
('INSM000088', '2020-04-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Abdul Wahid'),
('INSM000089', '2020-04-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama AGIL SAID RAMADON'),
('INSM000090', '2020-04-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama GUNTUR TRI PRASETYO'),
('INSM000091', '2020-04-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama AGUS SUSILO'),
('INSM000092', '2020-04-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama FATTAHILLAH AL HESDA'),
('INSM000093', '2020-04-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Mohamad Khadik'),
('INSM000094', '2020-04-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Arif Hajri'),
('INSM000095', '2020-04-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RIKY RAHARJO'),
('INSM000096', '2020-04-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Azril Araya'),
('INSM000097', '2020-04-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ABDUL HAQ AL\'ASIR'),
('INSM000098', '2020-04-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Askara Putra Alfahri'),
('INSM000099', '2020-04-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RESTU AGUNG SAMUDRA'),
('INSM000100', '2020-04-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Muh. Halim Fauzan Hafizhdin'),
('INSM000101', '2020-04-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama masrukhin'),
('INSM000102', '2020-04-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SAEPTRIMO RIZQI DIONO'),
('INSM000103', '2020-04-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ZETTA ABIGAIL FAWWAS'),
('INSM000104', '2020-04-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Wardi'),
('INSM000105', '2020-04-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RIZKY FARIZH MAULANA'),
('INSM000106', '2020-04-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Annur Riyadhus Solikhin'),
('INSM000107', '2020-04-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama YUSUF AL HESDA'),
('INSM000108', '2020-04-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama AKHMAD  RISKI ARDIANSYAH'),
('INSM000109', '2020-04-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SODIKIN'),
('INSM000110', '2020-04-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ARDEN ARJUNA MULVI'),
('INSM000111', '2020-04-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama AKHMAD FUJI KURNIAWAN'),
('INSM000112', '2020-04-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ely Mutaqofiyah'),
('INSM000113', '2020-04-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama rositah'),
('INSM000114', '2020-04-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Widaningsih'),
('INSM000115', '2020-05-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama AFRINDA RIZQI FARAHDINTA'),
('INSM000116', '2020-05-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MAULIDA NURULISA HIDAYAH'),
('INSM000117', '2020-05-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama AGHNIYAH BUNGA ALHESDA'),
('INSM000118', '2020-05-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Diah yulianti'),
('INSM000119', '2020-05-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nailu muna'),
('INSM000120', '2020-05-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ROPIKOH'),
('INSM000121', '2020-05-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TARWI'),
('INSM000122', '2020-05-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TATI DASKI'),
('INSM000123', '2020-05-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Tia Rifka'),
('INSM000124', '2020-05-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama EVI PRIHANTI'),
('INSM000125', '2020-05-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NURUL HIDAYAH AZZAH HIDAH'),
('INSM000126', '2020-05-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ayla Tiara'),
('INSM000127', '2020-05-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MURYATI'),
('INSM000128', '2020-05-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DARNINGSIH'),
('INSM000129', '2020-05-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nur Azizah'),
('INSM000130', '2020-05-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DUMIYATI'),
('INSM000131', '2020-05-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SYAHARANI SALSABILLA P'),
('INSM000132', '2020-05-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Farah Dwi Anggriyani'),
('INSM000133', '2020-05-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RAKHMADHANI NURUL AINI'),
('INSM000134', '2020-05-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Satirah Kh'),
('INSM000135', '2020-05-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Fifi Rofiatun'),
('INSM000136', '2020-05-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NIKEN PRATIWI KH'),
('INSM000137', '2020-05-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Somar\'ah '),
('INSM000138', '2020-05-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Adinda Bintang Febiola'),
('INSM000139', '2020-05-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama AZKI SOVIANATA'),
('INSM000140', '2020-05-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SHANUM NURUL HILYATUNNISA'),
('INSM000141', '2020-05-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Rizki Eka Mulyani'),
('INSM000142', '2020-05-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NURBAETI'),
('INSM000143', '2020-05-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MUTMAINAH'),
('INSM000144', '2020-05-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama HESTI SEDIA UTAMI'),
('INSM000145', '2020-05-31', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NUR FARISKA'),
('INSM000146', '2020-06-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SAFIRA TRI RAHMADITA'),
('INSM000147', '2020-06-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DHIYA SHILMI AULIA'),
('INSM000148', '2020-06-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DEDE FATMAWATI'),
('INSM000149', '2020-06-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nur Hasanah'),
('INSM000150', '2020-06-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama HASNITA RANI KUMALA'),
('INSM000151', '2020-06-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Putri Ajeng Imamah'),
('INSM000152', '2020-06-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama FIRDA AULIA RAKHMAH'),
('INSM000153', '2020-06-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Rizka Isnata Mufidah'),
('INSM000154', '2020-06-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama IIN DARYANTI'),
('INSM000155', '2020-06-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NURUL INAYAH'),
('INSM000156', '2020-06-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama FIFI ALFIYATUN ROSDIYANAH'),
('INSM000157', '2020-06-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ARFAN AS\'SIDIQ'),
('INSM000158', '2020-06-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Mohamad Faizin'),
('INSM000159', '2020-06-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Dimas Nur Fauzi Antoro'),
('INSM000160', '2020-06-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TARYONO'),
('INSM000161', '2020-06-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Suhadi'),
('INSM000162', '2020-06-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ADAM EZRA HAQQANI'),
('INSM000163', '2020-06-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NURCHOLIS'),
('INSM000164', '2020-06-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Eman Prasojo'),
('INSM000165', '2020-06-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Muhammad Fadil'),
('INSM000166', '2020-06-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Muh Faqih Maulana'),
('INSM000167', '2020-06-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama HARTONO'),
('INSM000168', '2020-06-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Fakhrul Khusaeni'),
('INSM000169', '2020-06-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama BAGAS AZFA HAQQANI'),
('INSM000170', '2020-06-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama BAMBANG SUMARDI'),
('INSM000171', '2020-06-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama IMAM AL FATIH'),
('INSM000172', '2020-06-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NURSODIK'),
('INSM000173', '2020-06-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Muhammad Abdillah Nur Ziddan Sujito'),
('INSM000174', '2020-06-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Imam Santoso'),
('INSM000175', '2020-06-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Tasirin'),
('INSM000176', '2020-07-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Sahroni'),
('INSM000177', '2020-07-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama BUDI SANTOSO'),
('INSM000178', '2020-07-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MOHAMAD REVITO AL FAJRI'),
('INSM000179', '2020-07-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Fairel Atharizz Calief Sujito'),
('INSM000180', '2020-07-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Erlangga Adnan Bimanufi'),
('INSM000181', '2020-07-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NUROCHMAN'),
('INSM000182', '2020-07-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Akhmad zaeni'),
('INSM000183', '2020-07-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Rafael Rinta Primadani'),
('INSM000184', '2020-07-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Damar Ezar Raditya'),
('INSM000185', '2020-07-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Moh.Amirin'),
('INSM000186', '2020-07-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Fadillah surya Irawan'),
('INSM000187', '2020-07-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ZULFAN FAKHRI PURWAJI'),
('INSM000188', '2020-07-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ARIF SAMIAJI'),
('INSM000189', '2020-07-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ADI SUCIPTO'),
('INSM000190', '2020-07-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ramin'),
('INSM000191', '2020-07-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama YUSMANTORO'),
('INSM000192', '2020-07-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Muhammad Afwan Khafidz'),
('INSM000193', '2020-07-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama CASMADI'),
('INSM000194', '2020-07-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SALAFI DWI PRIANTO'),
('INSM000195', '2020-07-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Suharto'),
('INSM000196', '2020-07-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Dimas Bintang Pratama'),
('INSM000197', '2020-07-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama M. HANIF SYAHPUTRA'),
('INSM000198', '2020-07-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ezar Raditya'),
('INSM000199', '2020-07-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Byan Arya wibowo'),
('INSM000200', '2020-07-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RISKY LINTANG SETIAWAN'),
('INSM000201', '2020-07-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama HENDRAWAN DIANA PUTRA'),
('INSM000202', '2020-07-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Kusnadi'),
('INSM000203', '2020-07-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SURIP'),
('INSM000204', '2020-07-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Seko Tri K'),
('INSM000205', '2020-07-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama CASYANTO'),
('INSM000206', '2020-07-31', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama maulana pandu pradana '),
('INSM000207', '2020-08-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama HUSNI AINNUN NABILAL '),
('INSM000208', '2020-08-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Maskholik'),
('INSM000209', '2020-08-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama M SARIF MAULANA'),
('INSM000210', '2020-08-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Rudi Antoro'),
('INSM000211', '2020-08-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ISNEN ROAJI'),
('INSM000212', '2020-08-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Maksudi'),
('INSM000213', '2020-08-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama M GUNTUR WIBISONO'),
('INSM000214', '2020-08-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nurokhim'),
('INSM000215', '2020-08-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NUROCHIM'),
('INSM000216', '2020-08-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Eko Sudi Raharjo'),
('INSM000217', '2020-08-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ZENAL ARIFIN'),
('INSM000218', '2020-08-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ilyas Wahyu Putra Briliantara'),
('INSM000219', '2020-08-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama GADING ILHA SAPUTRA'),
('INSM000220', '2020-08-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Imam Muzaki Ikhsan'),
('INSM000221', '2020-08-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ABDUL ROJAK'),
('INSM000222', '2020-08-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DIMAS WILDAN BASHORUDIN '),
('INSM000223', '2020-08-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NANDA ZULFIKAR'),
('INSM000224', '2020-08-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama BAMBANG PONCOWOLO'),
('INSM000225', '2020-08-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MOH ASIKIN'),
('INSM000226', '2020-08-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama YUSUF DWI SAPUTRA'),
('INSM000227', '2020-08-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ZULFA HIDAYAT MAULANA PRAMITA'),
('INSM000228', '2020-08-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Mubasirin'),
('INSM000229', '2020-08-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Waridi'),
('INSM000230', '2020-08-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MOHAMAD LUKMANUL CHAKIM'),
('INSM000231', '2020-08-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Komari'),
('INSM000232', '2020-08-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama BIMA ARYA FATAH'),
('INSM000233', '2020-08-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Muhamad syarif hidayatullah'),
('INSM000234', '2020-08-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Rifa Aulia Pradana'),
('INSM000235', '2020-08-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Syahrindra'),
('INSM000236', '2020-08-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MABRURIDLO'),
('INSM000237', '2020-08-31', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ibnu Fajar As Syukron'),
('INSM000238', '2020-09-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TEGAR TRI ATMOJO'),
('INSM000239', '2020-09-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Agung Jugo Wachju Satrijo'),
('INSM000240', '2020-09-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Aldi Bhanu Azhar'),
('INSM000241', '2020-09-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Muhammad Irkham Faozan'),
('INSM000242', '2020-09-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Aji Dwi Prawira'),
('INSM000243', '2020-09-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MOHAMMAD FAKRUROJI NURUL IKSAN'),
('INSM000244', '2020-09-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Sugianto'),
('INSM000245', '2020-09-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ABDUL KARIM'),
('INSM000246', '2020-09-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama WILLY ANGGI PRAMULIANTO'),
('INSM000247', '2020-09-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama M ALI NURDIN'),
('INSM000248', '2020-09-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama GAGAH BILAL FIRDAUS'),
('INSM000249', '2020-09-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ADRIAN FAIRUZ R'),
('INSM000250', '2020-09-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Satrio Aldi Firmansyah'),
('INSM000251', '2020-09-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Pahlevi Faisal Adam'),
('INSM000252', '2020-09-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NUR RIZQI MAULANA'),
('INSM000253', '2020-09-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RAMINTA'),
('INSM000254', '2020-09-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DIMAS AJI SAPUTRA'),
('INSM000255', '2020-09-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Harnowo Adhi Nugroho'),
('INSM000256', '2020-09-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nahrul hayat'),
('INSM000257', '2020-09-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama IVANDER JOSH SANTOSO'),
('INSM000258', '2020-09-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ROHADATUL AISYI FATIKHA'),
('INSM000259', '2020-09-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Fadila Rizka'),
('INSM000260', '2020-09-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Farhati'),
('INSM000261', '2020-09-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Rafidatus Salsabilah Qosimah'),
('INSM000262', '2020-09-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ayu Widya Fakhira'),
('INSM000263', '2020-09-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Khilyatul Maizun'),
('INSM000264', '2020-09-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nur Hayati'),
('INSM000265', '2020-09-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Tuslikha'),
('INSM000266', '2020-09-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Chelsea Putri Olivia'),
('INSM000267', '2020-09-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Aurelia Naurah Zafarani'),
('INSM000268', '2020-10-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Rahma Reza Dea Bonita'),
('INSM000269', '2020-10-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DEA SULISTIANA PUTRI'),
('INSM000270', '2020-10-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NUR ALIYAH'),
('INSM000271', '2020-10-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Mualimah'),
('INSM000272', '2020-10-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Komarlinah'),
('INSM000273', '2020-10-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NURUL FEBI ANISA'),
('INSM000274', '2020-10-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nayla Asyita Almahira'),
('INSM000275', '2020-10-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama sri lestari'),
('INSM000276', '2020-10-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Daningsih'),
('INSM000277', '2020-10-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ika Sukmawati'),
('INSM000278', '2020-10-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Yuli Herawati'),
('INSM000279', '2020-10-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama WURYANTI'),
('INSM000280', '2020-10-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SANATI'),
('INSM000281', '2020-10-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Alfiyah'),
('INSM000282', '2020-10-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TIARA PERMATASARI'),
('INSM000283', '2020-10-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Putri Willa Andini'),
('INSM000284', '2020-10-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Dewi Amanda Yuniati'),
('INSM000285', '2020-10-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NADYA SHALSABILLAH'),
('INSM000286', '2020-10-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Olivia Amanda Putri'),
('INSM000287', '2020-10-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nasya Firli Umihani Sujito'),
('INSM000288', '2020-10-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama YESAYA WIDIYA'),
('INSM000289', '2020-10-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Maslicha'),
('INSM000290', '2020-10-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DAVINA RAMADIYANTI LUQYANA'),
('INSM000291', '2020-10-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Sopuroh'),
('INSM000292', '2020-10-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Retno Aditya Sari'),
('INSM000293', '2020-10-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nurul Aisyah'),
('INSM000294', '2020-10-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Jihan Farah Dila'),
('INSM000295', '2020-10-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TITI ASTUTI'),
('INSM000296', '2020-10-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NURIYAH'),
('INSM000297', '2020-10-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Hafizhatul Awaliyah'),
('INSM000298', '2020-10-31', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Waidah'),
('INSM000299', '2020-11-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NABILLA AULY ZAHRA'),
('INSM000300', '2020-11-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Rositah'),
('INSM000301', '2020-11-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Fania Lathifah'),
('INSM000302', '2020-11-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ISRO HANDAYANI'),
('INSM000303', '2020-11-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama KHUSNUL CHASANAH'),
('INSM000304', '2020-11-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Sapariyah'),
('INSM000305', '2020-11-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama CITRA AYU ANANDITA'),
('INSM000306', '2020-11-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DAVINA DWI CAHYANI'),
('INSM000307', '2020-11-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SRI MULYATI'),
('INSM000308', '2020-11-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama GITA PRAMESTI'),
('INSM000309', '2020-11-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nur Tami Ni\'mah');
INSERT INTO `log_aktivitas` (`nomor`, `tanggal`, `tabel`, `aksi`, `keterangan`) VALUES
('INSM000310', '2020-11-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Farda Nur Jihan'),
('INSM000311', '2020-11-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama DINDA ARI THEANEKAWATI'),
('INSM000312', '2020-11-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Linuwih'),
('INSM000313', '2020-11-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Besta Risqya Fiesta'),
('INSM000314', '2020-11-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Wahyuningsih'),
('INSM000315', '2020-11-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Mundiroh'),
('INSM000316', '2020-11-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama KASIYATI'),
('INSM000317', '2020-11-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Siska Aulia Utami'),
('INSM000318', '2020-11-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama BALKIS ARIFATUL FADIA'),
('INSM000319', '2020-11-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Eko Witati Agustina'),
('INSM000320', '2020-11-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Siti Nurasih'),
('INSM000321', '2020-11-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Darti'),
('INSM000322', '2020-11-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TETI SETIOWATI'),
('INSM000323', '2020-11-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ayasya Almira'),
('INSM000324', '2020-11-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ALIFA SIDQIA'),
('INSM000325', '2020-11-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SAKINAH UMI PRAMITA'),
('INSM000326', '2020-11-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama EUNIKE NATHANIA FOSSETA'),
('INSM000327', '2020-11-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Nurhayati'),
('INSM000328', '2020-11-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Suci Ramadhani'),
('INSM000329', '2020-12-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Safira Wahyu Putri Nanda'),
('INSM000330', '2020-12-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ANIS APRIANI'),
('INSM000331', '2020-12-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Endang'),
('INSM000332', '2020-12-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama TANTI DEWI PURWANTI'),
('INSM000333', '2020-12-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ALMAS DHIYAH ZAHIRA'),
('INSM000334', '2020-12-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama NUR AZIZAH'),
('INSM000335', '2020-12-07', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ALFIYAH'),
('INSM000336', '2020-12-08', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SUMARSIH'),
('INSM000337', '2020-12-09', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Erni Setyowati'),
('INSM000338', '2020-12-10', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Sofaeni'),
('INSM000339', '2020-12-11', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama AGNI ANASTASYHA'),
('INSM000340', '2020-12-12', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama ARINA NUR IFADANIYATI'),
('INSM000341', '2020-12-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Tuti Handayani'),
('INSM000342', '2020-12-14', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Fadia Nufinikita'),
('INSM000343', '2020-12-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama YUNI HARTATI'),
('INSM000344', '2020-12-16', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MULYATI'),
('INSM000345', '2020-12-17', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Dewi Purwaningsih'),
('INSM000346', '2020-12-18', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Futykhatul Rizqi'),
('INSM000347', '2020-12-19', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama SRI RAHAYU'),
('INSM000348', '2020-12-20', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RUSTIAWATI'),
('INSM000349', '2020-12-21', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama FITRI NUR FEBRIANI'),
('INSM000350', '2020-12-22', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama WARCHAMAH'),
('INSM000351', '2020-12-23', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama RODIYAH'),
('INSM000352', '2020-12-24', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Yulia Trisnawati'),
('INSM000353', '2020-12-25', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ulfifi Rikhayatiningsih '),
('INSM000354', '2020-12-26', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama OLIFIA MARGARETO SANTOSO'),
('INSM000355', '2020-12-27', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama MURATIN'),
('INSM000356', '2020-12-28', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Khilidin UY'),
('INSM000357', '2020-12-29', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Khilidin R'),
('INSM000358', '2020-12-30', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Khilidin We'),
('INSM000359', '2020-12-31', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Idham Bahri SS'),
('INSM000360', '2021-01-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Idham Bahri SS'),
('INSM000361', '2021-01-02', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Bani'),
('INSM000362', '2021-01-03', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Khilidin Pen'),
('INSM000363', '2021-01-04', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Khilidin Pen'),
('INSM000364', '2021-01-05', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Rojak'),
('INSM000365', '2021-01-06', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Ninik'),
('INSM000366', '2021-01-01', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Dargo Sumar'),
('INSM000367', '2023-01-13', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Opan Sugo'),
('INSM000368', '2023-01-15', 'Mahasiswa', 'Insert', 'Masuk data baru dengan nama Indra Kenz'),
('INSP000001', '2020-01-01', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Mochammad Febrian Maulana Hesda'),
('INSP000002', '2020-01-02', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Eva Dwi Meliana'),
('INSP000003', '2020-01-03', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Izmi Baihaqi Annur'),
('INSP000004', '2020-01-04', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Adi Sucipto'),
('INSP000005', '2020-01-05', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Nevi Nur Aisyah'),
('INSP000006', '2020-01-06', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Nur Rohman'),
('INSP000007', '2020-01-07', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Kholidina Fiha'),
('INSP000008', '2020-01-08', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Atha Tatata'),
('INSP000009', '2020-01-09', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Gading Gisel'),
('INSP000010', '2020-01-10', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Naufal Najwa'),
('INSP000011', '2020-01-11', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Faizin'),
('INSP000012', '2020-01-12', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Bintang'),
('INSP000013', '2020-01-13', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Dimas Antoni'),
('INSP000014', '2020-01-14', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Jonathan'),
('INSP000015', '2020-01-15', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Hendrawan'),
('INSP000016', '2023-01-12', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Katika Dev'),
('INSP000017', '2023-01-12', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Indra Sugiarto'),
('INSP000018', '2023-01-15', 'Pustakawan', 'Insert', 'Masuk Pustakawan Baru dengan Nama : Rendy Saputra'),
('INST000001', '2021-01-01', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100101'),
('INST000002', '2021-01-02', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100102'),
('INST000003', '2021-01-03', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100201'),
('INST000004', '2021-01-04', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100301'),
('INST000005', '2021-01-05', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100401'),
('INST000006', '2021-01-06', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100501'),
('INST000007', '2021-01-07', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100601'),
('INST000008', '2023-01-12', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100701'),
('INST000009', '2021-01-08', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100702'),
('INST000010', '2021-01-09', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100801'),
('INST000011', '2023-01-12', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100901'),
('INST000012', '2021-01-10', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100902'),
('INST000013', '2021-01-11', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101001'),
('INST000014', '2021-01-12', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101101'),
('INST000015', '2021-01-13', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101201'),
('INST000016', '2021-01-14', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101301'),
('INST000017', '2021-01-15', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101401'),
('INST000018', '2021-01-16', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101501'),
('INST000019', '2021-01-17', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101601'),
('INST000020', '2021-01-18', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101701'),
('INST000021', '2021-01-19', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101801'),
('INST000022', '2021-01-20', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200101901'),
('INST000023', '2021-01-21', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200102001'),
('INST000024', '2021-01-22', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200102101'),
('INST000025', '2023-01-12', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200102401'),
('INST000026', '2021-01-23', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300101'),
('INST000027', '2021-01-24', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300102'),
('INST000028', '2021-01-25', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300201'),
('INST000029', '2021-01-26', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300301'),
('INST000030', '2021-01-27', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300401'),
('INST000031', '2021-01-28', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300501'),
('INST000032', '2021-01-29', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300601'),
('INST000033', '2021-01-30', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300701'),
('INST000034', '2021-01-31', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300801'),
('INST000035', '2021-02-01', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200300901'),
('INST000036', '2021-02-02', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301001'),
('INST000037', '2021-02-03', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301101'),
('INST000038', '2021-02-04', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301201'),
('INST000039', '2021-02-05', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301301'),
('INST000040', '2021-02-06', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301401'),
('INST000041', '2021-02-07', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301501'),
('INST000042', '2021-02-08', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301601'),
('INST000043', '2021-02-09', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301701'),
('INST000044', '2021-02-10', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301801'),
('INST000045', '2021-02-11', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200301901'),
('INST000046', '2021-02-12', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200302001'),
('INST000047', '2021-02-13', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200302101'),
('INST000048', '2021-02-14', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200302201'),
('INST000049', '2021-02-15', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200302301'),
('INST000050', '2021-02-16', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200302401'),
('INST000051', '2021-02-17', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200302501'),
('INST000052', '2021-02-18', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200302601'),
('INST000053', '2021-02-19', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200302701'),
('INST000054', '2021-02-20', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200400101'),
('INST000055', '2021-02-21', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200400201'),
('INST000056', '2021-02-22', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200400301'),
('INST000057', '2021-02-23', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200400401'),
('INST000058', '2021-02-24', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200400501'),
('INST000059', '2021-02-25', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200400601'),
('INST000060', '2021-02-26', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200400701'),
('INST000061', '2021-02-27', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200400801'),
('INST000062', '2021-02-28', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200400901'),
('INST000063', '2021-03-01', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401001'),
('INST000064', '2021-03-02', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401101'),
('INST000065', '2021-03-03', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401201'),
('INST000066', '2021-03-04', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401301'),
('INST000067', '2021-03-05', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401401'),
('INST000068', '2021-03-06', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401501'),
('INST000069', '2021-03-07', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401601'),
('INST000070', '2021-03-08', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401701'),
('INST000071', '2021-03-09', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401801'),
('INST000072', '2021-03-10', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200401901'),
('INST000073', '2021-03-11', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200402001'),
('INST000074', '2021-03-12', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200402101'),
('INST000075', '2021-03-13', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200402201'),
('INST000076', '2021-01-01', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200402301'),
('INST000077', '2021-01-02', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200402401'),
('INST000078', '2021-01-03', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200402501'),
('INST000079', '2021-01-04', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200402601'),
('INST000080', '2021-01-05', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200402701'),
('INST000081', '2021-01-06', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200402801'),
('INST000082', '2021-01-07', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200500101'),
('INST000083', '2021-01-08', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200500201'),
('INST000084', '2021-01-09', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200500301'),
('INST000085', '2021-01-10', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200500401'),
('INST000086', '2021-01-11', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200500501'),
('INST000087', '2021-01-12', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200500601'),
('INST000088', '2021-01-13', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200500701'),
('INST000089', '2021-01-14', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200500801'),
('INST000090', '2021-01-15', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200500901'),
('INST000091', '2021-01-16', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501001'),
('INST000092', '2021-01-17', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501101'),
('INST000093', '2021-01-18', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501201'),
('INST000094', '2021-01-19', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501301'),
('INST000095', '2021-01-20', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501401'),
('INST000096', '2021-01-21', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501501'),
('INST000097', '2021-01-22', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501601'),
('INST000098', '2021-01-23', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501701'),
('INST000099', '2021-01-24', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501801'),
('INST000100', '2021-01-25', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200501901'),
('INST000101', '2021-01-26', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200502001'),
('INST000102', '2021-01-27', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200502101'),
('INST000103', '2021-01-28', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200502201'),
('INST000104', '2021-01-29', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200502301'),
('INST000105', '2021-01-30', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200502401'),
('INST000106', '2021-01-31', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200502501'),
('INST000107', '2021-02-01', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200502601'),
('INST000108', '2021-02-02', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200502701'),
('INST000109', '2021-02-03', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200502801'),
('INST000110', '2021-02-04', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200700101'),
('INST000111', '2021-02-05', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200700201'),
('INST000112', '2021-02-06', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200700301'),
('INST000113', '2021-02-07', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200700401'),
('INST000114', '2021-02-08', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200700501'),
('INST000115', '2021-02-09', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200700601'),
('INST000116', '2021-02-10', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200700701'),
('INST000117', '2021-02-11', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200700801'),
('INST000118', '2021-02-12', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200700901'),
('INST000119', '2021-02-13', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701001'),
('INST000120', '2021-02-14', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701101'),
('INST000121', '2021-02-15', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701201'),
('INST000122', '2021-02-16', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701301'),
('INST000123', '2021-02-17', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701401'),
('INST000124', '2021-02-18', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701501'),
('INST000125', '2021-02-19', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701601'),
('INST000126', '2021-02-20', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701701'),
('INST000127', '2021-02-21', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701801'),
('INST000128', '2021-02-22', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200701901'),
('INST000129', '2021-02-23', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200702001'),
('INST000130', '2023-01-15', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100103'),
('INST000131', '2023-01-15', 'TPeminjaman', 'Insert', 'Masuk Peminjaman baru dengan ID PINJAM :P200100104'),
('UPDB000001', '2023-01-12', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : promise'),
('UPDB000002', '2023-01-12', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : koala kumal'),
('UPDB000003', '2023-01-12', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : promises'),
('UPDB000004', '2023-01-12', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : london Kristen'),
('UPDB000005', '2023-01-15', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : ww'),
('UPDB000006', '2023-01-15', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : padaku'),
('UPDB000007', '2023-01-15', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : filsafat pendidikan islam'),
('UPDB000008', '2023-01-18', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : promisest'),
('UPDB000009', '2023-01-18', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : promisest'),
('UPDB000010', '2023-01-18', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : rumah kaca'),
('UPDB000011', '2023-01-19', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : sanh pemimpi'),
('UPDB000012', '2023-01-19', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : ayah dan Ibu'),
('UPDB000013', '2023-01-19', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : Dilan 1990'),
('UPDB000014', '2023-01-19', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : si anak kuat'),
('UPDB000015', '2023-01-19', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : Kimia'),
('UPDB000016', '2023-06-29', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : Kimia'),
('UPDB000017', '2023-06-29', 'Buku', 'Update', 'Telah dilakukan pengupdatean data pada buku : Fisika 2'),
('UPDM000001', '2023-01-12', 'Mahasiswa', 'Update', 'Telah dilakukan pengupdatean data pada mahasiswa : Bonang SS'),
('UPDM000002', '2023-01-12', 'Mahasiswa', 'Update', 'Telah dilakukan pengupdatean data pada mahasiswa : MUHAMMAD FARIS FIKRI'),
('UPDM000003', '2023-01-12', 'Mahasiswa', 'Update', 'Telah dilakukan pengupdatean data pada mahasiswa : Sahuri'),
('UPDP000001', '2023-01-12', 'Pustakawan', 'Update', 'Telah dilakukan pengupdatean data pada pustakawan : Atha'),
('UPDP000002', '2023-01-12', 'Pustakawan', 'Update', 'Telah dilakukan pengupdatean data pada pustakawan : Gading'),
('UPDP000003', '2023-01-12', 'Pustakawan', 'Update', 'Telah dilakukan pengupdatean data pada pustakawan : Dimas'),
('UPDP000004', '2023-01-12', 'Pustakawan', 'Update', 'Telah dilakukan pengupdatean data pada pustakawan : Dimas Antor'),
('UPDT000001', '2023-01-15', 'TPeminjaman', 'Update', 'Telah dilakukan pengupdatean data pada ID PINJAM :P200100103');

--
-- Triggers `log_aktivitas`
--
DELIMITER $$
CREATE TRIGGER `masuk_logakt` BEFORE INSERT ON `log_aktivitas` FOR EACH ROW BEGIN
DECLARE v_idlog CHAR(10);
SELECT uid_logaktivitas(NEW.tabel,NEW.aksi) INTO v_idlog;
SET NEW.nomor = v_idlog;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `id_nim` char(10) NOT NULL,
  `tanggal_masuk` date NOT NULL DEFAULT current_timestamp(),
  `nama` varchar(40) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `jenis_kelamin` char(1) NOT NULL,
  `alamat` varchar(100) NOT NULL,
  `no_hp` varchar(14) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`id_nim`, `tanggal_masuk`, `nama`, `tanggal_lahir`, `jenis_kelamin`, `alamat`, `no_hp`, `email`) VALUES
('MHS2001001', '2020-01-08', 'Bonang S', '2004-08-09', 'L', 'Jatirokeh Brebes', '082716281823', 'bonasP@gmail.com'),
('MHS2001002', '2020-01-09', 'Meliana', '2009-09-17', 'P', 'Saditan kab.Brebes', '081870272891', 'meli@gmail.com'),
('MHS2001003', '2020-01-10', 'Ilman', '1999-12-06', 'L', 'Salem', '08976', 'manilman@gmail.com'),
('MHS2001004', '2020-01-11', 'kuspartono', '1970-07-02', 'L', 'Semarang', '085', 'mrkholid@gami.com'),
('MHS2001005', '2020-01-12', 'MUHAMMAD FARIS FIKR', '2003-10-02', 'L', 'Jl.Arimbi 1 no 29.Rt,Rw 05/06 Kec.Tegal timur Kota Tegal ', '082241861939', 'fikrifaris675@gmail.com'),
('MHS2001006', '2020-01-13', 'Fajri Abdul Ghani', '2003-08-03', 'L', 'Pakijangan, Berbes', '089538069141', 'Fajriabdulg@gmail.com'),
('MHS2001007', '2020-01-14', 'Ali Imron ', '1980-02-05', 'L', 'Brebes ', '082314722964', ''),
('MHS2001008', '2020-01-15', 'TRIYONO NGADIYANTO', '1977-02-06', 'L', 'BREBES', '087730331803', '_'),
('MHS2001009', '2020-01-16', 'BEJO', '1971-12-08', 'L', 'Jl.Sunan Gunung Jati 1 Rt.01/Rw.02 Limbangan Wetan Brebes', '0813919764977', 'be770871@gmail.com'),
('MHS2001010', '2020-01-17', 'M. BIL MAHRUS', '1979-02-09', 'L', 'JL. BALI 5 NO.52 RT 03/RW 06 ', '082325111415', 'billymahtus@gmail.com'),
('MHS2001011', '2020-01-18', 'HAFIDH GIGIH PURWAJI', '2002-12-09', 'L', ' Dukuh Bandung Desa Kendayakan RT.02/04 Kec.Warureja Kab.Tegal', '0882005385234', 'hafidhgigihpurwajii@gmail.com'),
('MHS2001012', '2020-01-19', 'RIYAN BAYU SAPUTRA', '2002-01-10', 'L', 'Tambakrejo RT 04 RW 06', '089666463314', 'riyanbayu0102@gmail.com'),
('MHS2001013', '2020-01-20', 'Sahuria', '1974-03-10', 'L', 'Jl. Lombok, Dusun Danayasa RT01/06', '082300114533', ''),
('MHS2001014', '2020-01-21', 'DIKA DZIKRI PRATAMA', '2004-07-10', 'L', 'Desa Rengaspendawa', '0895377386177', 'dikadzikri10@gmail.com'),
('MHS2001015', '2020-01-22', 'Ali Sujito', '1970-08-10', 'L', 'Pagongan', '081326974747', ''),
('MHS2001016', '2020-01-23', 'JONATHAN ARDI NUGRAHA', '2002-07-11', 'L', 'TEGAL', '083837097696', 'jonathanardi465@gmail.com'),
('MHS2001017', '2020-01-24', 'SRIYADI MUJIONO.M', '1967-01-12', 'L', 'PANGAH', '081213696428', ''),
('MHS2001018', '2020-01-25', 'HAERUDIN', '1970-12-12', 'L', 'Ds. Dukuh Jeruk Kec.Banjarharjo Kab.Brebes', '087728950413', ''),
('MHS2001019', '2020-01-26', 'Firman ade candra', '1945-05-13', 'L', 'CIREBON', '08770743217', 'Candraade67@gmail.com'),
('MHS2001020', '2020-01-27', 'MOHAMAD IDHAM BAHRI', '2003-02-15', 'L', 'Slawi', '083824723921', 'idhamtamvanz123@gmail.com'),
('MHS2001021', '2020-01-28', 'Muhammad Arya Putra', '2012-05-15', 'L', 'Ds.Janegara Kec.Jatibarang Kab.Brebes', 'NULL', '-'),
('MHS2001022', '2020-01-29', 'Aji Jagat Saputra', '2003-06-16', 'L', 'Pagedangan', '085647492399', 'ajijagat90@gmail.com'),
('MHS2001023', '2020-01-30', 'SULAEMAN', '1965-11-17', 'L', 'JL.SUKROSONO NO.28', '085225241717', 'sulaeman17@gmail.com'),
('MHS2001024', '2020-01-31', 'DEDDI EKO SANTOSO', '1975-01-18', 'L', 'PEMALANG', '081393753498', ''),
('MHS2002001', '2020-02-01', 'FARID FAKHRI DARMAWAN', '1999-06-19', 'L', 'JL.IR.H.JUANDA', '082223981323', ''),
('MHS2002002', '2020-02-02', 'ANGGIT HARYO WICAKSONO', '2004-07-19', 'L', 'Desa Banjaragung DK.Buyut RT 01 RW 05 no.03 Kec.Warureja Tegal', '085329814319', 'anggitharyo492@gmail.com'),
('MHS2002003', '2020-02-03', 'Aas Sugiyanto', '1974-11-19', 'L', 'Ds.Janegara Kec.Jatibarang Kab.Brebes', '087892981269', '-'),
('MHS2002004', '2020-02-04', 'Budi Hendra Santosa', '1969-04-20', 'L', 'Lumajang', '085870628284', 'budihendrasantosadkk@gmail.com'),
('MHS2002005', '2020-02-05', 'Ahmad Daryitno', '1966-03-23', 'L', 'Gembongdadi Rt 02/03', 'NULL', ''),
('MHS2002006', '2020-02-06', 'NATHANAEL BAGAS SETYAWAN', '1999-06-23', 'L', 'SEMARANG', '089647626137', ''),
('MHS2002007', '2020-02-07', 'Dwiko Mahardika', '2001-07-23', 'L', 'Jl. Nakula No. 20', '085838237233', 'dwimahardika968@gmail.com'),
('MHS2002008', '2020-02-08', 'Entang Sukrisman', '1967-05-24', 'L', 'JL. K.H Nakhrawi No.4 RT.7/RW.3 ', '081326277660', 'entangsukrisman2121@gmail.com'),
('MHS2002009', '2020-02-09', 'RUSDI', '1974-07-24', 'L', 'Tambakrejo RT 04 RW 04 ', '0895330189031', ''),
('MHS2002010', '2020-02-10', 'HARIJADI', '1969-12-24', 'L', 'TEGAL', '087836540434', ''),
('MHS2002011', '2020-02-11', 'ADRIYAN BAGUS KRISNAYANDHI', '2003-03-26', 'L', 'PEMALANG', '081228243027', 'adriyanbagus26@gmail.com'),
('MHS2002012', '2020-02-12', 'M ROY SAMSUL AKBAR', '2002-07-27', 'L', 'JLN. CANDI MONCOL', 'NULL', 'citytegal75@gmail.com'),
('MHS2002013', '2020-02-13', 'Achmad Solihin', '1979-12-27', 'L', 'Griya Mejasem Baru 4 Blok C No. 70 RT 004 / RW 017', '082313550334', 'solichinahmad26@gmail.com'),
('MHS2002014', '2020-02-14', 'MUHAMMAD NURHUDA', '1975-01-29', 'L', 'BREBES', '087830000354', 'hudapemalang1@gmail.com'),
('MHS2002015', '2020-02-15', 'AIDA NUR KUSUMA WATI', '2008-06-01', 'P', 'Slawi', '085293512579', 'nurkusuma999@gmail.com'),
('MHS2002016', '2020-02-16', 'Syahrini ', '2000-08-01', 'P', 'JAKARTA', '08992456790', 'Syahrini.67@gmail.com'),
('MHS2002017', '2020-02-17', 'LULU NADHIATUN ANISA', '2003-06-02', 'P', 'Jalan Kapten Samadikun Rt.01/Rw.01 Sumurpanggang', '0895384257065', 'lulunadiatunanisah@gmail.com'),
('MHS2002018', '2020-02-18', 'Ernawati', '1978-07-03', 'P', 'Jln.Cendrawasih', 'NULL', 'Ernawati9902@gmail.com'),
('MHS2002019', '2020-02-19', 'KARTIKA DEVIANI', '2001-08-03', 'P', 'Desa Banjaragung DK.Buyut RT 01 RW 05 no.03 Kec.Warureja Tegal', '081329185235', 'kartikadevianii@gmail.com'),
('MHS2002020', '2020-02-20', 'SULASTRI', '1971-11-05', 'P', 'Jln.Sangir II NO.30 RT/RW 05/11', 'NULL', '-'),
('MHS2002021', '2020-02-21', 'NIKEN WAHYU SETYOWULAN', '1970-04-06', 'P', 'JL.WAHIDIN SLAWI KULON', '081930059773', 'nikenws@gmail.com'),
('MHS2002022', '2020-02-22', 'MEILUNA KARISSA PUTRI', '2010-05-08', 'P', 'Tambakrejo RT 04 RW 07', '085848117235', ''),
('MHS2002023', '2020-02-23', 'Safira Ali Nur Andini', '2009-06-09', 'P', 'Pagedangan', '085526200319', 'syafiraali158@gmail.com'),
('MHS2002024', '2020-02-24', 'FAUZIAH', '1969-04-10', 'P', 'Jl.Arimbi 1 no 29.Rt,Rw 05/06 Kec.Tegal timur Kota Tegal ', '081548017726', ''),
('MHS2002025', '2020-02-25', 'Yeti Herawati', '1984-03-11', 'P', 'Ds.Janegara Kec.Jatibarang Kab.Brebes', '083877138072', 'herawatiyeti@gmail.com'),
('MHS2002026', '2020-02-26', 'Warniti', '1981-08-15', 'P', 'Jl. Lombok, Dusun Danayasa RT01/06', '081911495292', ''),
('MHS2002027', '2020-02-27', 'Ni\'mah Athafarisya', '2003-06-16', 'P', 'Jl. Lombok, Dusun Danayasa RT01/06', '082313840915', 'atafarisa@gmail.com'),
('MHS2002028', '2020-02-28', 'RETNO PURWONINGSIH', '1974-10-18', 'P', ' Dukuh Bandung Desa Kendayakan RT.02/04 Kec.Warureja Kab.Tegal', '081326352533', 'retnopur74@gmail.com'),
('MHS2002029', '2020-02-29', 'ASIH KHAMIDAH', '1990-05-20', 'P', 'Ds.Debong Kulon Kec.Tegal Selatan Kota.Tegal', '087830257870', 'asih.khamidah78@gmail.com'),
('MHS2003001', '2020-03-01', 'LARAS AYUNINGTYAS', '1997-06-21', 'P', 'JL.WAHIDIN SLAWI KULON', '0821135182567', 'larastyas@gmail.com'),
('MHS2003002', '2020-03-02', 'Putri silvia', '1973-05-24', 'P', 'PEMALANG', '089523517892', 'putrisilvia@gmail.com'),
('MHS2003003', '2020-03-03', 'Lia Annisa Fitri', '2009-10-24', 'P', 'Jln.Cendrawasih', 'NULL', 'Liaannisa213@gmail.com'),
('MHS2003004', '2020-03-04', 'DIVA FIKRI AYUDIANI', '2009-06-25', 'P', 'Desa Rengaspendawa', '0895637826826', 'divafkrydn@gmail.com'),
('MHS2003005', '2020-03-05', 'QORI\'AH PURWAJI', '2000-03-26', 'P', ' Dukuh Bandung Desa Kendayakan RT.02/04 Kec.Warureja Kab.Tegal', '087890452815', 'qoriahpurwaji@gmail.com'),
('MHS2003006', '2020-03-06', 'MEI SURYANI', '1970-05-26', 'P', 'TEGAL', '083837097786', ''),
('MHS2003007', '2020-03-07', 'Asihfa Fazwati', '2003-11-26', 'P', 'Ds.Janegara Kec.Jatibarang Kab.Brebes', '083162166034', 'fazwatiasihfa26@gmail.com'),
('MHS2003008', '2020-03-08', 'Nur Laela ', '1982-02-28', 'P', 'Pagedangan ', '085741851002', 'nurlaela2451@gmail.com'),
('MHS2003009', '2020-03-09', 'Echa Triansah Putri', '2003-07-28', 'P', 'Ds.Janegara Kec.Jatibarang Kab.Brebes', '085725247694', 'echatriansah086@gmail.com'),
('MHS2003010', '2020-03-10', 'HARTINI', '1980-08-28', 'P', 'Tambakrejo RT 04 RW 05', '0882007090309', ''),
('MHS2003011', '2020-03-11', 'NOMA ARIYANTI', '1975-03-31', 'P', 'PEMALANG', '087733574023', ''),
('MHS2003012', '2020-03-12', 'TA\'INAH', '1955-12-31', 'P', 'Jln.Sangir II NO.30 RT/RW 05/11', 'NULL', '-'),
('MHS2003013', '2020-03-13', 'Yusuf Habibie', '2011-02-01', 'L', 'Ds.Banjaratma Kec.Bulakamba Kab.Brebes', '08577138072', 'habibi11@gmail.com'),
('MHS2003014', '2020-03-14', 'IMAN NUROFIQ', '1996-03-01', 'L', 'JL.KOL.SUGIONO 28', 'NULL', 'royalsipro@gmail.com'),
('MHS2003015', '2020-03-15', 'Naufal Najmuddin', '2004-05-02', 'L', 'Desa Pesantunan RT 001 RW 001 Kec.Wanasari Kab.Brebes', '085890492732', 'nauvalnajmuddin66@gmail.com'),
('MHS2003016', '2020-03-16', 'Faiz Khasbi Azami', '2008-10-02', 'L', 'Jl. Serayu RT 2 RW 4, Desa Selapura, Kec. Dukuhwaru, Kab. Tegal', '083842731112', 'hasbifaiz7@gmail.com'),
('MHS2003017', '2020-03-17', 'MOHAMMAD SANDI DAVID', '2001-04-03', 'L', 'BREBES', '087861822460', 'msandidavid@gmail.com'),
('MHS2003018', '2020-03-18', 'MOHAMMAD DIVA ATALARIK', '2003-11-03', 'L', 'BREBES', '087814518234', 'mohammaddivaatalarik@gmail.com'),
('MHS2003019', '2020-03-19', 'Adib Munajib', '1974-04-04', 'L', 'Ds.Jatibogor Kec.Suradadi Kab.Tegal', '08990888088', 'adib.mo@yahoo.com'),
('MHS2003020', '2020-03-20', 'Avriansyah Bahtiar', '2000-10-04', 'L', 'Brebes', '081252875978', 'avriansyahb10@gmail.com'),
('MHS2003021', '2020-03-21', 'ROWI', '1900-01-05', 'L', 'JL.  BIAK BARAT C2 RT 008 RW 008 LIMBANGAN WETAN, KEC. BREBES KAB. BREBES', '085786797405', 'rowioowi@gmail.com'),
('MHS2003022', '2020-03-22', 'NUR SHOLIH SA\'DUL KHOLQI', '2003-05-06', 'L', 'Jl.Abdul muis', 'NULL', 'nursolih05@gmail.com'),
('MHS2003023', '2020-03-23', 'IMAM ASHARI', '1977-08-07', 'L', 'TENGKI', '089518953775', 'imamasari@gmail.com'),
('MHS2003024', '2020-03-24', 'Yunus Anis', '1962-05-08', 'L', 'Desa Pesantunan RT 001 RW 001 Kec.Wanasari Kab.Brebes', '087830338463', '-'),
('MHS2003025', '2020-03-25', 'SAKRI', '1975-09-08', 'L', 'TANJUNGSARI', '087791921967', ''),
('MHS2003026', '2020-03-26', 'Sudi Mulyanto', '1978-01-10', 'L', 'Banjaratma Rt 004/010', '081542398422', 'sudimulyanto@gmail.com'),
('MHS2003027', '2020-03-27', 'TORIDIN', '1976-03-10', 'L', 'DS.KERTASINDUYASA RT.03/RW.03 JATIBARANG,BREBES', '085869003980', 'toridin@gmail.com'),
('MHS2003028', '2020-03-28', 'SERENO SYA\'BANA', '2004-06-10', 'L', 'BULAKAMBA', '085700858151', ''),
('MHS2003029', '2020-03-29', 'Abdul Gofur', '1976-01-11', 'L', 'Jl. Serayu RT 2 RW 4, Desa Selapura, Kec. Dukuhwaru, Kab. Tegal', '085601921475', 'furzafa@gmail.com'),
('MHS2003030', '2020-03-30', 'CIPTO HARIYONO', '1996-03-12', 'L', 'CIMOHONG, BULAKAMBA, BREBES', '082329752308', 'ciptohariyono031296@gmail.com'),
('MHS2003031', '2020-03-31', 'WARIS', '1966-07-12', 'L', 'CIMOHONG, BULAKAMBA, BREBES', '085869641541', 'TIDAK ADA'),
('MHS2004001', '2020-04-01', 'RAFFI ARJUN NAJWA', '2005-08-12', 'L', 'JL.KOL.SUGIONO 28', 'NULL', 'raffiarjunnajwa@gmail.com'),
('MHS2004002', '2020-04-02', 'Abdullah', '1965-04-14', 'L', 'Brebes', '085323681987', '-'),
('MHS2004003', '2020-04-03', 'Somadi', '1968-05-14', 'L', 'Jl.Teuku Cik Ditiro Rt/Rw 01/07 kec.Wanasari kab. Brebes', 'NULL', ''),
('MHS2004004', '2020-04-04', 'Abdul Wahid', '1977-04-16', 'L', 'Luwungragi', '081542061500', 'abdulwahid@gmail.com'),
('MHS2004005', '2020-04-05', 'AGIL SAID RAMADON', '2002-11-16', 'L', 'TENGKI', '087867606302', 'agilsaidr@gmail.com'),
('MHS2004006', '2020-04-06', 'GUNTUR TRI PRASETYO', '1977-10-17', 'L', 'BULAKAMBA', '081390652524', ''),
('MHS2004007', '2020-04-07', 'AGUS SUSILO', '1970-08-18', 'L', 'JL.KOL.SUGIONO 28', '085842775335', '-'),
('MHS2004008', '2020-04-08', 'FATTAHILLAH AL HESDA', '2019-03-19', 'L', 'BREBES', '081804631727', 'fattahillahalhesda@gmail.com'),
('MHS2004009', '2020-04-09', 'Mohamad Khadik', '2004-09-19', 'L', 'Luwungragi', '085727235899', 'mohamadkhadik7@gmail.com'),
('MHS2004010', '2020-04-10', 'Arif Hajri', '2007-01-20', 'L', 'Brebes', '083808109831', 'arifhajri@gmail.com'),
('MHS2004011', '2020-04-11', 'RIKY RAHARJO', '2003-07-21', 'L', 'CIMOHONG, BULAKAMBA, BREBES', '082313037995', 'rikyraharjo18@gmail.com'),
('MHS2004012', '2020-04-12', 'Azril Araya', '2009-09-21', 'L', 'Brebes', '089791809312', 'azrilaraya@gmail.com'),
('MHS2004013', '2020-04-13', 'ABDUL HAQ AL\'ASIR', '1977-03-22', 'L', 'JL.IR.H.JUANDA ', '085725719192', ''),
('MHS2004014', '2020-04-14', 'Askara Putra Alfahri', '1970-07-22', 'L', 'Ds.Banjaratma Kec.Bulakamba Kab.Brebes', '087892981269', 'askara69@gmail.com'),
('MHS2004015', '2020-04-15', 'RESTU AGUNG SAMUDRA', '2009-09-22', 'L', 'CIMOHONG, BULAKAMBA, BREBES', 'NULL', 'TIDAK ADA'),
('MHS2004016', '2020-04-16', 'Muh. Halim Fauzan Hafizhdin', '2003-04-25', 'L', 'Jl.Teuku Cik Ditiro Rt/Rw 01/07 kec.Wanasari kab. Brebes', 'NULL', ''),
('MHS2004017', '2020-04-17', 'masrukhin', '1977-04-26', 'L', 'Jl.Abdul muis', 'NULL', 'masrukhin9@gmail.com'),
('MHS2004018', '2020-04-18', 'SAEPTRIMO RIZQI DIONO', '2013-09-26', 'L', 'TANJUNGSARI', 'NULL', ''),
('MHS2004019', '2020-04-19', 'ZETTA ABIGAIL FAWWAS', '2011-10-26', 'L', 'JL.KOL.SUGIONO 28', 'NULL', '-'),
('MHS2004020', '2020-04-20', 'Wardi', '1975-11-26', 'L', 'Gandasuli-Brebes', '085870317140', 'uwohapik@gmial.com'),
('MHS2004021', '2020-04-21', 'RIZKY FARIZH MAULANA', '2000-07-27', 'L', 'BREBES', '082223801227', 'rizkyfarizh96@gmail.com'),
('MHS2004022', '2020-04-22', 'Annur Riyadhus Solikhin', '2002-12-27', 'L', 'Jl. Serayu RT 2 RW 4, Desa Selapura, Kec. Dukuhwaru, Kab. Tegal', '085642240515', 'annurriyadhus17@gmail.com'),
('MHS2004023', '2020-04-23', 'YUSUF AL HESDA', '2007-05-28', 'L', 'BREBES', '085713061217', 'yusufalhesda@gmail.com'),
('MHS2004024', '2020-04-24', 'AKHMAD  RISKI ARDIANSYAH', '2003-03-31', 'L', 'jln.moh muntoha ,kaligangsa kulon', '085866120994', 'iardiansyahakhmad626@gmail.com'),
('MHS2004025', '2020-04-25', 'SODIKIN', '1963-05-31', 'L', 'BREBES', '082135457390', ''),
('MHS2004026', '2020-04-26', 'ARDEN ARJUNA MULVI', '2002-08-31', 'L', 'JL.IR.H.JUANDA', '087824034008', 'ardenarjuna28@gmail.com'),
('MHS2004027', '2020-04-27', 'AKHMAD FUJI KURNIAWAN', '2006-12-31', 'L', 'Jln.moh muntoha ,kaligangsa kulon', '08975844516', ''),
('MHS2004028', '2020-04-28', 'Ely Mutaqofiyah', '1978-09-02', 'P', 'Jl.Teuku Cik Ditiro Rt/Rw 01/07 kec.Wanasari kab. Brebes', 'NULL', ''),
('MHS2004029', '2020-04-29', 'rositah', '1980-12-02', 'P', 'Jl.Abdul muis', 'NULL', 'rositah@gmail.com'),
('MHS2004030', '2020-04-30', 'Widaningsih', '1985-01-03', 'P', 'Banjaratma Rt 004/010', '085786406858', 'wida4978@gmail.com'),
('MHS2005001', '2020-05-01', 'AFRINDA RIZQI FARAHDINTA', '2012-06-03', 'P', 'DS.KERTASINDUYASA RT.03/RW.03 JATIBARANG,BREBES', 'NULL', ' '),
('MHS2005002', '2020-05-02', 'MAULIDA NURULISA HIDAYAH', '1900-01-04', 'P', 'JL.  BIAK BARAT C2 RT 008 RW 008 LIMBANGAN WETAN, KEC. BREBES KAB. BREBES', '087885758740', 'maulidanurulisa@gmail.com'),
('MHS2005003', '2020-05-03', 'AGHNIYAH BUNGA ALHESDA', '2013-02-04', 'P', 'BREBES', '081476651153', 'bungaalhesda@gmail.com'),
('MHS2005004', '2020-05-04', 'Diah yulianti', '1976-05-04', 'P', 'Ds.Banjaratma Kec.Bulakamba Kab.Brebes', '087537251933', 'yuli76@gmail.com'),
('MHS2005005', '2020-05-05', 'Nailu muna', '2012-10-05', 'P', 'luwungragi', 'NULL', '-'),
('MHS2005006', '2020-05-06', 'ROPIKOH', '1979-06-06', 'P', 'TENGKI', '085719874882', 'ropikoh123@gmail.com'),
('MHS2005007', '2020-05-07', 'TARWI', '1969-05-07', 'P', 'CIMOHONG, BULAKAMBA, BREBES', 'NULL', 'TIDAK ADA'),
('MHS2005008', '2020-05-08', 'TATI DASKI', '1975-06-07', 'P', 'Ds. Dukuh Jeruk Kec.Banjarharjo Kab.Brebes', '083852012438', ''),
('MHS2005009', '2020-05-09', 'Tia Rifka', '1997-09-07', 'P', 'Brebes', '081289714901', 'tiarifka@gmail.com'),
('MHS2005010', '2020-05-10', 'EVI PRIHANTI', '1980-12-07', 'P', 'JL.IR.H.JUANDA', '085640491900', ''),
('MHS2005011', '2020-05-11', 'NURUL HIDAYAH AZZAH HIDAH', '2005-02-08', 'P', 'Jl.Abdul muis', 'NULL', 'nurulhidah@gmail.com'),
('MHS2005012', '2020-05-12', 'Ayla Tiara', '2012-12-09', 'P', 'Brebes', 'NULL', '-'),
('MHS2005013', '2020-05-13', 'MURYATI', '1958-01-10', 'P', 'BREBES', '085640656470', 'amanda45pratiwi@gmail.com'),
('MHS2005014', '2020-05-14', 'DARNINGSIH', '1972-03-10', 'P', 'JL.KOL.SUGIONO 28', '082323335645', '-'),
('MHS2005015', '2020-05-15', 'Nur Azizah', '1971-11-10', 'P', 'Brebes', '085600689011', 'nurazzh111071@gmail.co'),
('MHS2005016', '2020-05-16', 'DUMIYATI', '1969-12-10', 'P', 'JL. MASJID ANNUR KEL. PESURUNGAN KIDUL RT/RW. 05/03 Kec. Tegal Barat Kota Tegal', '087880722906', 'sodikindumiyati229@gmail.com'),
('MHS2005017', '2020-05-17', 'SYAHARANI SALSABILLA P', '2001-01-12', 'P', 'BULAKAMBA', '085781617829', 'ssalsabilla32@gmail.com'),
('MHS2005018', '2020-05-18', 'Farah Dwi Anggriyani', '2009-10-12', 'P', 'Banjaratma Rt 004/010', '081211777724', 'rumi6937@gmail.com'),
('MHS2005019', '2020-05-19', 'RAKHMADHANI NURUL AINI', '1900-01-13', 'P', 'JL.  BIAK BARAT C2 RT 008 RW 008 LIMBANGAN WETAN, KEC. BREBES KAB. BREBES', '085171217012', 'rakhmadhaninurulaini@gmail.com'),
('MHS2005020', '2020-05-20', 'Satirah Kh', '2003-10-13', 'P', 'Ds.Banjaratma Kec.Bulakamba Kab.Brebes', '083172265035', 'satirah2003@gmail.com'),
('MHS2005021', '2020-05-21', 'Fifi Rofiatun', '1979-05-14', 'P', 'Griya Mejasem Baru 4 Blok C No. 70 RT 004 / RW 017', '081772844091', 'fifirofiatun05@gmail.com'),
('MHS2005022', '2020-05-22', 'NIKEN PRATIWI KH', '1972-08-14', 'P', 'BREBES, JATIBARANG LOR', '083824580589', 'nikenpratiwi@gmail.com'),
('MHS2005023', '2020-05-23', 'Somar\'ah ', '1965-12-14', 'P', 'Desa Pesantunan RT 001 RW 001 Kec.Wanasari Kab.Brebes', '087764018230', '-'),
('MHS2005024', '2020-05-24', 'Adinda Bintang Febiola', '2003-01-15', 'P', 'Brebes', '085641517571', 'adindabintangfebiola@gmail.com'),
('MHS2005025', '2020-05-25', 'AZKI SOVIANATA', '2000-09-16', 'P', 'Jl.Sunan Gunung Jati 1 Rt.01/Rw.02 Limbangan Wetan Brebes', '088200133134', 'azkisovianata236@gmail.com'),
('MHS2005026', '2020-05-26', 'SHANUM NURUL HILYATUNNISA', '1900-01-17', 'P', 'JL.  BIAK BARAT C2 RT 008 RW 008 LIMBANGAN WETAN, KEC. BREBES KAB. BREBES', 'NULL', '-'),
('MHS2005027', '2020-05-27', 'Rizki Eka Mulyani', '2001-09-17', 'P', 'Kaligangsa Rt 009/004', '085293332484', 'rizkiekamulyani123@gmail.com'),
('MHS2005028', '2020-05-28', 'NURBAETI', '1964-11-17', 'P', 'BREBES', '087812651768', ''),
('MHS2005029', '2020-05-29', 'MUTMAINAH', '1970-10-18', 'P', 'Jl.Sunan Gunung Jati 1 Rt.01/Rw.02 Limbangan Wetan Brebes', '0852269965497', 'mutmainahresbbs@gmail.com'),
('MHS2005030', '2020-05-30', 'HESTI SEDIA UTAMI', '1976-11-18', 'P', 'BREBES', '082133520702', 'hestisediautami@gmail.com'),
('MHS2005031', '2020-05-31', 'NUR FARISKA', '1993-01-20', 'P', 'JL.KOL.SUGIONO 28', 'NULL', 'tehbobaa@gmail.com'),
('MHS2006001', '2020-06-01', 'SAFIRA TRI RAHMADITA', '2011-07-20', 'P', 'BREBES', '087020463938', '_'),
('MHS2006002', '2020-06-02', 'DHIYA SHILMI AULIA', '2002-06-21', 'P', 'JL.KOL.SUGIONO 28', '0895380217759', 'dhiyashilmia@gmail.com'),
('MHS2006003', '2020-06-03', 'DEDE FATMAWATI', '1900-01-22', 'P', 'JL.  BIAK BARAT C2 RT 008 RW 008 LIMBANGAN WETAN, KEC. BREBES KAB. BREBES', '085742821662', 'fatmawatidede744@gmail.com'),
('MHS2006004', '2020-06-04', 'Nur Hasanah', '1978-07-23', 'P', 'Brebes', '085759761565', '-'),
('MHS2006005', '2020-06-05', 'HASNITA RANI KUMALA', '2003-09-23', 'P', 'Jl.Sunan Gunung Jati 1 Rt.01/Rw.02 Limbangan Wetan Brebes', '081229904855', 'hasnitaranikumala@gmail.com'),
('MHS2006006', '2020-06-06', 'Putri Ajeng Imamah', '2003-04-25', 'P', 'Gandasuli-Brebes', '085865845191', 'utriajengimamah.stdy@gmail.com'),
('MHS2006007', '2020-06-07', 'FIRDA AULIA RAKHMAH', '2004-08-25', 'P', 'DS.KERTASINDUYASA RT.03/RW.03 JATIBARANG,BREBES', '085540407654', 'firdaauliarakhma2211@gmail.com'),
('MHS2006008', '2020-06-08', 'Rizka Isnata Mufidah', '2009-05-26', 'P', 'Jl.Teuku Cik Ditiro Rt/Rw 01/07 kec.Wanasari kab. Brebes', 'NULL', ''),
('MHS2006009', '2020-06-09', 'IIN DARYANTI', '1975-11-26', 'P', 'DS.KERTASINDUYASA RT.03/RW.03 JATIBARANG,BREBES', '085719894718', 'iin.daryanti@gmail.com'),
('MHS2006010', '2020-06-10', 'NURUL INAYAH', '1977-11-28', 'P', 'BREBES', '085943506175', '_'),
('MHS2006011', '2020-06-11', 'FIFI ALFIYATUN ROSDIYANAH', '2004-07-31', 'P', 'jln.moh muntoha ,kaligangsa kulon', '0895422832074', ''),
('MHS2006012', '2020-06-12', 'ARFAN AS\'SIDIQ', '1997-03-01', 'L', 'Jalan Pangeran Antasari RT 5/RW 3 No. 45', 'NULL', 'arfanasdq@gmail.com'),
('MHS2006013', '2020-06-13', 'Mohamad Faizin', '2002-05-01', 'L', 'Jl.Serayu Slawi Wetan RT 19 RW 07', '08999406810', ''),
('MHS2006014', '2020-06-14', 'Dimas Nur Fauzi Antoro', '2004-08-01', 'L', 'Jln.Cendrawasih', 'NULL', 'dimasnfa1804@gmail.com'),
('MHS2006015', '2020-06-15', 'TARYONO', '1969-01-02', 'L', 'JLN. CANDI MONCOL', 'NULL', 'cesti122@gmail.com'),
('MHS2006016', '2020-06-16', 'Suhadi', '1968-02-02', 'L', 'Jl.Serayu Slawi Wetan RT 19 RW 07', '089516611895', ''),
('MHS2006017', '2020-06-17', 'ADAM EZRA HAQQANI', '2003-04-02', 'L', 'Karangjati, kec.Tarub, kab.Tegal', '0895384217740', 'a.adamezra@gmail.com'),
('MHS2006018', '2020-06-18', 'NURCHOLIS', '1977-07-02', 'L', 'Jl.FLORES GG.3 RT.04 RW.09 PANGGUNG ', '08156938799', ''),
('MHS2006019', '2020-06-19', 'Eman Prasojo', '2001-12-02', 'L', 'JLN.Saparua No.30 RT.4 RW.9 Panggung Tegal Timur', '085760034322', 'prasojoeman@gmail.com'),
('MHS2006020', '2020-06-20', 'Muhammad Fadil', '2002-05-03', 'L', 'TEGAL', '089533278190', 'M.fadil01@gmail.com'),
('MHS2006021', '2020-06-21', 'Muh Faqih Maulana', '2003-08-03', 'L', 'Jl.Mbah Bregas 40 Sidakaton Rt 02/09 Kec.Dukuhturi Kab.Tegal', '0895337365528', 'faqihmaulana936@gmail.com'),
('MHS2006022', '2020-06-22', 'HARTONO', '1988-10-03', 'L', 'SLAWI WETAN ', '081274269044', 'Hartono12@gmail.com'),
('MHS2006023', '2020-06-23', 'Fakhrul Khusaeni', '2002-11-03', 'L', 'Jalan Kerti RT 03 RW 16 Suradadi Kab. Tegal', '0895704307742', 'fakhrulkhusaeni@gmail.com'),
('MHS2006024', '2020-06-24', 'BAGAS AZFA HAQQANI', '2007-12-03', 'L', 'Karangjati, kec.Tarub, kab.Tegal', 'NULL', ''),
('MHS2006025', '2020-06-25', 'BAMBANG SUMARDI', '1967-01-04', 'L', 'JL.WAHIDIN SLAWI KULON', '085709828542', 'bambangs@gmail.com'),
('MHS2006026', '2020-06-26', 'IMAM AL FATIH', '2016-03-04', 'L', 'JL. KH. MAS MANSYUR, RT 003/ RW 005, KEL. SLAWI KULON, KEC. SLAWI, KAB. TEGAL', 'NULL', ''),
('MHS2006027', '2020-06-27', 'NURSODIK', '1970-06-04', 'L', 'Jalan Pangeran Antasari RT 5/RW 3 No. 45', '083821237481', 'nursodik@gmail.com'),
('MHS2006028', '2020-06-28', 'Muhammad Abdillah Nur Ziddan Sujito', '2004-01-05', 'L', 'Pagongan', '081325264947', 'adabdillahnurzidddan@gmail.com'),
('MHS2006029', '2020-06-29', 'Imam Santoso', '1980-02-05', 'L', 'Jln. Pagedangan', 'NULL', 'paktoso52@gmail.com'),
('MHS2006030', '2020-06-30', 'Tasirin', '1972-04-05', 'L', 'Jl. Flores RT09/09 Kel.Panggung Kec.Tegal Timur Kota Tegal', '085641766984', 'tasirin988@gmail.com'),
('MHS2007001', '2020-07-01', 'Sahroni', '1977-06-05', 'L', 'Slarang Kidul Rt 05 Rw 02', '085821569636', ''),
('MHS2007002', '2020-07-02', 'BUDI SANTOSO', '1971-08-05', 'L', 'JL.DUKU GANG 3', '087833801251', ''),
('MHS2007003', '2020-07-03', 'MOHAMAD REVITO AL FAJRI', '2002-11-05', 'L', 'JL. BEO GANG BEO, KELURAHAN RANDUGUNTING', '081990686602', 'revitomohamad05@gmail.com'),
('MHS2007004', '2020-07-04', 'Fairel Atharizz Calief Sujito', '2006-01-06', 'L', 'Pagongan', 'NULL', ''),
('MHS2007005', '2020-07-05', 'Erlangga Adnan Bimanufi', '2008-07-06', 'L', 'Jl.Raya Sulang,Mejasem Timur RT 05/06', '087883450417', ''),
('MHS2007006', '2020-07-06', 'NUROCHMAN', '1975-08-06', 'L', 'KALIGANGSA', 'NULL', 'nurrokhman361@gmail.com'),
('MHS2007007', '2020-07-07', 'Akhmad zaeni', '1968-05-07', 'L', 'Rt 12/ Rw02 Desa Tembok Kidul kecamatan Adiwerna KAB. Tegal ', '081391863141', ''),
('MHS2007008', '2020-07-08', 'Rafael Rinta Primadani', '2002-10-07', 'L', 'Jl. Moh Toha Kaligangsa RT/RW 02/03', '081227717133', 'rafaelrinta071002@gmail.com'),
('MHS2007009', '2020-07-09', 'Damar Ezar Raditya', '2008-01-08', 'L', 'Griya Mejasem Baru 4 Blok C No. 70 RT 004 / RW 017', '081368613115', 'radityaezardamar@gmail.com'),
('MHS2007010', '2020-07-10', 'Moh.Amirin', '1980-08-08', 'L', 'Tegalwangi', '085219795106', 'amirin12@gmail.com'),
('MHS2007011', '2020-07-11', 'Fadillah surya Irawan', '2002-01-09', 'L', 'Ds sindang rt02/06 kec Dukuhwaru', '089524174289', 'dillahsuryairawan360@gmail.com'),
('MHS2007012', '2020-07-12', 'ZULFAN FAKHRI PURWAJI', '2017-03-09', 'L', ' Dukuh Bandung Desa Kendayakan RT.02/04 Kec.Warureja Kab.Tegal', 'NULL', '                             -'),
('MHS2007013', '2020-07-13', 'ARIF SAMIAJI', '2003-04-09', 'L', 'Ds.Debong Kulon Kec.Tegal Selatan Kota.Tegal', '087797741817', 'arif.samiaji19@gmail.com'),
('MHS2007014', '2020-07-14', 'ADI SUCIPTO', '2003-12-09', 'L', 'Jl. Sultan Hasanudin Rt03, Rw 02, Cabawan, Kota Tegal', '089653677147', 'suciptoadi1199@gmail.com'),
('MHS2007015', '2020-07-15', 'Ramin', '1978-02-10', 'L', 'jl. Raya Suradadi No 52 Rt 02 Rw 02, Desa Suradadi.', 'NULL', 'ramonmansuliwa@yahoo.com'),
('MHS2007016', '2020-07-16', 'YUSMANTORO', '1965-04-10', 'L', 'JL.P.KEMERDEKAAN GG.27', '089615576778', 'yusmantoro04@gmail.com'),
('MHS2007017', '2020-07-17', 'Muhammad Afwan Khafidz', '2002-02-11', 'L', 'Jl.Raya Bedug Pangkah Tegal', '081770691828', ''),
('MHS2007018', '2020-07-18', 'CASMADI', '1975-07-11', 'L', 'Desa Jatilawang Kec. Kramat Kab. Tegal', '087722956338', ''),
('MHS2007019', '2020-07-19', 'SALAFI DWI PRIANTO', '1997-10-11', 'L', 'JL.P.KEMERDEKAAN GG.27', '089531351899', 'salafidp27@gmail.com'),
('MHS2007020', '2020-07-20', 'Suharto', '1969-01-12', 'L', 'Jalan Kerti RT 03 RW 16 Suradadi Kab. Tegal', '085842530515', ''),
('MHS2007021', '2020-07-21', 'Dimas Bintang Pratama', '2002-07-12', 'L', 'Jl.Serayu RT 19 RW 07 No. 7 Slawi Wetan', '081391695853', 'dimasbintang0712@gmail.com'),
('MHS2007022', '2020-07-22', 'M. HANIF SYAHPUTRA', '2013-09-12', 'L', 'Desa Jatilawang Kec. Kramat Kab. Tegal', '087700141643', ''),
('MHS2007023', '2020-07-23', 'Ezar Raditya', '2008-10-12', 'L', 'jl. Raya Suradadi No 52 Rt 02 Rw 02, Desa Suradadi.', '0895360936189', 'ezarraditya12@gmail.com'),
('MHS2007024', '2020-07-24', 'Byan Arya wibowo', '2011-01-13', 'L', 'Ds Kaligayam', 'NULL', ''),
('MHS2007025', '2020-07-25', 'RISKY LINTANG SETIAWAN', '2011-06-13', 'L', 'PANGKAH', '085975260673', ''),
('MHS2007026', '2020-07-26', 'HENDRAWAN DIANA PUTRA', '2001-09-13', 'L', 'Desa Jatilawang Kec. Kramat Kab. Tegal', '081575663726', 'hendrawandp4@gmail.com'),
('MHS2007027', '2020-07-27', 'Kusnadi', '1957-01-14', 'L', 'Jl.Sawo Pedagangan Rt 02/01 kec.dukuhwaru kab. Tegal', '089415264511', ''),
('MHS2007028', '2020-07-28', 'SURIP', '1954-02-15', 'L', 'JL.JONGOR NO.47 RT.10/RW.02', 'NULL', ''),
('MHS2007029', '2020-07-29', 'Seko Tri K', '1977-03-15', 'L', 'Ds Kaligayam', 'NULL', ''),
('MHS2007030', '2020-07-30', 'CASYANTO', '1975-04-15', 'L', 'Jalan Surabayan Panggung', '085726089513', ''),
('MHS2007031', '2020-07-31', 'maulana pandu pradana ', '1996-05-15', 'L', 'Ds peswahan pangkah', '087883395453', 'maulanapandu33@gmail.com'),
('MHS2008001', '2020-08-01', 'HUSNI AINNUN NABILAL ', '1999-07-15', 'L', 'JL.KLEBEN RT 02 RW 01 DESA GEMBONG KULON TALANG TEGAL', '082261374700', ''),
('MHS2008002', '2020-08-02', 'Maskholik', '1984-01-16', 'L', 'Jl.Sawo Pedagangan Rt 02/01 kec.dukuhwaru kab. Tegal', '089623465698', 'cozydef@gmail.com'),
('MHS2008003', '2020-08-03', 'M SARIF MAULANA', '2003-01-17', 'L', 'JL.JONGOR NO.47 RT.10/RW.02', '089668088635', 'Syarifm180@gmail.com'),
('MHS2008004', '2020-08-04', 'Rudi Antoro', '1975-02-17', 'L', ' Jln.Cendrawasih', 'NULL', 'Rudiantoro7102@gmail.com'),
('MHS2008005', '2020-08-05', 'ISNEN ROAJI', '1969-03-17', 'L', ' Dukuh Bandung Desa Kendayakan RT.02/04 Kec.Warureja Kab.Tegal', '082326616663', 'iroaji69@gmail.com'),
('MHS2008006', '2020-08-06', 'Maksudi', '1970-04-17', 'L', 'Jl.Kemuning 1 Ujungrusi Rt 19/02 kec.adiwerna kab. Tegal', '085325481113', ''),
('MHS2008007', '2020-08-07', 'M GUNTUR WIBISONO', '2005-04-18', 'L', 'JL.SUKROSONO NO.28', '089538491122', 'gunturwibi18@gmail.com'),
('MHS2008008', '2020-08-08', 'Nurokhim', '1969-05-18', 'L', 'Jl.Raya Sulang,Mejasem Timur RT 05/06', '087764001062', 'nurokhimnurokhim8@gmail.com'),
('MHS2008009', '2020-08-09', 'NUROCHIM', '1956-06-18', 'L', 'Jl.Prof.Buyahamka no 21 Rt 03 Rw 03 Margadana', '081228286363', 'Nurochim21@gmail.com'),
('MHS2008010', '2020-08-10', 'Eko Sudi Raharjo', '1977-08-18', 'L', 'Ds. Brekat RT07/RW01', '087730217719', 'ekosudiraharjo@gmail.com'),
('MHS2008011', '2020-08-11', 'ZENAL ARIFIN', '1974-01-19', 'L', 'Ds.Debong Kulon Kec.Tegal Selatan Kota.Tegal', '085742206420', 'zenall0111@gmail.com'),
('MHS2008012', '2020-08-12', 'Ilyas Wahyu Putra Briliantara', '2002-08-19', 'L', 'Jl. P. Kemerdekaan Gg. 15 No. 19', 'NULL', 'briliantarailyas@gmail.com'),
('MHS2008013', '2020-08-13', 'GADING ILHA SAPUTRA', '2003-03-20', 'L', 'Desa Pendawa RT 004 RW 001 Kec.Lebaksiu Kab.Tegal', '088806537364', 'gadingilham20@gmail.com'),
('MHS2008014', '2020-08-14', 'Imam Muzaki Ikhsan', '2006-06-20', 'L', 'Jl. Sucipto Randugunting', '0823758497594', ''),
('MHS2008015', '2020-08-15', 'ABDUL ROJAK', '1962-07-20', 'L', 'PESAREAN PAGERBARANG KABUPATEN TEGAL', 'NULL', '-'),
('MHS2008016', '2020-08-16', 'DIMAS WILDAN BASHORUDIN ', '1992-09-20', 'L', 'JL.KLEBEN RT 02 RW 01 DESA GEMBONG KULON TALANG TEGAL', 'NULL', ''),
('MHS2008017', '2020-08-17', 'NANDA ZULFIKAR', '2003-11-20', 'L', 'JL.KLEBEN RT 02 RW 01 DESA GEMBONG KULON TALANG TEGAL', '085290233878', ''),
('MHS2008018', '2020-08-18', 'BAMBANG PONCOWOLO', '1975-02-21', 'L', 'Desa Banjaragung DK.Buyut RT 01 RW 05 no.03 Kec.Warureja Tegal', '085325751321', 'bponco@gmail.com'),
('MHS2008019', '2020-08-19', 'MOH ASIKIN', '1967-07-21', 'L', 'TEGAL', 'NULL', ''),
('MHS2008020', '2020-08-20', 'YUSUF DWI SAPUTRA', '2005-06-22', 'L', 'Jalan Surabayan Panggung', '082136563381', 'yusufdwi456@gmail.com'),
('MHS2008021', '2020-08-21', 'ZULFA HIDAYAT MAULANA PRAMITA', '1998-08-22', 'L', 'Jln.Sangir II NO.30 RT/RW 05/11', 'NULL', '-'),
('MHS2008022', '2020-08-22', 'Mubasirin', '1978-11-22', 'L', 'Jl. Moh Toha Kaligangsa RT/RW 02/03', '085218343397', '-'),
('MHS2008023', '2020-08-23', 'Waridi', '1983-03-23', 'L', 'Jl banyuwangi Rt09 Rw01', '0878213385710', 'endangtresno23@gmail.com'),
('MHS2008024', '2020-08-24', 'MOHAMAD LUKMANUL CHAKIM', '1978-04-23', 'L', 'JL. BEO GANG BEO, KELURAHAN RANDUGUNTING', '087730963788', ''),
('MHS2008025', '2020-08-25', 'Komari', '1972-07-23', 'L', 'Jl.Mbah Bregas 40 Sidakaton Rt 02/09 Kec.Dukuhturi Kab.Tegal', '013456789012', ''),
('MHS2008026', '2020-08-26', 'BIMA ARYA FATAH', '2003-08-23', 'L', 'JL. KH. MAS MANSYUR, RT 003/ RW 005, KEL. SLAWI KULON, KEC. SLAWI, KAB. TEGAL', '0895422482933', 'bimaaryafatah23@gmail.com'),
('MHS2008027', '2020-08-27', 'Muhamad syarif hidayatullah', '2003-09-23', 'L', 'Rt 12/ Rw02 Desa Tembok Kidul kecamatan Adiwerna KAB. Tegal ', '082333305520', 'syarifhidayat84698@gmail.com'),
('MHS2008028', '2020-08-28', 'Rifa Aulia Pradana', '2002-12-23', 'L', 'Ds. Brekat RT07/RW01', '082329720857', 'rifaauliapradana17@gmail.com'),
('MHS2008029', '2020-08-29', 'Syahrindra', '2003-01-24', 'L', 'Jl banyuwangi Rt09 Rw01', '0895422824607', 'indrasofyan918@gmail.com'),
('MHS2008030', '2020-08-30', 'MABRURIDLO', '1971-12-24', 'L', 'SURADADI', '081697245637', 'mabruridlo93@gmail.com'),
('MHS2008031', '2020-08-31', 'Ibnu Fajar As Syukron', '2002-09-25', 'L', 'Gembongdadi Rt 02/03', '082325118247', 'fajarasykron25@gmail.com'),
('MHS2009001', '2020-09-01', 'TEGAR TRI ATMOJO', '2009-11-25', 'L', 'TEGAL', '085693063491', ''),
('MHS2009002', '2020-09-02', 'Agung Jugo Wachju Satrijo', '1977-02-26', 'L', 'Jl. P. Kemerdekaan Gg. 15 No. 19', 'NULL', '-'),
('MHS2009003', '2020-09-03', 'Aldi Bhanu Azhar', '2003-08-26', 'L', 'Ds.Jatibogor Kec.Suradadi Kab.Tegal', '08996060666', 'aldi.bhaz10@gmail.com'),
('MHS2009004', '2020-09-04', 'Muhammad Irkham Faozan', '2003-03-27', 'L', 'Tegalwangi', '0895380174288', 'irkham112@gmail.com'),
('MHS2009005', '2020-09-05', 'Aji Dwi Prawira', '1998-04-27', 'L', 'Jl.Serayu Slawi Wetan RT 19 RW 07', '085290673804', ''),
('MHS2009006', '2020-09-06', 'MOHAMMAD FAKRUROJI NURUL IKSAN', '2003-06-27', 'L', 'KALIGANGSA', '081392393233', 'fakruroji122@gmail.com'),
('MHS2009007', '2020-09-07', 'Sugianto', '1964-09-27', 'L', 'Jl. Nakula No. 20', '085647350279', 'sugianto.tgl64@gmail.com'),
('MHS2009008', '2020-09-08', 'ABDUL KARIM', '1953-11-27', 'L', 'JL. KH. MAS MANSYUR, RT 003/ RW 005, KEL. SLAWI KULON, KEC. SLAWI, KAB. TEGAL', 'NULL', ''),
('MHS2009009', '2020-09-09', 'WILLY ANGGI PRAMULIANTO', '2003-12-27', 'L', 'Jalan Surabayan Panggung', '081325553864', 'willytav123@gmail.com'),
('MHS2009010', '2020-09-10', 'M ALI NURDIN', '2002-03-28', 'L', 'JL. MASJID ANNUR KEL. PESURUNGAN KIDUL RT/RW. 05/03 Kec. Tegal Barat Kota Tegal', '087770566108', 'alinurdinais19@gmail.com'),
('MHS2009011', '2020-09-11', 'GAGAH BILAL FIRDAUS', '2016-05-28', 'L', 'Desa Pendawa RT 004 RW 001 Kec.Lebaksiu Kab.Tegal', '081563742869', '-'),
('MHS2009012', '2020-09-12', 'ADRIAN FAIRUZ R', '2015-06-28', 'L', 'Jl. Sultan Hasanudin Rt03, Rw 02, Cabawan, Kota Tegal', 'NULL', '-'),
('MHS2009013', '2020-09-13', 'Satrio Aldi Firmansyah', '2001-09-28', 'L', 'Jl. Nakula Selatan slawi', '0823847567458', ''),
('MHS2009014', '2020-09-14', 'Pahlevi Faisal Adam', '1995-03-29', 'L', 'Jl.Raya Sulang,Mejasem Timur RT 05/06', '085977846720', ''),
('MHS2009015', '2020-09-15', 'NUR RIZQI MAULANA', '2000-06-29', 'L', 'Desa Lemahduwur Rt 11 Rw 02, Adiwerna - Kab. Tegal', '08816559397', 'maulana29.rizqi@gmail.com'),
('MHS2009016', '2020-09-16', 'RAMINTA', '1965-09-29', 'L', 'Jln.Sangir II NO.30 RT/RW 05/11', 'NULL', '-'),
('MHS2009017', '2020-09-17', 'DIMAS AJI SAPUTRA', '2002-11-29', 'L', 'TEGAL', '087837956762', 'dimasajisaputra692@gmail.com'),
('MHS2009018', '2020-09-18', 'Harnowo Adhi Nugroho', '2001-12-29', 'L', 'Jl.Flores Gang 2 Rt 09/09 kec.tegal timur kota tegal', '087846817632', 'Harnowoadhi@gmail.com'),
('MHS2009019', '2020-09-19', 'Nahrul hayat', '1997-11-30', 'L', 'Rt 12/ Rw02 Desa Tembok Kidul kecamatan Adiwerna KAB. Tegal ', 'NULL', ''),
('MHS2009020', '2020-09-20', 'IVANDER JOSH SANTOSO', '2002-12-31', 'L', 'JL.DUKU GANG 3', '087803112001', 'NAVIVAN3112@GMAIL.COM'),
('MHS2009021', '2020-09-21', 'ROHADATUL AISYI FATIKHA', '2003-01-01', 'P', 'Jl.FLORES GG.3 RT.04 RW.09 PANGGUNG ', '089527344073', 'aisyifatia23@gmail.com'),
('MHS2009022', '2020-09-22', 'Fadila Rizka', '2002-05-02', 'P', 'jl. Raya Suradadi No 52 Rt 02 Rw 02, Desa Suradadi.', '088223734542', 'fadilarizkanuraminah@gmail.com'),
('MHS2009023', '2020-09-23', 'Farhati', '1973-07-02', 'P', 'Jl.Raya Sulang,Mejasem Timur RT 05/06', '087721783345', ''),
('MHS2009024', '2020-09-24', 'Rafidatus Salsabilah Qosimah', '2002-12-02', 'P', 'JL. K.H Nakhrawi No.4 RT.7/RW.3 ', '089525739412', 'r.salsabilah.q@gmail.com'),
('MHS2009025', '2020-09-25', 'Ayu Widya Fakhira', '2002-01-03', 'P', 'Ds.Jatibogor Kec.Suradadi Kab.Tegal', '0899055055', 'ayufakhira03@gmail.com'),
('MHS2009026', '2020-09-26', 'Khilyatul Maizun', '2007-04-03', 'P', 'Jl. Samanhudi no. 58', '082313999089', ''),
('MHS2009027', '2020-09-27', 'Nur Hayati', '1974-05-03', 'P', 'Jl. Samanhudi no. 58', '081226073064', ''),
('MHS2009028', '2020-09-28', 'Tuslikha', '1974-06-03', 'P', 'Jl.Mbah Bregas 40 Sidakaton Rt 02/09 Kec.Dukuhturi Kab.Tegal', '085641204496', ''),
('MHS2009029', '2020-09-29', 'Chelsea Putri Olivia', '2009-07-03', 'P', 'Jl.Serayu RT 19 RW 07 No. 7 Slawi Wetan', '0895377119283', ''),
('MHS2009030', '2020-09-30', 'Aurelia Naurah Zafarani', '2016-09-03', 'P', 'Jl. Serayu RT 2 RW 4, Desa Selapura, Kec. Dukuhwaru, Kab. Tegal', 'NULL', '-'),
('MHS2010001', '2020-10-01', 'Rahma Reza Dea Bonita', '2007-12-03', 'P', 'Jl. P. Kemerdekaan Gg. 15 No. 19', 'NULL', '-'),
('MHS2010002', '2020-10-02', 'DEA SULISTIANA PUTRI', '2001-04-04', 'P', 'JL.SUKROSONO NO.28', '085712168080', 'deasulis04@gmail.com'),
('MHS2010003', '2020-10-03', 'NUR ALIYAH', '2003-06-04', 'P', 'PESAREAN PAGERBARANG KABUPATEN TEGAL', '0859106616588', 'nuraliyah040603@gmail.com'),
('MHS2010004', '2020-10-04', 'Mualimah', '1968-08-04', 'P', 'Gembongdadi Rt 02/03', 'NULL', ''),
('MHS2010005', '2020-10-05', 'Komarlinah', '1981-12-04', 'P', 'Ds. Brekat RT07/RW01', 'NULL', ''),
('MHS2010006', '2020-10-06', 'NURUL FEBI ANISA', '2002-02-05', 'P', 'Jl.Prof.Buyahamka no 21 Rt 03 Rw 03 Margadana', '081919008338', 'nurulfebyanisa26@gmail.com'),
('MHS2010007', '2020-10-07', 'Nayla Asyita Almahira', '2011-07-05', 'P', 'Jl. Moh Toha Kaligangsa RT/RW 02/03', '082112379933', '-'),
('MHS2010008', '2020-10-08', 'sri lestari', '1976-08-05', 'P', 'Ds sindang rt02/06 kec Dukuhwaru', '082325457552', ''),
('MHS2010009', '2020-10-09', 'Daningsih', '1969-09-05', 'P', 'Jl. Flores RT09/09 Kel.Panggung Kec.Tegal Timur Kota Tegal', '085879316984', 'daningsihdaningsih8@gmail.com'),
('MHS2010010', '2020-10-10', 'Ika Sukmawati', '2003-10-05', 'P', 'Ds.Pagongan rt 01/rw04', '081909828542', 'Ikasukmawati005@gmail.com'),
('MHS2010011', '2020-10-11', 'Yuli Herawati', '1977-06-06', 'P', 'Jl. P. Kemerdekaan Gg. 15 No. 19', 'NULL', '-'),
('MHS2010012', '2020-10-12', 'WURYANTI', '1953-02-07', 'P', 'JL. KH. MAS MANSYUR, RT 003/ RW 005, KEL. SLAWI KULON, KEC. SLAWI, KAB. TEGAL', '085742878001', 'wuryanti1953@gmail.com'),
('MHS2010013', '2020-10-13', 'SANATI', '1967-04-07', 'P', 'PESAREAN PAGERBARANG KABUPATEN TEGAL', 'NULL', '-'),
('MHS2010014', '2020-10-14', 'Alfiyah', '1976-06-07', 'P', 'Ds.Jatibogor Kec.Suradadi Kab.Tegal', '089650506000', '-'),
('MHS2010015', '2020-10-15', 'TIARA PERMATASARI', '2003-07-07', 'P', 'PANGKAH', '081914138850', 'sayatiara74@gamail.com'),
('MHS2010016', '2020-10-16', 'Putri Willa Andini', '2002-11-07', 'P', 'Griya Mejasem Baru 4 Blok C No. 70 RT 004 / RW 017', '081215562576', 'riiwillaandiinii1102@gmail.com'),
('MHS2010017', '2020-10-17', 'Dewi Amanda Yuniati', '1995-06-08', 'P', 'Jl. Nakula No. 20', '081958181580', 'dewiamanda94@gmail.com'),
('MHS2010018', '2020-10-18', 'NADYA SHALSABILLAH', '1997-07-08', 'P', 'JLN. CANDI MONCOL', 'NULL', 'nadya08@gmail.com'),
('MHS2010019', '2020-10-19', 'Olivia Amanda Putri', '2009-06-09', 'P', 'Jln. Pagedangan', 'NULL', 'amanda96@gmail.com'),
('MHS2010020', '2020-10-20', 'Nasya Firli Umihani Sujito', '1999-04-10', 'P', 'Pagongan', '081292040293', 'nasyafirliu@gmail.com'),
('MHS2010021', '2020-10-21', 'YESAYA WIDIYA', '2003-06-10', 'P', 'Ds. Dukuh Jeruk Kec.Banjarharjo Kab.Brebes', '083808840257', 'yesayawidiya@gmail.com'),
('MHS2010022', '2020-10-22', 'Maslicha', '1976-08-10', 'P', 'Tegalwangi', '089536926817', 'umimaslicha@gmail.com'),
('MHS2010023', '2020-10-23', 'DAVINA RAMADIYANTI LUQYANA', '2005-10-10', 'P', 'JL. BEO GANG BEO, KELURAHAN RANDUGUNTING', 'NULL', ''),
('MHS2010024', '2020-10-24', 'Sopuroh', '1973-04-11', 'P', 'Slarang Kidul Rt 05 Rw 02', '085717461675', ''),
('MHS2010025', '2020-10-25', 'Retno Aditya Sari', '1995-06-11', 'P', 'Jl.Kemuning 1 Ujungrusi Rt 19/02 kec.adiwerna kab. Tegal', '081328507934', 'enhoaditya@gmail.com'),
('MHS2010026', '2020-10-26', 'Nurul Aisyah', '2002-07-11', 'P', 'Jl.Kemuning 1 Ujungrusi Rt 19/02 kec.adiwerna kab. Tegal', '089666864414', 'nurulaisyah.sch@gmail.com'),
('MHS2010027', '2020-10-27', 'Jihan Farah Dila', '2006-09-11', 'P', 'Tegalwangi', '089503259897', 'farahdilaa7@gmail.com'),
('MHS2010028', '2020-10-28', 'TITI ASTUTI', '1971-10-11', 'P', 'JL.SUKROSONO NO.28', '081542220505', 'titiastuti@gmail.com'),
('MHS2010029', '2020-10-29', 'NURIYAH', '1967-12-11', 'P', 'JL.P.KEMERDEKAAN GG.27', '0895348517347', 'nuriyah1112@gmail.com'),
('MHS2010030', '2020-10-30', 'Hafizhatul Awaliyah', '1997-02-12', 'P', 'JL. K.H Nakhrawi No.4 RT.7/RW.3 ', '089525739366', 'aficute18984@gmail.com'),
('MHS2010031', '2020-10-31', 'Waidah', '1969-04-12', 'P', 'Jl.Serayu Slawi Wetan RT 19 RW 07', 'NULL', ''),
('MHS2011001', '2020-11-01', 'NABILLA AULY ZAHRA', '2003-05-12', 'P', 'JL.P.KEMERDEKAAN GG.27', '0895357973905', 'nabillaaz012@gmail.com'),
('MHS2011002', '2020-11-02', 'Rositah', '1980-09-12', 'P', 'Jl. Moh Toha Kaligangsa RT/RW 02/03', '081212620830', '-'),
('MHS2011003', '2020-11-03', 'Fania Lathifah', '2013-04-13', 'P', 'Jl.Raya Bedug Pangkah Tegal', 'NULL', ''),
('MHS2011004', '2020-11-04', 'ISRO HANDAYANI', '1978-06-13', 'P', 'Karangjati, kec.Tarub, kab.Tegal', 'NULL', ''),
('MHS2011005', '2020-11-05', 'KHUSNUL CHASANAH', '1978-08-13', 'P', 'Jl. Sultan Hasanudin Rt03, Rw 02, Cabawan, Kota Tegal', '089618269289', 'chasanahkhusnul@gmail.com'),
('MHS2011006', '2020-11-06', 'Sapariyah', '1972-09-13', 'P', 'Jalan Kerti RT 03 RW 16 Suradadi Kab. Tegal', '081567964909', ''),
('MHS2011007', '2020-11-07', 'CITRA AYU ANANDITA', '1996-10-13', 'P', 'JL.SUKROSONO NO.28', '081559934444', 'citraayu@gmail.com'),
('MHS2011008', '2020-11-08', 'DAVINA DWI CAHYANI', '2007-11-13', 'P', 'TEGAL', '081995135549', ''),
('MHS2011009', '2020-11-09', 'SRI MULYATI', '1974-12-13', 'P', 'Jalan Kapten Samadikun Rt.01/Rw.01 Sumurpanggang', '081574404143', 'sr.mulyati@gmail.com'),
('MHS2011010', '2020-11-10', 'GITA PRAMESTI', '2002-04-14', 'P', 'SLAWI WETAN ', '087885593776', 'gitapramesti69@gmail.com'),
('MHS2011011', '2020-11-11', 'Nur Tami Ni\'mah', '1996-06-14', 'P', 'Jl. Samanhudi no. 58', '082323534849', 'nurtami.14@gmail.com'),
('MHS2011012', '2020-11-12', 'Farda Nur Jihan', '2003-09-14', 'P', 'Jl. Samanhudi no. 58', '082313732746', 'fardajihan14@gmail.com'),
('MHS2011013', '2020-11-13', 'DINDA ARI THEANEKAWATI', '2003-04-15', 'P', 'JL.SUKROSONO NO.28', '089619558787', 'dindaat03@gmail,com'),
('MHS2011014', '2020-11-14', 'Linuwih', '1962-05-15', 'P', 'Jl.Sawo Pedagangan Rt 02/01 kec.dukuhwaru kab. Tegal', '089654815455', ''),
('MHS2011015', '2020-11-15', 'Besta Risqya Fiesta', '2003-08-15', 'P', 'Ds Kaligayam', 'NULL', ''),
('MHS2011016', '2020-11-16', 'Wahyuningsih', '1967-10-15', 'P', 'JLN.Saparua No.30 RT.4 RW.9 Panggung Tegal Timur', '085879312625', '-'),
('MHS2011017', '2020-11-17', 'Mundiroh', '1948-03-16', 'P', 'Slarang Kidul Rt 05 Rw 02', 'NULL', ''),
('MHS2011018', '2020-11-18', 'KASIYATI', '1962-04-16', 'P', 'Jl.Prof.Buyahamka no 21 Rt 03 Rw 03 Margadana', '0817286378', ''),
('MHS2011019', '2020-11-19', 'Siska Aulia Utami', '2003-06-16', 'P', 'Jln. Pagedangan', 'NULL', 'auliasiska818@gmail.com'),
('MHS2011020', '2020-11-20', 'BALKIS ARIFATUL FADIA', '2003-07-16', 'P', 'Jalan Pangeran Antasari RT 5/RW 3 No. 45', 'NULL', 'arifatulfadia.1620@gmail.com'),
('MHS2011021', '2020-11-21', 'Eko Witati Agustina', '1975-08-16', 'P', 'Pagongan', '085700899468', ''),
('MHS2011022', '2020-11-22', 'Siti Nurasih', '1975-08-17', 'P', 'Jl.Kemuning 1 Ujungrusi Rt 19/02 kec.adiwerna kab. Tegal', '082325132430', ''),
('MHS2011023', '2020-11-23', 'Darti', '1980-07-18', 'P', 'Jl.Raya Bedug Pangkah Tegal', '089564792736', ''),
('MHS2011024', '2020-11-24', 'TETI SETIOWATI', '1973-08-18', 'P', 'PANGKAH', '085975260673', ''),
('MHS2011025', '2020-11-25', 'Ayasya Almira', '2016-09-18', 'P', 'jl. Raya Suradadi No 52 Rt 02 Rw 02, Desa Suradadi.', 'NULL', 'ayasyaalmira@gmail.com'),
('MHS2011026', '2020-11-26', 'ALIFA SIDQIA', '2018-05-19', 'P', 'Jalan Pangeran Antasari RT 5/RW 3 No. 45', 'NULL', ''),
('MHS2011027', '2020-11-27', 'SAKINAH UMI PRAMITA', '2003-07-19', 'P', 'Jln.Sangir II NO.30 RT/RW 05/11', '081807329142', 'sakinahumi1924@gmail.com'),
('MHS2011028', '2020-11-28', 'EUNIKE NATHANIA FOSSETA', '2007-04-20', 'P', 'TEGAL', '083802687677', ''),
('MHS2011029', '2020-11-29', 'Nurhayati', '1983-07-20', 'P', 'jl. Raya Suradadi No 52 Rt 02 Rw 02, Desa Suradadi.', '0895358453950', 'nurhayati09@yahoo.com'),
('MHS2011030', '2020-11-30', 'Suci Ramadhani', '2005-10-20', 'P', 'Jl. Flores RT09/09 Kel.Panggung Kec.Tegal Timur Kota Tegal', '087808160683', 'suciramadhani20@gmail.com'),
('MHS2012001', '2020-12-01', 'Safira Wahyu Putri Nanda', '1999-03-21', 'P', 'Jl. P. Kemerdekaan Gg. 15 No. 19', 'NULL', '-'),
('MHS2012002', '2020-12-02', 'ANIS APRIANI', '1980-04-21', 'P', 'Desa Pendawa RT 004 RW 001 Kec.Lebaksiu Kab.Tegal', '085742184475', '-'),
('MHS2012003', '2020-12-03', 'Endang', '1983-10-21', 'P', 'Jl banyuwangi Rt09 Rw01', '0857746461909', 'maswaridi2707@gmail.com'),
('MHS2012004', '2020-12-04', 'TANTI DEWI PURWANTI', '1978-02-22', 'P', 'JL. BEO GANG BEO, KELURAHAN RANDUGUNTING', 'NULL', ''),
('MHS2012005', '2020-12-05', 'ALMAS DHIYAH ZAHIRA', '2008-11-22', 'P', 'Jl.FLORES GG.3 RT.04 RW.09 PANGGUNG ', '08975841887', ''),
('MHS2012006', '2020-12-06', 'NUR AZIZAH', '1991-02-23', 'P', 'Jln.Sangir II NO.30 RT/RW 05/11', 'NULL', '-'),
('MHS2012007', '2020-12-07', 'ALFIYAH', '1966-05-23', 'P', 'JL.KLEBEN RT 02 RW 01 DESA GEMBONG KULON TALANG TEGAL', '089525328725', ''),
('MHS2012008', '2020-12-08', 'SUMARSIH', '1970-08-23', 'P', 'SLAWI WETAN ', '083876534213', 'sumarsih178@gmail.com '),
('MHS2012009', '2020-12-09', 'Erni Setyowati', '1980-09-23', 'P', 'Jl.Flores Gang 2 Rt 09/09 kec.tegal timur kota tegal', '087820807589', 'ernisetyowati@gmail.com'),
('MHS2012010', '2020-12-10', 'Sofaeni', '1974-04-24', 'P', 'Rt 12/ Rw02 Desa Tembok Kidul kecamatan Adiwerna KAB. Tegal ', '085385574144', ''),
('MHS2012011', '2020-12-11', 'AGNI ANASTASYHA', '2006-08-24', 'P', 'JLN. CANDI MONCOL', 'NULL', 'agni88@gmail.com'),
('MHS2012012', '2020-12-12', 'ARINA NUR IFADANIYATI', '1993-09-25', 'P', 'Desa Lemahduwur Rt 11 Rw 02, Adiwerna - Kab. Tegal', '085600284249', 'arin.febriani@gmail.com'),
('MHS2012013', '2020-12-13', 'Tuti Handayani', '1979-12-25', 'P', 'Jl.Serayu RT 19 RW 07 No. 7 Slawi Wetan', '082223044260', ''),
('MHS2012014', '2020-12-14', 'Fadia Nufinikita', '2003-04-26', 'P', 'Jl.Raya Sulang,Mejasem Timur RT 05/06', '087727579159', 'fadiaann26@gmail.com'),
('MHS2012015', '2020-12-15', 'YUNI HARTATI', '1977-06-26', 'P', 'SURADADI', '085697412360', ''),
('MHS2012016', '2020-12-16', 'MULYATI', '1972-07-26', 'P', 'JLN. CANDI MONCOL', 'NULL', 'tinocesti22@gmail.com'),
('MHS2012017', '2020-12-17', 'Dewi Purwaningsih', '1979-02-27', 'P', 'Jl. Serayu RT 2 RW 4, Desa Selapura, Kec. Dukuhwaru, Kab. Tegal', '085640244454', 'nengnaurah8@gmail.com'),
('MHS2012018', '2020-12-18', 'Futykhatul Rizqi', '1998-06-27', 'P', 'Jl.Mbah Bregas 40 Sidakaton Rt 02/09 Kec.Dukuhturi Kab.Tegal', '085875861625', 'FutykhaRzq@Gmail.com'),
('MHS2012019', '2020-12-19', 'SRI RAHAYU', '1975-10-27', 'P', 'TEGAL', 'NULL', ''),
('MHS2012020', '2020-12-20', 'RUSTIAWATI', '1974-12-27', 'P', 'Jalan Pangeran Antasari RT 5/RW 3 No. 45', 'NULL', 'rustiawati@gmail.com'),
('MHS2012021', '2020-12-21', 'FITRI NUR FEBRIANI', '1997-02-28', 'P', 'Desa Lemahduwur Rt 11 Rw 02, Adiwerna - Kab. Tegal', 'NULL', ''),
('MHS2012022', '2020-12-22', 'WARCHAMAH', '1979-07-28', 'P', 'Desa Jatilawang Kec. Kramat Kab. Tegal', '087730114964', ''),
('MHS2012023', '2020-12-23', 'RODIYAH', '1965-08-28', 'P', 'Desa Lemahduwur Rt 11 Rw 02, Adiwerna - Kab. Tegal', '085328301556', ''),
('MHS2012024', '2020-12-24', 'Yulia Trisnawati', '2003-07-29', 'P', 'Jl. Flores RT09/09 Kel.Panggung Kec.Tegal Timur Kota Tegal', '088233254218', 'yuliatrisnawati610@gmail.com'),
('MHS2012025', '2020-12-25', 'Ulfifi Rikhayatiningsih ', '1969-07-30', 'P', 'Jl. Nakula No. 20', '085842849184', 'ifi.rikhayatiningsih@gmail.com'),
('MHS2012026', '2020-12-26', 'OLIFIA MARGARETO SANTOSO', '2004-03-31', 'P', 'JL.DUKU GANG 3', 'NULL', ''),
('MHS2012027', '2020-12-27', 'MURATIN', '1938-12-31', 'P', 'JLN. CANDI MONCOL', 'NULL', 'muratin11@gmail.com'),
('MHS2012028', '2020-12-28', 'Khilidin UY', '2002-08-09', 'L', 'Pesangonan', '019237471245', 'bonasPP@gmail.com'),
('MHS2012029', '2020-12-29', 'Khilidin R', '2003-01-02', 'L', 'Dukuhlo Slawi', '082716281823', 'bonasPP@gmail.com'),
('MHS2012030', '2020-12-30', 'Khilidin We', '2001-04-23', 'L', 'Brebes Ujung Wetan', '08271628182', 'izmibaihassqi23@gmail.com'),
('MHS2012031', '2020-12-31', 'Idham Bahri SS', '2002-08-09', 'L', 'pancenangon', '091823094778', 'komet@gmail.com'),
('MHS2101002', '2021-01-02', 'Bani', '2003-05-06', 'L', 'Brebes', '089765431234', 'Bani@gmail.com'),
('MHS2101003', '2021-01-03', 'Khilidin Pen', '2001-04-23', 'L', 'iuukhg', '068756746423', 'iuoihjhjbmvvf'),
('MHS2101004', '2021-01-04', 'Khilidin Pen', '2001-04-23', 'L', 'iuukhg', '068756746423', 'iuoihjhjbmvvf'),
('MHS2101005', '2021-01-05', 'Rojak', '2003-05-06', 'L', 'Brebes', '089765431234', 'Bani@gmail.com'),
('MHS2101006', '2021-01-06', 'Ninik', '2003-05-06', 'L', 'Brebes', '089765431234', 'Ninik@gmail.com'),
('MHS2101007', '2021-01-01', 'Dargo Sumar', '2005-01-22', 'L', 'Debong Wetan', '08612384129', 'bosku0417@gmail.com'),
('MHS2301001', '2023-01-13', 'Opan Sugo', '2003-08-17', 'L', 'Kebumen Jawa Tengah', '082716281823', 'bonasPP@gmail.com'),
('MHS2301002', '2023-01-15', 'Indra Kenz', '2003-05-02', 'L', 'Jakarta Selatan', '085638642971', 'IndraKenz@gmail.com');

--
-- Triggers `mahasiswa`
--
DELIMITER $$
CREATE TRIGGER `masuk_id_nim` BEFORE INSERT ON `mahasiswa` FOR EACH ROW BEGIN
DECLARE n_id_nim CHAR(10);
SELECT uid_mahasiswa(NEW.tanggal_masuk)INTO n_id_nim;
SET NEW.id_nim = n_id_nim;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambah_data_mhs` AFTER INSERT ON `mahasiswa` FOR EACH ROW BEGIN
INSERT INTO log_aktivitas (tanggal, tabel, aksi, keterangan)
VALUES (NEW.tanggal_masuk, 'Mahasiswa', 'Insert',
CONCAT('Masuk data baru dengan nama ', NEW.nama));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_mahasiswa` AFTER UPDATE ON `mahasiswa` FOR EACH ROW BEGIN
INSERT INTO log_aktivitas (tabel, aksi, keterangan)
VALUE('Mahasiswa', 'Update',
CONCAT('Telah dilakukan pengupdatean data pada mahasiswa : ', OLD.nama));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` char(10) NOT NULL,
  `tanggal_peminjaman` date NOT NULL DEFAULT current_timestamp(),
  `tanggal_pengembalian` date DEFAULT NULL,
  `denda` int(11) DEFAULT NULL,
  `pustakawan_id_pustakawan` char(10) NOT NULL,
  `mahasiswa_id_nim` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `tanggal_peminjaman`, `tanggal_pengembalian`, `denda`, `pustakawan_id_pustakawan`, `mahasiswa_id_nim`) VALUES
('P200100101', '2021-01-01', '2021-01-03', 0, 'PUS2001001', 'MHS2001001'),
('P200100102', '2021-01-02', '2021-01-04', 0, 'PUS2001002', 'MHS2001001'),
('P200100103', '2023-01-15', '2023-01-15', 0, 'PUS2001005', 'MHS2001001'),
('P200100104', '2023-01-15', NULL, NULL, 'PUS2001005', 'MHS2001001'),
('P200100201', '2021-01-03', '2021-01-05', 0, 'PUS2001003', 'MHS2001002'),
('P200100301', '2021-01-04', '2021-01-06', 0, 'PUS2001004', 'MHS2001003'),
('P200100401', '2021-01-05', '2021-01-07', 0, 'PUS2001005', 'MHS2001004'),
('P200100501', '2021-01-06', '2021-01-08', 0, 'PUS2001006', 'MHS2001005'),
('P200100601', '2021-01-07', '2021-01-09', 0, 'PUS2001007', 'MHS2001006'),
('P200100701', '2023-01-12', '2023-02-01', 5000, 'PUS2001010', 'MHS2001007'),
('P200100702', '2021-01-08', '2021-01-10', 0, 'PUS2001008', 'MHS2001007'),
('P200100801', '2021-01-09', '2021-01-11', 0, 'PUS2001009', 'MHS2001008'),
('P200100901', '2023-01-12', '2023-01-15', 0, 'PUS2001011', 'MHS2001009'),
('P200100902', '2021-01-10', '2021-01-12', 0, 'PUS2001010', 'MHS2001009'),
('P200101001', '2021-01-11', '2021-01-13', 0, 'PUS2301001', 'MHS2001010'),
('P200101101', '2021-01-12', '2021-01-14', 0, 'PUS2301002', 'MHS2001011'),
('P200101201', '2021-01-13', '2021-01-15', 0, 'PUS2301001', 'MHS2001012'),
('P200101301', '2021-01-14', '2021-01-16', 0, 'PUS2301002', 'MHS2001013'),
('P200101401', '2021-01-15', '2021-01-17', 0, 'PUS2301001', 'MHS2001014'),
('P200101501', '2021-01-16', '2021-01-18', 0, 'PUS2301002', 'MHS2001015'),
('P200101601', '2021-01-17', '2021-01-19', 0, 'PUS2301001', 'MHS2001016'),
('P200101701', '2021-01-18', '2021-01-20', 0, 'PUS2301002', 'MHS2001017'),
('P200101801', '2021-01-19', '2021-01-21', 0, 'PUS2001006', 'MHS2001018'),
('P200101901', '2021-01-20', '2021-01-22', 0, 'PUS2301001', 'MHS2001019'),
('P200102001', '2021-01-21', '2021-01-23', 0, 'PUS2001005', 'MHS2001020'),
('P200102101', '2021-01-22', '2021-01-24', 0, 'PUS2001001', 'MHS2001021'),
('P200102401', '2023-01-12', '2023-01-19', 5000, 'PUS2001003', 'MHS2001024'),
('P200300101', '2021-01-23', '2021-01-25', 0, 'PUS2001002', 'MHS2003001'),
('P200300102', '2021-01-24', '2021-01-26', 0, 'PUS2001003', 'MHS2003001'),
('P200300201', '2021-01-25', '2021-01-27', 0, 'PUS2001004', 'MHS2003002'),
('P200300301', '2021-01-26', '2021-01-28', 0, 'PUS2001005', 'MHS2003003'),
('P200300401', '2021-01-27', '2021-01-29', 0, 'PUS2001006', 'MHS2003004'),
('P200300501', '2021-01-28', '2021-01-30', 0, 'PUS2001007', 'MHS2003005'),
('P200300601', '2021-01-29', '2021-02-01', 0, 'PUS2001008', 'MHS2003006'),
('P200300701', '2021-01-30', '2021-02-02', 0, 'PUS2001009', 'MHS2003007'),
('P200300801', '2021-01-31', '2021-02-03', 0, 'PUS2001010', 'MHS2003008'),
('P200300901', '2021-02-01', '2021-02-04', 0, 'PUS2301001', 'MHS2003009'),
('P200301001', '2021-02-02', '2021-02-05', 0, 'PUS2301002', 'MHS2003010'),
('P200301101', '2021-02-03', '2021-02-06', 0, 'PUS2301001', 'MHS2003011'),
('P200301201', '2021-02-04', '2021-02-07', 0, 'PUS2301002', 'MHS2003012'),
('P200301301', '2021-02-05', '2021-02-08', 0, 'PUS2301001', 'MHS2003013'),
('P200301401', '2021-02-06', '2021-02-09', 0, 'PUS2301002', 'MHS2003014'),
('P200301501', '2021-02-07', '2021-02-10', 0, 'PUS2301001', 'MHS2003015'),
('P200301601', '2021-02-08', '2021-02-11', 0, 'PUS2301002', 'MHS2003016'),
('P200301701', '2021-02-09', '2021-02-12', 0, 'PUS2001006', 'MHS2003017'),
('P200301801', '2021-02-10', '2021-02-13', 0, 'PUS2301001', 'MHS2003018'),
('P200301901', '2021-02-11', '2021-02-14', 0, 'PUS2001005', 'MHS2003019'),
('P200302001', '2021-02-12', '2021-02-15', 0, 'PUS2001001', 'MHS2003020'),
('P200302101', '2021-02-13', '2021-02-16', 0, 'PUS2001002', 'MHS2003021'),
('P200302201', '2021-02-14', '2021-02-17', 0, 'PUS2001003', 'MHS2003022'),
('P200302301', '2021-02-15', '2021-02-18', 0, 'PUS2001004', 'MHS2003023'),
('P200302401', '2021-02-16', '2021-02-19', 0, 'PUS2001005', 'MHS2003024'),
('P200302501', '2021-02-17', '2021-02-20', 0, 'PUS2001006', 'MHS2003025'),
('P200302601', '2021-02-18', '2021-02-21', 0, 'PUS2001007', 'MHS2003026'),
('P200302701', '2021-02-19', '2021-02-22', 0, 'PUS2001008', 'MHS2003027'),
('P200400101', '2021-02-20', '2021-02-23', 0, 'PUS2001009', 'MHS2004001'),
('P200400201', '2021-02-21', '2021-02-24', 0, 'PUS2001010', 'MHS2004002'),
('P200400301', '2021-02-22', '2021-02-25', 0, 'PUS2301001', 'MHS2004003'),
('P200400401', '2021-02-23', '2021-02-26', 0, 'PUS2301002', 'MHS2004004'),
('P200400501', '2021-02-24', '2021-02-27', 0, 'PUS2301001', 'MHS2004005'),
('P200400601', '2021-02-25', '2021-02-28', 0, 'PUS2301002', 'MHS2004006'),
('P200400701', '2021-02-26', '2021-03-01', 0, 'PUS2301001', 'MHS2004007'),
('P200400801', '2021-02-27', '2021-03-02', 0, 'PUS2301002', 'MHS2004008'),
('P200400901', '2021-02-28', '2021-03-03', 0, 'PUS2301001', 'MHS2004009'),
('P200401001', '2021-03-01', '2021-03-04', 0, 'PUS2301002', 'MHS2004010'),
('P200401101', '2021-03-02', '2021-03-05', 0, 'PUS2001006', 'MHS2004011'),
('P200401201', '2021-03-03', '2021-03-06', 0, 'PUS2301001', 'MHS2004012'),
('P200401301', '2021-03-04', '2021-03-07', 0, 'PUS2001005', 'MHS2004013'),
('P200401401', '2021-03-05', '2021-03-08', 0, 'PUS2001001', 'MHS2004014'),
('P200401501', '2021-03-06', '2021-03-09', 0, 'PUS2001002', 'MHS2004015'),
('P200401601', '2021-03-07', '2021-03-10', 0, 'PUS2001003', 'MHS2004016'),
('P200401701', '2021-03-08', '2021-03-11', 0, 'PUS2001004', 'MHS2004017'),
('P200401801', '2021-03-09', '2021-03-12', 0, 'PUS2001005', 'MHS2004018'),
('P200401901', '2021-03-10', '2021-03-13', 0, 'PUS2001006', 'MHS2004019'),
('P200402001', '2021-03-11', '2021-03-14', 0, 'PUS2001007', 'MHS2004020'),
('P200402101', '2021-03-12', '2021-03-15', 0, 'PUS2001008', 'MHS2004021'),
('P200402201', '2021-03-13', '2021-03-16', 0, 'PUS2001009', 'MHS2004022'),
('P200402301', '2021-01-01', '2021-01-03', 0, 'PUS2001010', 'MHS2004023'),
('P200402401', '2021-01-02', '2021-01-04', 0, 'PUS2301001', 'MHS2004024'),
('P200402501', '2021-01-03', '2021-01-05', 0, 'PUS2301002', 'MHS2004025'),
('P200402601', '2021-01-04', '2021-01-06', 0, 'PUS2301001', 'MHS2004026'),
('P200402701', '2021-01-05', '2021-01-07', 0, 'PUS2301002', 'MHS2004027'),
('P200402801', '2021-01-06', '2021-01-08', 0, 'PUS2301001', 'MHS2004028'),
('P200500101', '2021-01-07', '2021-01-09', 0, 'PUS2301002', 'MHS2005001'),
('P200500201', '2021-01-08', '2021-01-10', 0, 'PUS2301001', 'MHS2005002'),
('P200500301', '2021-01-09', '2021-01-11', 0, 'PUS2301002', 'MHS2005003'),
('P200500401', '2021-01-10', '2021-01-12', 0, 'PUS2001006', 'MHS2005004'),
('P200500501', '2021-01-11', '2021-01-13', 0, 'PUS2301001', 'MHS2005005'),
('P200500601', '2021-01-12', '2021-01-14', 0, 'PUS2001005', 'MHS2005006'),
('P200500701', '2021-01-13', '2021-01-15', 0, 'PUS2001001', 'MHS2005007'),
('P200500801', '2021-01-14', '2021-01-16', 0, 'PUS2001002', 'MHS2005008'),
('P200500901', '2021-01-15', '2021-01-17', 0, 'PUS2001003', 'MHS2005009'),
('P200501001', '2021-01-16', '2021-01-18', 0, 'PUS2001004', 'MHS2005010'),
('P200501101', '2021-01-17', '2021-01-19', 0, 'PUS2001005', 'MHS2005011'),
('P200501201', '2021-01-18', '2021-01-20', 0, 'PUS2001006', 'MHS2005012'),
('P200501301', '2021-01-19', '2021-01-21', 0, 'PUS2001007', 'MHS2005013'),
('P200501401', '2021-01-20', '2021-01-22', 0, 'PUS2001008', 'MHS2005014'),
('P200501501', '2021-01-21', '2021-01-23', 0, 'PUS2001009', 'MHS2005015'),
('P200501601', '2021-01-22', '2021-01-24', 0, 'PUS2001010', 'MHS2005016'),
('P200501701', '2021-01-23', '2021-01-25', 0, 'PUS2301001', 'MHS2005017'),
('P200501801', '2021-01-24', '2021-01-26', 0, 'PUS2301002', 'MHS2005018'),
('P200501901', '2021-01-25', '2021-01-27', 0, 'PUS2301001', 'MHS2005019'),
('P200502001', '2021-01-26', '2021-01-28', 0, 'PUS2301002', 'MHS2005020'),
('P200502101', '2021-01-27', '2021-01-29', 0, 'PUS2301001', 'MHS2005021'),
('P200502201', '2021-01-28', '2021-01-30', 0, 'PUS2301002', 'MHS2005022'),
('P200502301', '2021-01-29', '2021-02-01', 0, 'PUS2301001', 'MHS2005023'),
('P200502401', '2021-01-30', '2021-02-02', 0, 'PUS2301002', 'MHS2005024'),
('P200502501', '2021-01-31', '2021-02-03', 0, 'PUS2001006', 'MHS2005025'),
('P200502601', '2021-02-01', '2021-02-04', 0, 'PUS2301001', 'MHS2005026'),
('P200502701', '2021-02-02', '2021-02-05', 0, 'PUS2001005', 'MHS2005027'),
('P200502801', '2021-02-03', '2021-02-06', 0, 'PUS2001001', 'MHS2005028'),
('P200700101', '2021-02-04', '2021-02-07', 0, 'PUS2001002', 'MHS2007001'),
('P200700201', '2021-02-05', '2021-02-08', 0, 'PUS2001003', 'MHS2007002'),
('P200700301', '2021-02-06', '2021-02-09', 0, 'PUS2001004', 'MHS2007003'),
('P200700401', '2021-02-07', '2021-02-10', 0, 'PUS2001005', 'MHS2007004'),
('P200700501', '2021-02-08', '2021-02-11', 0, 'PUS2001006', 'MHS2007005'),
('P200700601', '2021-02-09', '2021-02-12', 0, 'PUS2001007', 'MHS2007006'),
('P200700701', '2021-02-10', '2021-02-13', 0, 'PUS2001008', 'MHS2007007'),
('P200700801', '2021-02-11', '2021-02-14', 0, 'PUS2001009', 'MHS2007008'),
('P200700901', '2021-02-12', '2021-02-15', 0, 'PUS2001010', 'MHS2007009'),
('P200701001', '2021-02-13', '2021-02-16', 0, 'PUS2301001', 'MHS2007010'),
('P200701101', '2021-02-14', '2021-02-17', 0, 'PUS2301002', 'MHS2007011'),
('P200701201', '2021-02-15', '2021-02-18', 0, 'PUS2301001', 'MHS2007012'),
('P200701301', '2021-02-16', '2021-02-19', 0, 'PUS2301002', 'MHS2007013'),
('P200701401', '2021-02-17', '2021-02-20', 0, 'PUS2301001', 'MHS2007014'),
('P200701501', '2021-02-18', '2021-02-21', 0, 'PUS2301002', 'MHS2007015'),
('P200701601', '2021-02-19', '2021-02-22', 0, 'PUS2301001', 'MHS2007016'),
('P200701701', '2021-02-20', '2021-02-23', 0, 'PUS2301002', 'MHS2007017'),
('P200701801', '2021-02-21', '2021-02-24', 0, 'PUS2001006', 'MHS2007018'),
('P200701901', '2021-02-22', '2021-02-25', 0, 'PUS2301001', 'MHS2007019'),
('P200702001', '2021-02-23', '2021-02-26', 0, 'PUS2001005', 'MHS2007020');

--
-- Triggers `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `denda` BEFORE UPDATE ON `peminjaman` FOR EACH ROW BEGIN
DECLARE denda INT;
DECLARE rupiah INT DEFAULT 0;
IF NEW.tanggal_pengembalian>CURRENT_DATE+5 THEN SET rupiah = 5000;
END IF;
SET NEW.denda = rupiah;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `peminjamanQ` BEFORE INSERT ON `peminjaman` FOR EACH ROW BEGIN
DECLARE peminjamanT VARCHAR(10);
SELECT uid_peminjaman(NEW.mahasiswa_id_nim) INTO peminjamanT;
SET NEW.id_peminjaman = peminjamanT;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambah_peminjaman` AFTER INSERT ON `peminjaman` FOR EACH ROW BEGIN
INSERT INTO log_aktivitas (tanggal,tabel,aksi,keterangan)
VALUES(NEW.tanggal_peminjaman,'TPeminjaman', 'Insert',
CONCAT('Masuk Peminjaman baru dengan ID PINJAM :', NEW.id_peminjaman));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_peminjaman` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
INSERT INTO log_aktivitas (tabel,aksi,keterangan)
VALUES('TPeminjaman', 'Update',
CONCAT('Telah dilakukan pengupdatean data pada ID PINJAM :', OLD.id_peminjaman));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pustakawan`
--

CREATE TABLE `pustakawan` (
  `id_pustakawan` char(10) NOT NULL,
  `tanggal_masuk` date NOT NULL DEFAULT current_timestamp(),
  `nama` varchar(40) NOT NULL,
  `jenis_kelamin` char(1) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `alamat` varchar(100) NOT NULL,
  `no_hp` varchar(14) NOT NULL,
  `email` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pustakawan`
--

INSERT INTO `pustakawan` (`id_pustakawan`, `tanggal_masuk`, `nama`, `jenis_kelamin`, `tanggal_lahir`, `alamat`, `no_hp`, `email`) VALUES
('PUS2001001', '2020-01-01', 'Mochammad Febrian Maulana Hesda', 'L', '2003-02-26', 'Brebes', '085640556275', 'febriandjokam354@gmail.com'),
('PUS2001002', '2020-01-02', 'Eva Dwi Meliana', 'P', '2002-01-12', 'Brebes', '081770272981', 'nrlinayah354@gmail.com'),
('PUS2001003', '2020-01-03', 'Izmi Baihaqi Annur', 'L', '2002-01-13', 'Tegal', '08271628182', 'izmibaihaqi23@gmail.com'),
('PUS2001004', '2020-01-04', 'Adi Sucipto', 'L', '2002-01-14', 'Tegal', '08118881838', 'adigemash@gmail.com'),
('PUS2001005', '2020-01-05', 'Nevi Nur Aisyah', 'P', '2002-01-15', 'Brebes', '085712349005', 'bosku0417@gmail.com'),
('PUS2001006', '2020-01-06', 'Nur Rohman', 'L', '2002-01-16', 'Brebes', '085713050749', 'rohmanuyeoke@gmail.com'),
('PUS2001007', '2020-01-07', 'Kholidina Fiha', 'L', '2002-01-17', 'Tegal', '012345678910', 'hehehe@gmail.com'),
('PUS2001008', '2020-01-08', 'Atha Tatata', 'P', '2002-01-18', 'Tegal', '085640556276', 'febriandjokam354@gmail.com'),
('PUS2001009', '2020-01-09', 'Gading Gisel', 'L', '2002-01-19', 'Brebes', '081770272982', 'nrlinayah354@gmail.com'),
('PUS2001010', '2020-01-10', 'Naufal Najwa', 'L', '2002-01-20', 'Brebes', '08271628183', 'izmibaihaqi23@gmail.com'),
('PUS2001011', '2020-01-11', 'Faizin', 'L', '2002-01-21', 'Tegal', '08118881839', 'adigemash@gmail.com'),
('PUS2001012', '2020-01-12', 'Bintang', 'L', '2002-01-22', 'Tegal', '085712349006', 'bosku0417@gmail.com'),
('PUS2001013', '2020-01-13', 'Dimas Antoni', 'L', '2002-01-23', 'Brebes', '085713050750', 'rohmanuyeoke@gmail.com'),
('PUS2001014', '2020-01-14', 'Jonathan', 'L', '2002-01-24', 'Brebes', '012345678911', 'hehehe@gmail.com'),
('PUS2001015', '2020-01-15', 'Hendrawan', 'L', '2002-01-25', 'Tegal', '085640556277', 'febriandjokam354@gmail.com'),
('PUS2301001', '2023-01-12', 'Katika Dev', 'P', '2001-04-23', 'Tegal ', '088123461899', 'kartika@gmail.com'),
('PUS2301002', '2023-01-12', 'Indra Sugiarto', 'L', '2003-04-04', 'Brebes Lor', '089130586498', 'indraSug@gmail.com'),
('PUS2301003', '2023-01-15', 'Rendy Saputra', 'L', '2003-04-01', 'Grogol Tegal', '085778423097', 'rendy@gmail.com');

--
-- Triggers `pustakawan`
--
DELIMITER $$
CREATE TRIGGER `masuk_id_pustakawan` BEFORE INSERT ON `pustakawan` FOR EACH ROW BEGIN
DECLARE a_id_pustakawan CHAR(10);
SELECT uid_pustakawan(NEW.tanggal_masuk) INTO a_id_pustakawan;
SET NEW.id_pustakawan = a_id_pustakawan;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambah_pustakawan` AFTER INSERT ON `pustakawan` FOR EACH ROW BEGIN
INSERT INTO log_aktivitas (tanggal,tabel,aksi,keterangan)
VALUES(NEW.tanggal_masuk,'Pustakawan', 'Insert', 
CONCAT('Masuk Pustakawan Baru dengan Nama : ', NEW.nama));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_pustakawan` AFTER UPDATE ON `pustakawan` FOR EACH ROW BEGIN
INSERT INTO log_aktivitas (tabel, aksi, keterangan)
VALUE('Pustakawan', 'Update',
CONCAT('Telah dilakukan pengupdatean data pada pustakawan : ', OLD.nama));
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indexes for table `detail_peminjaman`
--
ALTER TABLE `detail_peminjaman`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `detail_peminjaman_buku_fk` (`buku_id_buku`),
  ADD KEY `detail_peminjaman_peminjaman_fk` (`peminjaman_id_peminjaman`);

--
-- Indexes for table `log_aktivitas`
--
ALTER TABLE `log_aktivitas`
  ADD PRIMARY KEY (`nomor`);

--
-- Indexes for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`id_nim`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `peminjaman_mahasiswa_fk` (`mahasiswa_id_nim`),
  ADD KEY `peminjaman_pustakawan_fk` (`pustakawan_id_pustakawan`);

--
-- Indexes for table `pustakawan`
--
ALTER TABLE `pustakawan`
  ADD PRIMARY KEY (`id_pustakawan`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_mahasiswa_fk` FOREIGN KEY (`mahasiswa_id_nim`) REFERENCES `mahasiswa` (`id_nim`),
  ADD CONSTRAINT `peminjaman_pustakawan_fk` FOREIGN KEY (`pustakawan_id_pustakawan`) REFERENCES `pustakawan` (`id_pustakawan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
