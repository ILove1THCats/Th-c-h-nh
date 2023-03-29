use QLBanHang;


CREATE TABLE Hangsx (
    mahangsx NCHAR(10) PRIMARY KEY,
    tenhang NVARCHAR(20),
    diachi NVARCHAR(30),
    sodt NVARCHAR(20),
    email NVARCHAR(30)
);

CREATE TABLE Sanpham (
    masp NCHAR(10) PRIMARY KEY,
    mahangsx NCHAR(10) REFERENCES Hangsx(mahangsx),
    tensp NVARCHAR(20),
    soluong INT,
    mausac NVARCHAR(20),
    giaban MONEY,
    donvitinh NCHAR(10),
    mota NVARCHAR(MAX)
);

CREATE TABLE Nhanvien (
    manv NCHAR(10) PRIMARY KEY,
    tennv NVARCHAR(20),
    gioitinh NCHAR(10),
    diachi NVARCHAR(30),
    sodt NVARCHAR(20),
    email NVARCHAR(30),
    phong NVARCHAR(30)
);

CREATE TABLE Nhap (
    sohdn NCHAR(10),
    masp NCHAR(10),
    manv NCHAR(10),
    ngaynhap DATE,
    soluongN INT,
    dongiaN MONEY,
    PRIMARY KEY (sohdn, masp),
    FOREIGN KEY (masp) REFERENCES Sanpham(masp),
    FOREIGN KEY (manv) REFERENCES Nhanvien(manv)
);

CREATE TABLE Xuat (
    sohdx NCHAR(10),
    masp NCHAR(10),
    manv NCHAR(10),
    ngayxuat DATE,
    soluongX INT,
    PRIMARY KEY (sohdx, masp),
    FOREIGN KEY (masp) REFERENCES Sanpham(masp),
    FOREIGN KEY (manv) REFERENCES Nhanvien(manv)
);

INSERT INTO Hangsx(mahangsx, tenhang, diachi, sodt, email) VALUES 
('H01', 'Samsung', 'Korea', '011-08271717', 'ss@gmail.com.kr'),
('H02', 'OPPO', 'China', '081-08626262', 'oppo@gmail.com.cn'),
('H03', 'Vinfone', 'Việt nam', '084-098262626', 'vf@gmail.com.vn')

INSERT INTO Nhanvien (manv, tennv, gioitinh, diachi, sodt, email, phong)
VALUES ('NV01', 'Nguyễn Thị Thu', 'Nữ', 'Hà Nội', '0982626521', 'thu@gmail.com', 'Kế toán'),
       ('NV02', 'Lê Văn Nam', 'Nam', 'Bắc Ninh', '0972525252', 'nam@gmail.com', 'Vật tư'),
       ('NV03', 'Trần Hòa Bình', 'Nữ', 'Hà Nội', '0328388388', 'hb@gmail.com', 'Kế toán');

INSERT INTO Sanpham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
VALUES 
    ('SP01', 'H02', 'Plus 100', 10, 'Xám', 7000000, 'Chiếc', 'Hàng cận cao cấp'),
    ('SP02', 'H01', 'Galaxy Note11', 50, 'Đỏ', 19000000, 'Chiếc', 'Hàng cao cấp'),
    ('SP03', 'H02', 'F3 lite', 200, 'Nâu', 3000000, 'Chiếc', 'Hàng phổ thông'),
    ('SP04', 'H03', 'Vjoy3', 200, 'Xám', 1500000, 'Chiếc', 'Hàng phổ thông'),
    ('SP05', 'H01', 'Galaxy V21', 500, 'Nâu', 8000000, 'Chiếc', 'Hàng cận cao cấp');

INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
VALUES ('N01', 'SP02', 'NV01', '2019-05-02', 10, 17000000),
       ('N02', 'SP01', 'NV02', '2020-07-04', 30, 6000000),
       ('N03', 'SP04', 'NV02', '2020-05-17', 20, 1200000),
       ('N04', 'SP01', 'NV03', '2020-03-22', 10, 6200000),
       ('N05', 'SP05', 'NV01', '2020-07-07', 20, 7000000);

INSERT INTO Xuat (sohdx, masp, manv, ngayxuat, soluongX)
VALUES
    ('X01', 'SP03', 'NV02', '2020-06-14', 5),
    ('X02', 'SP01', 'NV03', '2019-03-05', 3),
    ('X03', 'SP02', 'NV01', '2020-12-12', 1),
    ('X04', 'SP03', 'NV02', '2020-06-02', 2),
    ('X05', 'SP05', 'NV01', '2020-05-18', 1);



