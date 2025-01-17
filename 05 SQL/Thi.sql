﻿CREATE DATABASE QL_NHANVIEN
USE QL_NHANVIEN
CREATE TABLE CHUCVU
(
MACV NVARCHAR(10) NOT NULL PRIMARY KEY,
TENCV NVARCHAR(50) NOT NULL,
PHUCAPCV INT
)

CREATE TABLE PHONGBAN
(
MAPHONGBAN NVARCHAR(10) NOT NULL PRIMARY KEY,
TENPB NVARCHAR(50) NOT NULL,
DIACHI NVARCHAR(50)
)
CREATE TABLE NHANVIEN
(
MANV NVARCHAR(10) NOT NULL PRIMARY KEY,
HOTENNV NVARCHAR(50) NOT NULL,
MACV NVARCHAR(10) NOT NULL,
NGAYSINH DATE,
LUONGCB INT NOT NULL,
MAPHONGBAN NVARCHAR(10) NOT NULL,
DIACHINV NVARCHAR(50),
DIENTHOAI NVARCHAR(15),
CONSTRAINT FK_NV_PB FOREIGN KEY (MAPHONGBAN) REFERENCES PHONGBAN(MAPHONGBAN),
CONSTRAINT FK_NV_CV FOREIGN KEY (MACV) REFERENCES CHUCVU(MACV)
)

CREATE TABLE HOADON
(
MAHOADON NVARCHAR(10) NOT NULL,
NGAYLAP DATE NOT NULL,
MANV NVARCHAR(10) NOT NULL,
MAHANGHOA NVARCHAR(10) NOT NULL,
SOLUONGBAN INT NOT NULL,
PRIMARY KEY (MAHOADON,MAHANGHOA),
CONSTRAINT FK_HD_NV FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
)

/*------------Thêm dữ liệu ------------*/

INSERT INTO PHONGBAN VALUES ('PB01',N'Ban Tài Chính','111 Đường số 1, Q.Bình Thạnh, TPHCM')
INSERT INTO PHONGBAN VALUES ('PB02',N'Ban Kế Hoạch','222 Đường số 2, Q.Bình Thạnh, TPHCM')
INSERT INTO PHONGBAN VALUES ('PB03',N'Ban Marketing','333 Đường số 3, Q.Bình Thạnh, TPHCM')

INSERT INTO CHUCVU VALUES ('CV01',N'Giám đốc',10000000)
INSERT INTO CHUCVU VALUES ('CV02',N'Quản lý',5000000)
INSERT INTO CHUCVU VALUES ('CV03',N'Nhân viên',2000000)

INSERT INTO NHANVIEN VALUES ('NV01',N'Nguyễn Văn An',N'CV02','1990-01-01',5000000,'PB02',N'100 Đường số 5, Q.1, TPHCM','0909123456')
INSERT INTO NHANVIEN VALUES ('NV02',N'Nguyễn Thị Bích',N'CV01','1995-01-01',6000000,'PB02',N'100 Đường số 6, Q.1, TPHCM','0909123456')
INSERT INTO NHANVIEN VALUES ('NV03',N'Nguyễn Văn Hùng',N'CV03','2000-01-01',7000000,'PB02',N'100 Đường số 7, Q.1, TPHCM','0909123456')
INSERT INTO NHANVIEN VALUES ('NV04',N'Trần Diệu Nhi',N'CV01','1985-01-01',5500000,'PB01',N'100 Đường số 8, Q.1, TPHCM','0909123456')
INSERT INTO NHANVIEN VALUES ('NV05',N'Phạm Minh Đăng',N'CV02','1972-01-01',6500000,'PB01',N'100 Đường số 9, Q.1, TPHCM','0909123456')
INSERT INTO NHANVIEN VALUES ('NV06',N'Nguyễn Anh Đào',N'CV03','1984-01-01',8000000,'PB03',N'100 Đường số 10, Q.1, TPHCM','0909123456')
INSERT INTO NHANVIEN VALUES ('NV07',N'Trần Văn Hưng',N'CV02','1976-01-01',7500000,'PB03',N'100 Đường số 11, Q.1, TPHCM','0909123456')
INSERT INTO NHANVIEN VALUES ('NV08',N'Nguyễn Văn Hoàng',N'CV03','2000-01-01',4000000,'PB02',N'100 Đường số 8, Q.1, TPHCM','0909123456')

INSERT INTO HOADON VALUES ('HD01','2022-07-30','NV01','H01',10)
INSERT INTO HOADON VALUES ('HD01','2022-06-30','NV02','H02',50)
INSERT INTO HOADON VALUES ('HD01','2022-05-30','NV03','H03',20)
INSERT INTO HOADON VALUES ('HD02','2022-06-20','NV04','H01',30)
INSERT INTO HOADON VALUES ('HD03','2022-07-20','NV03','H02',40)
INSERT INTO HOADON VALUES ('HD03','2022-05-20','NV02','H01',15)
INSERT INTO HOADON VALUES ('HD04','2022-04-10','NV05','H03',25)
INSERT INTO HOADON VALUES ('HD04','2022-05-10','NV06','H02',5)
INSERT INTO HOADON VALUES ('HD04','2022-06-10','NV07','H01',30)
INSERT INTO HOADON VALUES ('HD05','2022-07-15','NV04','H02',20)

/* CÂU 2 :danh sách các nhân viên thuộc ban Tài Chính hoặc ban Kế hoạch có tuổi dưới 35 */

