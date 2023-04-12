--1. Hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím.
CREATE FUNCTION ThongTinSP(@tenhang NVARCHAR(20))
RETURNS TABLE
AS
RETURN
    SELECT s.*
    FROM Sanpham s
    INNER JOIN Hangsx h ON s.mahangsx = h.mahangsx
    WHERE h.tenhang = @tenhang;
go

SELECT * FROM ThongTinSP('Samsung');
go

--2. Hãy viết hàm đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được nhập từ ngày x đến ngày y, với x,y nhập từ bàn phím.
alter FUNCTION SPvHangsx(@ngayx int, @ngayy int)
RETURNS TABLE
AS
RETURN
    SELECT s.*, h.tenhang
    FROM Sanpham s
    INNER JOIN Hangsx h ON s.mahangsx = h.mahangsx
    INNER JOIN Nhap n ON s.masp = n.masp
    WHERE DAY(n.ngaynhap) BETWEEN @ngayx AND @ngayy;
go

SELECT * FROM SPvHangsx(14, 30);
go

--3. Hãy xây dựng hàm đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn, nếu lựa chọn = 0 thì đưa ra danh sách các sản phẩm có soluong =0, ngược lại lựa chọn =1 thì đưa ra danh sách các sản phẩm có soluong >0.
CREATE FUNCTION DsSPtheoHangsx(@mahangsx varchar(20), @luachon INT)
RETURNS TABLE
AS
RETURN
    SELECT s.*
    FROM Sanpham s
    INNER JOIN Hangsx h ON s.mahangsx = h.mahangsx
    WHERE h.mahangsx = @mahangsx AND ((@luachon = 0 AND s.soluong = 0) OR (@luachon = 1 AND s.soluong > 0));
go
SELECT * FROM DsSPtheoHangsx('H01', 1);
go
--4. Hãy xây dựng hàm đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím.
CREATE FUNCTION TimNvtheoPhong(@tenphong NVARCHAR(255))
RETURNS TABLE
AS
RETURN
    SELECT n.*
    FROM Nhanvien n
    WHERE phong = @tenphong;
go
SELECT * FROM TimNvtheoPhong('Kế toán');
go
--5. Hãy tạo hàm đưa ra danh sách các hãng sản xuất có địa chỉ nhập vào từ bàn phím (Lưu ý – Dùng hàm like để lọc).
CREATE FUNCTION DiaChiHangsx(@diachi NVARCHAR(40))
RETURNS TABLE
AS
RETURN
    SELECT * from Hangsx where @diachi like diachi
go
SELECT * FROM DiaChiHangsx(N'Korea');
go
--6. Hãy viết hàm đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được xuất từ năm x đến năm y, với x,y nhập từ bàn phím.
CREATE FUNCTION DsSanPVaHangSx(@yeardau int, @yearcuoi int)
RETURNS TABLE
AS
RETURN
    SELECT sp.tensp, sx.tenhang from Sanpham sp 
	join Hangsx sx on sx.mahangsx = sp.mahangsx
	join Xuat x on x.masp = sp.masp
	where YEAR(x.ngayxuat) between @yeardau and @yearcuoi
go
SELECT * FROM DsSanPVaHangSx(2019, 2022);
go
--7. Hãy xây dựng hàm đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn, nếu lựa chọn = 0 thì đưa ra danh sách các sản phẩm đã được nhập, ngược lại lựa chọn =1 thì đưa ra danh sách các sản phẩm đã được xuất.
alter FUNCTION DsSpTheoHangX(@mahangsx varchar(20), @luachon INT)
RETURNS TABLE
AS
RETURN

    select sp.tensp from Sanpham sp 
	join Hangsx sx on sx.mahangsx = sp.mahangsx
	where @mahangsx = sx.tenhang and 
	(@luachon = 0 AND sp.masp in (select masp from Nhap) 
	OR @luachon = 1 AND sp.masp in (select masp from Xuat))
go
SELECT * FROM DsSpTheoHangX('Samsung', 0);
go
--8. Hãy xây dựng hàm đưa ra danh sách các nhân viên đã nhập hàng vào ngày được đưa vào từ bàn phím.
alter FUNCTION DsNhanVNTheoN(@ngay int)
RETURNS TABLE
AS
RETURN
    SELECT nv.* from Nhanvien nv join Nhap n on nv.manv = n.manv
	where @ngay = Day(n.ngaynhap)
go
SELECT * FROM DsNhanVNTheoN(22);
go
--9. Hãy xây dựng hàm đưa ra danh sách các sản phẩm có giá bán từ x đến y, do công ty z sản xuất, với x,y,z nhập từ bàn phím.
CREATE FUNCTION GiaBanSPThepYC(@x float, @y float, @z nvarchar(20))
RETURNS TABLE
AS
RETURN
    select sp.* from Sanpham sp join Hangsx sx on sx.mahangsx = sp.mahangsx
	where (sp.giaban between @x and @y) and @z = sx.tenhang
go
SELECT * FROM GiaBanSPThepYC(10000, 200000000, 'Samsung');
go
--10. Hãy xây dựng hàm không tham biến đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng
CREATE FUNCTION DsSPvHang()
RETURNS TABLE
AS
RETURN
    select sp.masp, sp.tensp, sx.mahangsx, sx.tenhang from Sanpham sp 
	join Hangsx sx on sx.mahangsx = sp.mahangsx
go
SELECT * FROM DsSPvHang ();
go