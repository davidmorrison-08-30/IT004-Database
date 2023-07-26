--1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất
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

-- 22) Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?select Max(TRIGIA) as TRIGIACAONHAT, Min(TRIGIA) as TRIGIATHAPNHAT from HoaDon-- 23) Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?select AVG(TRIGIA) as TRIGIATRUNGBINH2006 from HOADON where YEAR(NgHD)='2006'-- 24) Tính doanh thu bán hàng trong năm 2006select SUM(TriGia) as DoanhThu from HoaDon where YEAR(NgHD)='2006'-- 25) Tìm số hóa đơn có trị giá cao nhất trong năm 2006.SELECT TOP 1 SoHDFROM HoaDonWHERE YEAR(NgHD)='2006'ORDER BY TriGia DESC-- 26) Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.SELECT TOP 1 KH.HoTenFROM HoaDon HD join KhachHang KHON HD.MaKH=KH.MaKHWHERE YEAR(HD.NgHD)='2006'ORDER BY HD.TriGia DESC-- 27) In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.SELECT KH.MaKH, KH.HoTenFROM KhachHang KHWHERE KH.DoanhSo IN (SELECT TOP 3 KH1.DoanhSo FROM KhachHang KH1 ORDER BY KH1.DoanhSo DESC)-- 28) In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.SELECT SP.MaSP, SP.TenSPFROM SanPham SPWHERE SP.Gia IN (SELECT TOP 3 SP1.Gia FROM SanPham SP1 ORDER BY SP1.Gia DESC)-- 29) In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm)SELECT SP.MaSP, SP.TenSPFROM SanPham SPWHERE SP.NuocSX='Thai Lan' and SP.Gia IN (SELECT TOP 3 SP1.Gia FROM SanPham SP1 ORDER BY SP1.Gia DESC)\-- 30) In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).SELECT SP.MaSP, SP.TenSPFROM SanPham SPWHERE SP.NuocSX='Trung Quoc' and SP.Gia IN (SELECT TOP 3 SP1.Gia FROM SanPham SP1 WHERE SP1.NuocSX='Trung Quoc' ORDER BY SP1.Gia DESC)-- 31) * In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).SELECT *FROM KhachHangWHERE DoanhSo IN(	SELECT TOP 3 DoanhSo	FROM KhachHang	ORDER BY DoanhSo DESC)ORDER BY DoanhSo DESC-- 32) Tính tổng số sản phẩm do “Trung Quoc” sản xuất.SELECT Count(*) as TongSoSanPhamFROM SanPhamWHERE NuocSX='Trung Quoc'-- 33) Tính tổng số sản phẩm của từng nước sản xuất.SELECT NuocSX, Count(*) as TongSoSanPhamFROM SanPhamGROUP BY NuocSX-- 34) Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.SELECT NuocSX,Max(Gia) as GiaCaoNhat, Min(Gia) as GiaThapNhat, AVG(Gia) as GiaTrungBinhFROM SanPhamGROUP BY NuocSX-- 35) Tính doanh thu bán hàng mỗi ngày.SELECT NgHD, Sum(TriGia) as DoanhThuFROM HoaDonGROUP BY NgHD-- 36) Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.SELECT CT.MaSP,Sum(CT.SL) as SoLuongFROM HoaDon HD join CTHD CTON HD.SoHD=CT.SoHDWHERE MONTH(HD.NgHD)='10' and YEAR(HD.NgHD)='2006'GROUP BY CT.MaSP-- 37) Tính doanh thu bán hàng của từng tháng trong năm 2006.SELECT MONTH(NgHD) as Thang, Sum(TriGia) as DoanhThuFROM HoaDonWHERE YEAR(NgHD)='2006'GROUP BY MONTH(NgHD)-- 38) Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.SELECT *FROM HoaDonWHERE SoHD in (SELECT SoHD FROM CTHD GROUP BY SoHD HAVING Count(Distinct MaSP)>=4)-- 39) Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau)SELECT *FROM HoaDon HDWHERE HD.SoHD in (SELECT CT.SoHD FROM CTHD CT join SanPham SP ON CT.MaSP=SP.MaSP WHERE SP.NuocSX='Viet Nam' GROUP BY CT.SoHD HAVING Count (Distinct CT.MaSP)=3)-- 40) Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.SELECT MaKH,HoTenFROM KhachHangWHERE MaKH in (SELECT TOP 1 WITH TIES MaKH FROM HoaDon GROUP BY MaKH ORDER BY Count(*) DESC)-- 41) Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?SELECT TOP 1 MONTH (NgHD) as Thang, Sum(TriGia) as DoanhSoFROM HoaDonWHERE YEAR(NgHD)='2006'GROUP BY MONTH(NgHD)ORDER BY Sum(TriGia) DESC-- 42) Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.SELECT MaSP, TenSPFROM SanPhamWHERE MaSP in (SELECT TOP 1 WITH TIES CT.MaSP FROM CTHD CT join HoaDon HD ON CT.SoHD=HD.SoHD WHERE YEAR(HD.NgHD)='2006' GROUP BY CT.MaSP ORDER BY Sum(SL) ASC)-- 43) *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.SELECT *FROM SanPham SP1WHERE Gia=(SELECT MAX(Gia)FROM SanPham SP2WHERE SP1.NuocSX=SP2.NuocSXGROUP BY NuocSX)-- 44) Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.SELECT NuocSX, Count(Distinct Gia) as SoLuongSanPhamCoGiaBanKhacNhauFROM SanPhamGROUP BY NuocSXHAVING Count(Distinct Gia) >= 3-- 45) *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
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

