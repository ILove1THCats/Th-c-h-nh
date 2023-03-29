use QuanLyDeAn2

/*Them bang*/
CREATE TABLE PHANCONG (
    MaNV varchar(9) NOT NULL,
    MaDA varchar(2) NOT NULL,
    ThoiGian numeric(18,0),
    PRIMARY KEY (MaNV, MaDA)
)

CREATE TABLE NHANVIEN (
    MaNV varchar(9) NOT NULL PRIMARY KEY,
    HoNV nvarchar(15),
    TenLot nvarchar(30),
    TenNV nvarchar(30),
    NgSinh smalldatetime,
    DiaChi nvarchar(150),
    Phai nvarchar(3),
    Luong numeric(18,0),
    Phong varchar(2)
);

CREATE TABLE THANNHAN (
    MaNV varchar(9) NOT NULL,
    TenTN varchar(20) NOT NULL,
    NgaySinh smalldatetime,
    Phai varchar(3),
    QuanHe varchar(15),
    PRIMARY KEY (MaNV, TenTN)
)

CREATE TABLE PHONGBAN (
    MaPhg varchar(2) NOT NULL PRIMARY KEY,
    TenPhg nvarchar(20)
)

CREATE TABLE DEAN (
    MaDA varchar(2) NOT NULL PRIMARY KEY,
    TenDA nvarchar(50),
    DDiemDA varchar(20)
)
ALTER TABLE PHONGBAN 
ALTER COLUMN TenPhg nvarchar(30)

ALTER TABLE DEAN 
ALTER COLUMN DDiemDA nvarchar(20)

ALTER TABLE THANNHAN 
ALTER COLUMN TenTN nvarchar(20)
ALTER TABLE THANNHAN 
ALTER COLUMN Phai nvarchar(3)
ALTER TABLE THANNHAN 
ALTER COLUMN QuanHe nvarchar(15)

ALTER TABLE PHANCONG
ADD CONSTRAINT FK_PHANCONG_NHANVIEN
FOREIGN KEY (MaNV)
REFERENCES NHANVIEN (MaNV);

ALTER TABLE THANNHAN
ADD CONSTRAINT FK_THANNHAN_NHANVIEN
FOREIGN KEY (MaNV)
REFERENCES NHANVIEN (MaNV);

ALTER TABLE NHANVIEN
ADD CONSTRAINT FK_NHANVIEN_PHONGBAN
FOREIGN KEY (phong)
REFERENCES PHONGBAN(MaPhg);

ALTER TABLE PHANCONG
ADD CONSTRAINT FK_PHANCONG_DEAN
FOREIGN KEY (MaDA)
REFERENCES DEAN(MaDA);  
