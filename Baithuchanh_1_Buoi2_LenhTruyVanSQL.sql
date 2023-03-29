use QLBanHang

--1.Hiển thị thông tin các bảng dữ liệu trên
--select * from Nhanvien, Hangsx, Nhap, Sanpham, Xuat
--2.Đưa ra thông tin masp, tensp, tenhang, soluong, mausac, giaban, donvitinh, mota của các sản phẩm sắp xếp theo chiều giảm dần giá bán
--select masp, tensp, tensp as tenhang, soluong, mausac, giaban, donvitinh, mota from Sanpham order by giaban desc
--3.Đưa ra thông tin các sản phẩm có trong cửa hàng do công ty có tên hãng là samsung sản xuất
--select * from Sanpham sp inner join Hangsx hsx on sp.mahangsx = hsx.mahangsx where hsx.tenhang like N'%Samsung%'
--4.Đưa ra thông tin các nhân viên Nữ ở phòng 'Kế toán'
--select * from Nhanvien where phong like 'Kế toán'
--5.Đưa ra thông tin phiếu nhập gồm: sohdn, masp, tensp, tenhang, soluongN, dongiaN, tiennhap = soluongN*dongiaN, mausac, donvitinh, ngaynhap, tennv, phong. Sắp xếp theo chiều tăng dần của hóa đơn nhập.
--select sohdn, n.masp, tensp, tenhang, soluongN, dongiaN, tiennhap = soluongN*dongiaN, mausac, donvitinh, ngaynhap, tennv, phong from Nhap n
--join Nhanvien p on  n.manv = p.manv
--join Sanpham sp on sp.masp = n.masp
--join Hangsx hsx on hsx.mahangsx = sp.mahangsx
--order by sohdn asc