SELECT MANV,HOTENNV,TENPB,2022-YEAR(NGAYSINH) AS TUOI 
FROM NHANVIEN AS NV 
INNER JOIN PHONGBAN AS PB ON NV.MAPHONGBAN=PB.MAPHONGBAN
WHERE (NV.MAPHONGBAN = 'PB01'OR NV.MAPHONGBAN = 'PB02') AND YEAR(NGAYSINH) > (2022-35)

/* CÂU 3 : danh sách 3 nhân viên có lương cao nhất */

SELECT TOP 3 MANV,HOTENNV,NGAYSINH,TENPB,LUONGCB
FROM NHANVIEN AS NV 
INNER JOIN PHONGBAN AS PB ON NV.MAPHONGBAN=PB.MAPHONGBAN
WHERE HOTENNV LIKE N'NGUYỄN%' AND NV.MAPHONGBAN='PB02'
ORDER BY LUONGCB DESC

/* CÂU 4 : đưa ra 1 nhân viên có lương căn bản thấp nhất ở phòng Tài Chính */

SELECT TOP 1 MANV,HOTENNV,TENPB,LUONGCB
FROM NHANVIEN AS NV 
INNER JOIN PHONGBAN AS PB ON NV.MAPHONGBAN=PB.MAPHONGBAN
WHERE NV.MAPHONGBAN='PB01'
ORDER BY LUONGCB ASC

/* CÂU 5 : đưa ra 2 phòng ban có tổng lương thấp nhất */

SELECT TOP 2 TENPB, SUM(LUONGCB)AS 'TONG LUONG'
FROM NHANVIEN AS NV 
INNER JOIN PHONGBAN AS PB ON NV.MAPHONGBAN=PB.MAPHONGBAN
GROUP BY TENPB
ORDER BY [TONG LUONG] ASC

/* CÂU 6 : tạo VIEW đưa ra số lượng hóa đơn của các nhân viên thuộc ban Kế hoạch */

CREATE VIEW VIEW_HOADON_NHANVIEN AS 
(
SELECT NV.MANV AS N'MÃ NV',HOTENNV AS N'HỌ TÊN',COUNT(*) AS N'SỐ HÓA ĐƠN'
FROM NHANVIEN AS NV
INNER JOIN HOADON AS HD ON NV.MANV=HD.MANV
GROUP BY NV.MANV,HOTENNV
)
/*ví dụ*/
SELECT * FROM VIEW_HOADON_NHANVIEN

/* CÂU 7 : tạo PROC đưa ra danh sách bảng lương thực lĩnh nhân viên thuộc ban bất kỳ */

CREATE PROC THUC_LINH
@MAPB NVARCHAR(10)
AS
SELECT MANV, HOTENNV,NGAYSINH,TENPB,LUONGCB+PHUCAPCV AS N'THUC LINH'
FROM NHANVIEN AS NV
INNER JOIN CHUCVU AS CV ON NV.MACV = CV.MACV
INNER JOIN PHONGBAN AS PB ON NV.MAPHONGBAN=PB.MAPHONGBAN
WHERE PB.MAPHONGBAN = @MAPB
/*ví dụ*/
EXEC THUC_LINH 'PB01'
EXEC THUC_LINH 'PB02'
EXEC THUC_LINH 'PB03'

/* CÂU 8 : tạo PROC đưa ra bảng tổng hợp số lượng hóa đơn của 1 nhân viên bất kỳ */
CREATE PROC PROC_TIM_TONG_HOA_DON
@MANV NVARCHAR(10)
AS
SELECT NV.MANV AS N'MÃ NV',HOTENNV AS N'HỌ TÊN',COUNT(*) AS N'TỔNG HÓA ĐƠN'
FROM NHANVIEN AS NV
INNER JOIN HOADON AS HD ON NV.MANV=HD.MANV
WHERE NV.MANV = @MANV
GROUP BY NV.MANV,HOTENNV
/*ví dụ*/
EXEC PROC_TIM_TONG_HOA_DON 'NV01'
EXEC PROC_TIM_TONG_HOA_DON 'NV02'
EXEC PROC_TIM_TONG_HOA_DON 'NV03'
EXEC PROC_TIM_TONG_HOA_DON 'NV05'

/* CÂU 9 : tạo TRIGGER cho bảng NHANVIEN có chức năng không cho thay đổi Lương CB */

CREATE TRIGGER TR_NoChangeLuongCB ON NHANVIEN
FOR
UPDATE
AS BEGIN
	IF UPDATE(LUONGCB)
	BEGIN 
	PRINT N'----------- không thể đổi lương cơ bản -----------';
	ROLLBACK TRAN
	END
END
/*Ví dụ*/
SELECT * FROM NHANVIEN WHERE MANV = 'NV01'
UPDATE NHANVIEN SET LUONGCB = 0 WHERE MANV='NV01'
UPDATE NHANVIEN SET DIACHINV = N'Số 5, đường số 5' WHERE MANV='NV01'


/* CÂU 10 : tạo TRIGGER có chức năng khi xóa 1 nhân viên nào đó 
thì tất cả các dữ liệu liên quan ở bảng HOADON cũng bị xóa */


/*Ví dụ trước khi tạo trigger*/
DELETE FROM NHANVIEN WHERE MANV = 'NV01'
/*Tạo trigger*/
CREATE TRIGGER TR_XoaNhanVien ON NHANVIEN
INSTEAD OF
DELETE
AS 
BEGIN
DELETE FROM HOADON WHERE MANV = (SELECT MANV FROM DELETED)
DELETE FROM NHANVIEN WHERE MANV = (SELECT MANV FROM DELETED)
END
/*Ví dụ*/
DELETE FROM NHANVIEN WHERE MANV = 'NV01'
DELETE FROM NHANVIEN WHERE MANV = 'NV02'
SELECT * FROM NHANVIEN
SELECT * FROM HOADON