--1. Tạo thủ tục nhập liệu cho bảng Hangsx, với các tham biến truyền vào mahangsx, tenhang, diachi, sodt, email. Hãy kiểm tra xem tenhang đã tồn tại trước đó hay chưa? Nếu có rồi thì không cho nhập và đưa ra thông báo.
CREATE PROCEDURE ThemHangsx
    @mahangsx VARCHAR(20),
    @tenhang VARCHAR(20),
    @diachi VARCHAR(20),
    @sodt VARCHAR(20),
    @email VARCHAR(20)
AS
BEGIN
    -- Kiểm tra xem tenhang đã tồn tại trước đó hay chưa
    IF EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        PRINT 'Tên hãng đã tồn tại. Không thể thêm mới.'
    END
    ELSE
    BEGIN
        -- Thêm mới dữ liệu vào bảng Hangsx
        INSERT INTO Hangsx (mahangsx, tenhang, diachi, sodt, email)
        VALUES (@mahangsx, @tenhang, @diachi, @sodt, @email)
        PRINT 'Thêm mới thành công.'
    END
END
go
exec ThemHangsx 'H03', 'Samsung', 'Korea', '011-08271717', 'shhdd@gmail.com.kr'
go
--2. Tạo thủ tục nhập dữ liệu cho bảng sản phẩm với các tham biến truyền vào masp, tenhangsx, tensp, soluong, mausac, giaban, donvitinh, mota. Hãy kiểm tra xem nếu masp đã tồn tại thì cập nhật thông tin sản phẩm theo mã, ngược lại thêm mới sản phẩm vào bảng sanpham.
CREATE PROCEDURE NhapSP
    @masp VARCHAR(20),
    @tenhangsx NVARCHAR(20),
    @tensp NVARCHAR(20),
    @soluong VARCHAR(20),
    @mausac VARCHAR(20),
	@giaban float,
	@donvitinh VARCHAR(20),
	@mota VARCHAR(20)
AS
BEGIN
    IF EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        update Sanpham set mahangsx = @tenhangsx, tensp = @tensp, soluong = @soluong, mausac = @mausac, giaban = @giaban,
		donvitinh = @donvitinh, mota = @mota where @masp = masp

    END
    ELSE
    begin
		INSERT INTO Sanpham (masp, mahangsx , tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, @tenhangsx, @tenhangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
	end
END
go
--3. Viết thủ tục xóa dữ liệu bảng hangsx với tham biến là tenhang. Nếu tenhang chưa có thì thông báo, ngược lại xóa hangsx với hãng bị xóa là tenhang. (Lưu ý: xóa hangsx thì phải xóa các sản phẩm mà hangsx này cung ứng).
CREATE PROCEDURE XoaHangSX @tenhang NVARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM hangsx WHERE tenhang = @tenhang)
    BEGIN
        PRINT 'Hãng sản xuất không tồn tại.'
        RETURN
    END

    BEGIN TRANSACTION

    BEGIN TRY
        DECLARE @mahang NVARCHAR(50)
        SET @mahang = (SELECT mahangsx FROM hangsx WHERE tenhang = @tenhang)
        
        DELETE FROM sanpham WHERE mahangsx = @mahang;
        
        DELETE FROM hangsx WHERE tenhang = @tenhang;

        PRINT 'Xóa hãng sản xuất và các sản phẩm liên quan thành công.'
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Đã xảy ra lỗi trong quá trình xóa hãng sản xuất và các sản phẩm liên quan.'
    END CATCH
END
go
--4. Viết thủ tục nhập dữ liệu cho bảng nhân viên với các tham biến manv, tennv, gioitinh, diachi, sodt, email, phong, và 1 biến cờ Flag, Nếu Flag = 0 thì cập nhật dữ liệu cho bảng nhân viên theo manv, ngược lại thêm mới nhân viên này.
CREATE PROCEDURE NhapDLieuNv
    @manv nvarchar(30),
	@tennv nvarchar(30),
	@gioitinh nvarchar(10),
	@diachi nvarchar(30),
	@sodt varchar(13),
	@email varchar(30),
	@phong nvarchar(20),
	@flag int
AS
BEGIN
    if(@flag = 0)
	begin 
		update Nhanvien set 
		manv = @manv, tennv = @tennv, gioitinh = @gioitinh, diachi = @diachi, sodt = @sodt, 
		email = @email, phong = @phong
	end
	else
	begin
		insert into Nhanvien(manv,tennv,gioitinh,diachi,sodt,email,phong) values
		(@manv,@tennv,@gioitinh,@diachi,@sodt,@email,@phong)
	end
