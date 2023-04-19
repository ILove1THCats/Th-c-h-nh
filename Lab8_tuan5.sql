--1. Viết thủ tục thêm mới nhân viên bao gồm các tham số: manv, tennv, gioitinh, diachi, sodt, email, phong và 1 biến Flag, Nếu Flag=0 thì nhập mới, ngược lại thì cập nhật thông tin nhân viên theo mã. Hãy kiểm tra:
--- gioitinh nhập vào có phải là Nam hoặc Nữ không, nếu không trả về mã lỗi 1. - Ngược lại nếu thỏa mãn thì cho phép nhập và trả về mã lỗi 0..
create proc themMoiNhanV 
@manv nchar(10),@tennv nvarchar(20), @gioitinh nchar(10), @diachi varchar(30),
@sodt varchar(20), @email varchar(30), @phong nvarchar(30), @flag int
as
begin

	--flag 0 và 1 thì ta xử lý
	if(@flag = 0)
	begin
		
		--Giới tính nhập vào là nam hay nữ
		if @gioitinh not in (N'Nam', N'Nữ')
		begin 
			select 1 as Maloi1
			return
		end
		
		insert into Nhanvien(manv, tennv, gioitinh, diachi, sodt, email, phong) values 
		(@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)

		select 0 as Maloi0
		return
	end
	else
	begin
		update Nhanvien set manv = @manv, tennv = @tennv, gioitinh = @gioitinh, diachi = @diachi, 
		sodt = @sodt, email = @email, phong = @phong where manv = @manv
	end
end 
go
exec themMoiNhanV N'NV04', N'Phạm Thúy Nga',N'Nam' , N'Đồng Nai', '0975436464', 'gh@gmail.com', N'Kế toán', 1
go
--2. Viết thủ tục thêm mới sản phẩm với các tham biến masp, tenhang, tensp, soluong, mausac, giaban, donvitinh, mota và 1 biến Flag. Nếu Flag=0 thì thêm mới sản phẩm, ngược lại cập nhật sản phẩm. Hãy kiểm tra:
--- Nếu tenhang không có trong bảng hangsx thì trả về mã lỗi 1 - Nếu soluong <0 thì trả về mã lỗi 2
--- Ngược lại trả về mã lỗi 0.
create proc themSP 
@masp nchar(10), @tenhang nchar(10), @tensp  nvarchar(20), @soluong int, @mausac nvarchar(20),
@giaban money, @donvitinh nchar(10), @mota  nchar(200), @flag int
as begin
	--flag 0 và 1
	if(@flag = 0)
	begin
		
			--tenhang không có trong hãng sx
		if @tenhang not in (select tenhang from Hangsx)
		begin
			select 1 as N'Mã lỗi 1'
		end
		if @soluong < 0
		begin 
			select 2 as N'Mã lỗi 2'
		end
		
		--Thêm vào
		insert into Sanpham(masp, tensp, soluong, mausac, giaban, donvitinh, mota) values 
		(@masp, @tensp, @soluong, @mausac,@giaban, @donvitinh, @mota)

		select 0 as N'Mã lỗi 0'
		return
	end
	else
	begin
		update Sanpham set masp = @masp, tensp = @tensp, soluong = @soluong, mausac = @mausac, 
		giaban = @giaban, donvitinh = @donvitinh, mota = @mota where masp = @masp
	end
end
go
exec themSP N'SP07', 'Samsung', N'Plus3000', 50, N'Đỏ', 5000000, N'Chiếc', N'Hàng cao cấp', 1
go
--3. Viết thủ tục xóa dữ liệu bảng nhanvien với tham biến là manv. Nếu many chưa có thì trả về 1, ngược lại xóa nhanvien với nhanvien bị xóa là many và trả về 0. (Lưu ý: xóa nhanvien thì phải xóa các bảng Nhap, Xuat mà nhân viên này tham gia).
create proc xoa_DL @manv varchar(20)
as begin 
	if @manv is null
	begin 
		return 1;
	end
	else 
	begin 
		delete from Nhanvien where manv = @manv
		return 0
	end
end
go
exec xoa_DL 'NV04'
go
--4. Viết thủ tục xóa dữ liệu bảng sanpham với tham biến là masp. Nếu masp chưa có thì trả về 1, ngược lại xóa sanpham với sanpham bị xóa là masp và trả về 0. (Lưu ý: xóa sanpham thì phải xóa các bảng Nhap, Xuat mà sanpham này cung ứng).
create proc xoa_SP @masp varchar(20)
as begin 
	if @masp is null
	begin 
		return 1
	end
	else
	begin 
		delete from Nhap where masp in (select masp from Sanpham where masp = @masp)
		delete from Sanpham where masp = @masp
		return 0
	end
