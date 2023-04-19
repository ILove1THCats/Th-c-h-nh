--Hãy tạo các Trigger kiểm soát ràng buộc toàn vẹn và kiểm tra ràng buộc dữ liệu sau:
--1. Tạo trigger kiểm soát việc nhập dữ liệu cho bảng nhập, hãy kiểm tra các ràng buộc toàn vẹn: 
--masp có trong bảng sản phẩm chưa? many có trong bảng nhân viên chưa? kiểm tra các ràng buộc dữ liệu: 
--soluongN và dongiaN>0? Sau khi nhập thì soluong ở bảng Sanpham sẽ được cập nhật theo.
create trigger kiemSoatSP
on Nhap 
for insert
as
begin
	if (select masp from inserted) in (select masp from Nhap)
	begin
		print N'Đã có mã sản phẩm này rồi'
		rollback transaction
	end
	if (select manv from inserted) in (select manv from Nhanvien)
	begin 
		print N'Đã có mã sản phẩm này rồi'
		rollback transaction
	end
	if ((select soluongN from inserted) <= 0 and (select dongiaN from inserted) <= 0)
    begin
        print N'Nhập sai số lượng hoặc đơn giá'
        rollback transaction
    end
	else
		declare @sl int
		set @sl = (select soluongN from inserted)
		
		update Sanpham set soluong = soluong + @sl 
		where masp = (select masp from inserted)	
end	
go
--2. Tạo trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc toàn vẹn: 
--masp có trong bàng sản phẩm chưa? many có trong bảng nhân viên chưa? kiểm tra các ràng buộc dữ liệu: 
--soluongX< soluong trong bảng sanpham? Sau khi xuất thì soluong ở bảng Sanpham sẽ được cập nhật theo.
create trigger kiemSoatXuat
on Xuat
for insert
as
begin
    if (select masp from inserted) in (select masp from Sanpham)
    begin
        print N'Sản phẩm không tồn tại trong danh mục sản phẩm.'
        rollback transaction
    end
    if (select manv from inserted) in (select manv from Nhanvien)
    begin
        print N'Nhân viên không tồn tại trong danh mục nhân viên.'
        rollback transaction
    end
    if (select soluongX from inserted) < (select soluong from Sanpham sp join inserted i on sp.masp = i.masp
		where sp.masp = i.masp)
    begin
        print N'Số lượng hoặc đơn giá xuất không hợp lệ.'
        rollback transaction
    end
    if ((select soluongX from inserted) > (SELECT soluong FROM Sanpham sp join inserted i on sp.masp = i.masp
		where sp.masp = i.masp))
    begin
        print N'Số lượng sản phẩm trong kho không đủ để xuất.'
        rollback transaction
    end
    else
    begin
        update SanPham set soluong = soluong - (select soluongX from inserted) 
		where masp in (select masp from inserted)
    end
end
go
--| 3. Tạo trigger kiểm soát việc xóa phiếu xuất,
--khi phiếu xuất xóa thì số lượng hàng trong bảng sanpham sẽ được cập nhật tăng lên.
create trigger xoaXuat
on Xuat
after delete
as
begin
  declare @masp nvarchar(10), @soln int;

  select @masp = d.masp, @soln = d.soluongX
  from deleted d;

  update Sanpham
  set soluong = soluong + @soln
  where masp = @masp;
end
go
--4. Tạo trigger cho việc cập nhật lại số lượng xuất trong bảng xuất,
--hãy kiểm tra xem số lượng xuất thay đổi có nhỏ hơn soluong trong bảng sanpham hay ko? số bản ghi thay đổi
-->1 bản ghi hay không? nếu thỏa mãn thì cho phép update bảng xuất và update lại soluong trong bảng sanpham.
create trigger capNhatXuat
on Xuat
after update
as
begin
    declare @Count int, @masp nvarchar(10), @sln int, @sln_old int

    select @Count = COUNT(*) from inserted

    if @Count > 1
    begin
        print N'Số bản ghi thay đổi > 1 bản ghi'
        rollback transaction
    end

    select @masp = i.masp, @sln = i.soluongX, @sln_old = d.soluongX
    from INSERTED i INNER JOIN DELETED d ON i.sohdx = d.sohdx AND i.masp = d.masp

    if @sln < @sln_old
    begin
        print N'Số lượng xuất thay đổi nhỏ hơn số lượng trong bảng sản phẩm'
        rollback transaction
    end

    update Xuat set soluongX = @sln where sohdx = (select sohdx from inserted)

    update Sanpham set soluong = soluong + (@sln_old - @sln) where masp = @masp
end
go
--5. Tạo trigger cho việc cập nhật lại số lượng Nhập trong bảng Nhập,
--Hãy kiểm tra xem số bản ghi thay đổi >1 bản ghi hay không?
--nếu thỏa mãn thì cho phép update bảng Nhập và update lại soluong trong bảng sanpham.
create trigger capNhatSoLuongNhap
on Nhap
after update
as
begin
    if (select COUNT(*) from inserted) > 1
    begin
        print N'Chỉ được phép cập nhật một bản ghi tại một thời điểm'
        rollback transaction
    end
    else
    begin
        declare @masp nvarchar(10), @slnOld int, @slnNew int
        
        select @masp = i.masp, @slnOld = d.soluongN, @slnNew = i.soluongN
        from inserted i join deleted d on i.masp = d.masp
        
        if @slnNew < @slnOld
        begin
            print N'Số lượng nhập mới phải lớn hơn số lượng cũ!'
            rollback transaction
        end
		else
		begin
            update Sanpham
            set soluong = soluong + (@slnNew - @slnOld)
            where masp = @masp
        end
    end
end
go
--6. Tạo trigger kiểm soát việc xóa phiếu nhập,
--khi phiếu nhập xóa thì số lượng hàng trong bảng sanpham sẽ được cập nhật giảm xuống.
create trigger kiemSoatNhap
on Nhap
after delete 
as begin
	declare @soluongD int
	set @soluongD = (select soluongN from deleted)

	update Sanpham set soluong = soluong - @soluongD where masp in (select masp from deleted)
end
go