END
go
--5. Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến sohdn, masp, many, ngay nhap, soluongN, dongiaN. Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không? many có tồn tại trong bảng nhanvien hay không? Nếu không thì thông báo, ngược lại thì hãy kiểm tra: Nếu sohdn đã tồn tại thì cập nhật bảng Nhap theo sohdn, ngược lại thêm mới bảng Nhập.
CREATE PROCEDURE NhapHangNhapHang
    @sohdn nvarchar(10),
    @masp nchar(10),
    @manv nvarchar(10),
    @ngaynhap datetime,
    @soluongN int,
    @dongiaN money
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại trong bảng Sanpham'
        RETURN
    END

    IF NOT EXISTS(SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại trong bảng Nhanvien'
        RETURN
    END

    IF @soluongN <= 0
    BEGIN
        PRINT 'Số lượng nhập không hợp lệ'
        RETURN
    END

    IF @dongiaN <= 0
    BEGIN
        PRINT 'Đơn giá nhập không hợp lệ'
        RETURN
    END

    IF EXISTS(SELECT * FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        UPDATE Nhap
        SET masp = @masp,
            manv = @manv,
            ngaynhap = @ngaynhap,
            soluongN = @soluongN,
            dongiaN = @dongiaN
        WHERE sohdn = @sohdn
    END
    ELSE
    BEGIN
        INSERT INTO Nhap(sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES(@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
    END
END
go
--6. Viết thủ tục nhập dữ liệu cho bảng xuất với các tham biến sohdx, masp, manv, ngayxuat, soluongX. Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không? many có tồn tại trong bảng nhanvien hay không? soluongX<= Soluong? Nếu không thì thông báo, ngược lại thì hãy kiểm tra: Nếu sohdx đã tồn tại thì cập nhật bảng Xuat theo sohdx, ngược lại thêm mới bảng Xuat.
CREATE PROCEDURE NhapXuatHD
(
    @sohdx nvarchar(10),
    @masp nvarchar(10),
@manv nvarchar(10),
    @ngayxuat datetime,
    @soluongX int
)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Sản phẩm không tồn tại trong bảng Sanpham!'
        RETURN
    END

    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Nhân viên không tồn tại trong bảng Nhanvien!'
        RETURN
    END

    DECLARE @soluongton int
    SELECT @soluongton = soluong FROM Sanpham WHERE masp = @masp

    IF @soluongX > @soluongton
    BEGIN
        PRINT 'Số lượng xuất vượt quá số lượng tồn kho!'
        RETURN
    END

    IF EXISTS (SELECT * FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        UPDATE Xuat
        SET masp = @masp,
            manv = @manv,
            ngayxuat = @ngayxuat,
            soluongX = @soluongX
        WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        INSERT INTO Xuat(sohdx, masp, manv, ngayxuat, soluongX)
        VALUES (@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END

    UPDATE Sanpham
    SET soluong = soluong - @soluongX
    WHERE masp = @masp
END
go
--7. Viết thủ tục xóa dữ liệu bảng nhanvien với tham biến là many. Nếu many chưa có thì thông báo, ngược lại xóa nhanvien với nhanvien bị xóa là manv. (Lưu ý: xóa nhanvien thì phải xóa các bảng Nhap, Xuat mà nhân viên này tham gia).
CREATE PROCEDURE XoaNV
	@manv nvarchar(10)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
	BEGIN
		PRINT N'Mã nhân viên ' + @manv + N' không tồn tại.'
		RETURN
	END
	
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM Nhap WHERE manv = @manv
		
		DELETE FROM Xuat WHERE manv = @manv
		
		DELETE FROM Nhanvien WHERE manv = @manv
		PRINT N'Đã xóa nhân viên có mã ' + @manv + N' và các bản ghi liên quan trong bảng Nhap và Xuat.'
	END TRY
	BEGIN CATCH
		PRINT N'Xóa dữ liệu thất bại. Vui lòng kiểm tra lại.'
	END CATCH
END
go
EXEC XoaNV'NV02' 
go
--8. Viết thủ tục xóa dữ liệu bảng sanpham với tham biến là masp. Nếu masp chưa có thì thông báo, ngược lại xóa sanpham với sanpham bị xóa là masp. (Lưu ý: xóa sanpham thì phải xóa các bảng Nhap, Xuat mà sanpham này cung ứng).
CREATE PROCEDURE XoaSanPham
    @masp nchar(10)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
        PRINT 'Không tìm thấy sản phẩm để xóa'
    ELSE
    BEGIN
        BEGIN TRANSACTION
        
        DELETE FROM Xuat WHERE masp = @masp
        DELETE FROM Nhap WHERE masp = @masp
        DELETE FROM Sanpham WHERE masp = @masp
        PRINT 'Đã xóa sản phẩm ' + @masp
    END
END
go
EXEC XoaSanPham N'SP03'