end
go
exec xoa_SP 'SP06'
go
--5. Tạo thủ tục nhập liệu cho bảng Hạngsx, với các tham biến truyền vào mahangsx, tenhang, diachi, sodt, email. Hãy kiểm tra xem tenhang đã tồn tại trước đó hay chưa, nếu rồi trả về mã lỗi 1? Nếu có rồi thì không cho nhập và trả về mã lỗi 0.
create proc nhapHangsx
@mahangsx varchar(20), @tenhang nvarchar(20), @diachi varchar(20), @sodt varchar(20), @email varchar(20)
as begin
	if @tenhang in (select tenhang from Hangsx)
	begin 
		select 1 as N'Mã lỗi 1'
	end

	insert into Hangsx (mahangsx, tenhang, diachi, sodt, email) values
	(@mahangsx, @tenhang, @diachi, @sodt, @email)
end
go
--6. Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến sohdn, masp, many, ngaynhap, soluongN, dongiaN. Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không, nếu không trả về 1? many có tồn tại trong bảng nhanvien hay không nếu không trả về 2?
--ngược lại thì hãy kiểm tra: Nếu sohdn đã tồn tại thì cập nhật bảng Nhap theo sohdn, ngược lại thêm mới bảng Nhap và trả về mã lỗi 0.
create proc nhapChoNhap
    @sohdn nchar(10),
    @masp nchar(10),
    @manv nchar(10),
    @ngaynhap date,
    @soluongN int,
    @dongiaN money
as
begin
    
    if @masp not in (select masp from Sanpham where masp = @masp)
    begin
        select 1 as N'Mã lỗi 1'
        return
    end
    
    IF @manv not in (SELECT manv FROM Nhanvien WHERE manv = @manv)
    BEGIN
        select 2 as N'Mã lỗi 2' 
        RETURN;
    END
    
    IF @sohdn in (SELECT sohdn FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        -- Nếu đã tồn tại thì cập nhật bảng Nhap
        UPDATE Nhap 
        SET masp = @masp, manv = @manv, ngaynhap = @ngaynhap, soluongN = @soluongN, dongiaN = @dongiaN 
        WHERE sohdn = @sohdn;
    END
    ELSE
    BEGIN
        -- Nếu chưa tồn tại thì thêm mới bảng Nhap
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN);
    END
    
    select 0 as N'Mã lỗi 0'
	return
END
go
exec nhapChoNhap 'N07', 'SP02', 'NV04', '2020-09-15', 16, 50000
go
--7. Viết thủ tục nhập dữ liệu cho bảng xuat với các tham biến sohdx, masp, many, ngayxuat, soluongX. Kiểm tra xem masp có tồn tại trong bàng Sanpham hay không nếu không trả về 1? many có tồn tại trong bảng nhanvien hay không nếu không trả về 2?
--soluongX<= Soluong nếu không trả về 3? ngược lại thì hãy kiểm tra: Nếu sohdx đã tồn tại thì cập nhật bảng Xuat theo sohdx, ngược lại thêm mới bảng Xuat và trả về mã lỗi 0
create PROCEDURE xuatSP
    @sohdx nchar(10),
	@masp nchar(10),
    @manv nchar(10),
    @ngayxuat date,
    @soluongX int
AS
BEGIN
    -- Kiểm tra sự tồn tại của masp trong bảng Sanpham
    IF NOT EXISTS(SELECT masp FROM Sanpham WHERE masp = @masp)
        RETURN 1

    -- Kiểm tra sự tồn tại của many trong bảng Nhanvien
    IF NOT EXISTS(SELECT manv FROM Nhanvien WHERE manv = @manv)
        RETURN 2

    -- Kiểm tra số lượng xuất không vượt quá số lượng tồn kho Soluong
    DECLARE @Soluong int
    SELECT @Soluong = soluong FROM Sanpham WHERE masp = @masp
    IF @soluongX > @Soluong
        RETURN 3

    -- Thêm hoặc cập nhật dữ liệu vào bảng Xuất
    IF EXISTS(SELECT sohdx FROM Xuat WHERE sohdx = @sohdx)
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
        INSERT INTO Xuat (sohdx, masp, manv, ngayxuat, soluongX)
        VALUES (@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END
    
    RETURN 0
END
go
exec xuatSP 'X06', 'SP03', 'NV01', '2020-09-15', 16
go