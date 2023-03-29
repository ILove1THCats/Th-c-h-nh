use QLBanHang

--1. Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
select sx.tenhang, COUNT(masp) as N'Số sản phẩm' from Sanpham sp join Hangsx sx on sx.mahangsx = sp.mahangsx
group by sx.tenhang

--2. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2018
select Sanpham.masp, tensp, N'Số tiền nhập' = SUM(n.dongiaN * n.soluongN) from Sanpham join Nhap n on Sanpham.masp = n.masp
group by Sanpham.masp, Sanpham.tensp

--3. Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2018 là lớn hơn 10.000 sản phẩm của hãng samsung.
select sp.masp, sp.tensp, SUM(x.soluongX) as Tongsl from Sanpham sp
join Hangsx sx on sx.mahangsx = sp.mahangsx join Xuat x on x.masp = sp.masp
where YEAR(x.ngayxuat) = 2018 and sx.tenhang like 'Samsung'
group by sp.masp, sp.tensp
having SUM(x.soluongX) >= 10000

--4. Thống kê số lượng nhân viên Nam của mỗi phòng ban.
select phong, COUNT(manv) from Nhanvien group by phong

--5. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
select sx.tenhang, SUM(n.soluongN) from Hangsx sx join Sanpham sp on sp.mahangsx = sx.mahangsx join Nhap n on n.masp = sp.masp
where YEAR(n.ngaynhap) = 2018
group by sx.tenhang

--6. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu.
select nv.manv, nv.tennv, N'Tổng lượng tiền xuất' = SUM(x.soluongX*sp.giaban) from Nhanvien nv
join Xuat x on x.manv = nv.manv join Sanpham sp on sp.masp = x.masp
where YEAR(x.ngayxuat) = 2018
group by nv.manv, nv.tennv

--7. Hãy đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 8 – năm 2018 có tổng giá trị lớn hơn 100.000
select nv.manv, nv.tennv, Tongtiennhap = SUM(n.soluongN*n.dongiaN) from Nhanvien nv
join Nhap n on n.manv = n.manv
where YEAR(n.ngaynhap) = 2018 and MONTH(n.ngaynhap) = 8
group by nv.manv, nv.tennv
having SUM(n.soluongN*n.dongiaN) >= 100000

--8. Hãy đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.
select masp, tensp from Sanpham
where masp in (select masp from Nhap) and masp not in (select masp from Xuat)
group by masp, tensp

--9. Hãy đưa ra danh sách các sản phẩm đã nhập năm 2018 và đã xuất năm 2018.
select sp.masp, tensp from Sanpham sp join Xuat x on x.masp = sp.masp
where sp.masp in (select masp from Nhap where YEAR(ngaynhap) = 2018) 
and sp.masp not in (select masp from Xuat) and YEAR(x.ngayxuat) = 2018
group by sp.masp, sp.tensp

--10. Hãy đưa ra danh sách các nhân viên vừa nhập vừa xuất.
select manv, tennv from Nhanvien
where manv in (select manv from Nhap) and manv in (select manv from Xuat)
group by tennv, manv

--11. Hãy đưa ra danh sách các nhân viên không tham gia việc nhập và xuất.
select manv, tennv from Nhanvien 
where manv not in (select manv from Nhap) and manv not in (select manv from Xuat)
group by tennv, manv