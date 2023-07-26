﻿--1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất
select MASP, TENSP from SANPHAM where NUOCSX='Singapore'

--2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”
select MASP, TENSP from SANPHAM where DVT in ('cay', 'quyen')

--3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”
select MASP, TENSP from SANPHAM where MASP like 'B%' and MASP like '%01'

--4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000
select MASP, TENSP from SANPHAM where NUOCSX='Trung Quoc' and GIA between 30000 and 40000

--5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000
select MASP, TENSP from SANPHAM where NUOCSX in ('Trung Quoc', 'Thai Lan') and GIA between 30000 and 40000

--6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007
select SOHD, TRIGIA from HOADON where NGHD between '01-01-2007' and '01-02-2007'

--7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần)
select SOHD, TRIGIA from HOADON where NGHD between '01-01-2007' and '01-31-2007' group by NGHD order by NGHD asc

--8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007
select MAKH, HOTEN from KHACHHANG where MAKH in (select MAKH from HOADON where NGHD='01-01-2007')

--9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006
select SOHD, TRIGIA from HOADON where MANV in (select MANV from NHANVIEN where HOTEN='Nguyen Van B') and NGHD='10-28-2006'

--10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006
select MASP, TENSP from SANPHAM where MASP in 
(select MASP from CTHD where SOHD in 
(select SOHD from HOADON where month(NGHD)=10 and year(NGHD)=2006 and MAKH=
(select MAKH from KHACHHANG where HOTEN='Nguyen Van A'))) 

--11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”
select distinct SOHD from CTHD where MASP in ('BB01', 'BB02')

--12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20
select distinct SOHD from CTHD where MASP in ('BB01', 'BB02') and SL between 10 and 20

--14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007
select MASP, TENSP from SANPHAM where NUOCSX='Trung Quoc' or MASP in (select MASP from CTHD where SOHD in (select SOHD from HOADON where NGHD='01-01-2007'))

--15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được
select MASP, TENSP from SANPHAM where MASP not in (select MASP from CTHD)

--16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006
select MASP, TENSP from SANPHAM where MASP not in (select MASP from CTHD where SOHD in (select SOHD from HOADON where year(NGHD)=2006))

--17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006
select MASP, TENSP from SANPHAM where NUOCSX='Trung Quoc' and MASP not in (select MASP from CTHD where SOHD in (select SOHD from HOADON where year(NGHD)=2006))

--18. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất
select distinct SOHD from CTHD where MASP in (select MASP from SANPHAM where NUOCSX='Singapore')

--19. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất
select distinct SOHD, count(MASP) as COUNTING into R1 from CTHD where MASP in (select MASP from SANPHAM where NUOCSX='Singapore') group by SOHD
select SOHD from R1 where COUNTING=(select max(COUNTING) from R1)

--20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
select count(MAKH) from HOADON where MAKH=NULL

--21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006?
select count(SOHD) as COUNTING, MASP into R2 from CTHD where SOHD in (select SOHD from HOADON where year(NGHD)=2006) group by MASP
select count(MASP) from R2

-- 22) Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
SELECT *
FROM KhachHang
WHERE MaKH=(
SELECT TOP 1 HD.MaKH
FROM KhachHang KH join HoaDon HD
ON KH.MaKH=HD.MaKH
WHERE KH.MaKH in(
	SELECT TOP 10 KH1.MaKH
	FROM KhachHang KH1
	ORDER BY KH1.DoanhSo DESC)
GROUP BY HD.MaKH
ORDER BY Count(SoHD) DESC)
