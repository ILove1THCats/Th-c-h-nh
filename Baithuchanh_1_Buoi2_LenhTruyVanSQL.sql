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

--6.Đưa ra thông tin phiếu xuất gồm: sohdx, masp, tensp, tenhang, soluongX, giaban, tienxuat = soluongX * giaban, mausac, donvitinh, ngayxuat, tennv, phong trong tháng 10 năm 2018, sắp xếp theo chiều tăng dần của sohdx.
--select sohdx, sp.masp, tensp, tenhang, soluongX, giaban, tienxuat = soluongX * giaban, mausac, donvitinh, ngayxuat, tennv, phong from Xuat x
--join Sanpham sp on sp.masp = x.masp join Hangsx sx on sx.mahangsx = sp.mahangsx join Nhanvien nv on nv.manv = x.manv
--where MONTH(ngayxuat) = 10 order by sohdx asc

--7.Đưa ra thông thông tin về các hóa đơn mà hãng samsung đã nhập trong năm 2017, gồm: sohdn, masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong.
--select n.sohdn, sp.masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong from Sanpham sp
--join Hangsx sx on sp.mahangsx = sx.mahangsx join Nhap n on n.masp = sp.masp join Nhanvien nv on nv.manv = n.manv
--Where sx.tenhang like 'Samsung' and YEAR(n.ngaynhap) = 2017

--8.Đưa ra top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2018, sắp xếp theo chiều giảm dần của soluongX.
--select top 10 * from Xuat where YEAR(ngayxuat) = 2018 order by soluongX desc

--9.Đưa ra thông tin 10 sản phẩm có giá bán cao nhất trong cửa hàng, theo chiều giảm dần giá bán.
--select top 10 * from Sanpham order by giaban desc

--10.Đưa ra thông tin sản phẩm có giá bán từ 100.000 đến 500.000 cửa hàng samsung.
--select * from Sanpham join Hangsx sx on sx.mahangsx = Sanpham.mahangsx
--where giaban between 100000 and 500000 and sx.tenhang like 'Samsung'

--11. Tính tổng tiền đã nhập trong năm 2018 của hãng samsung.
--select tongtien = soluongN*dongiaN from Nhap n join Sanpham sp on n.masp = sp.masp join Hangsx sx on sx.mahangsx = sp.mahangsx
--where YEAR(n.ngaynhap) = 2018 and sx.tenhang like 'Samsung'

--12. Thống kê tổng tiền đã xuất trong ngày 2/9/2018
--select SUM(soluongX ) as TK from Xuat x join Sanpham sp on sp.masp = x.masp where ngayxuat = '2018-09-02'

--13. Đưa ra sohdn, ngaynhap có tiền nhập phải trả cao nhất trong năm 2018
--select top 1 sohdn, ngaynhap from Nhap n where YEAR(ngaynhap) = 2018 order by n.soluongN * n.dongiaN desc

--14. Đưa ra 10 mặt hàng có soluongN nhiều nhất trong năm 2019.
--select top 10 Sanpham.masp, tensp, soluong, mausac, giaban, donvitinh, mota from Sanpham join Nhap on Nhap.masp = Sanpham.masp where YEAR(Nhap.ngaynhap) = 2019 order by Nhap.soluongN desc

--15. Đưa ra masp,tensp của các sản phẩm do công ty ‘Samsung’ sản xuất do nhân viên có mã ‘NV01’ nhập.
--select sp.masp, tensp from Sanpham sp join Hangsx sx on sx.mahangsx = sp.mahangsx join Nhap on sp.masp = Nhap.masp join Nhanvien nv on nv.manv = Nhap.manv
--where sx.tenhang like 'Samsung' and nv.manv = 'NV01'

--16. Đưa ra sohdn,masp,soluongN,ngayN của mặt hàng có masp là ‘SP02’, được nhân viên ‘NV02’ xuất.
--select sohdn,sp.masp,soluongN, ngaynhap as ngayN from Nhap n join Sanpham sp on sp.masp = n.masp join Xuat x on x.masp = sp.masp join Nhanvien nv on nv.manv = x.manv
--where sp.masp = 'SP02' and nv.manv = 'NV02'

--17. Đưa ra manv,tennv đã xuất mặt hàng có mã ‘SP02’ ngày 03-02-2020’.
--select nv.manv, tennv from Nhanvien nv join Xuat x on x.manv = nv.manv join Sanpham sp on sp.masp = x.masp
--where x.masp = 'SP02' and x.ngayxuat = '03-02-2020'
