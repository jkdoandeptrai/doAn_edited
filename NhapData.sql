-- DROP DATABASE DO_AN_NHOM9
-- CREATE DATABASE DO_AN_NHOM9
--Thêm cửa hàng
INSERT INTO CuaHang(TEN_CUA_HANG,TEN_NGUOI_DAI_DIEN,SDT,STK)
VALUES(
	N'Big C',  -- TEN_CUA_HANG,
	N'Đào Tiến Quyết',-- TEN_NGUOI_DAI_DIEN,
	'0896022564',-- SDT,
	'1500203139811'-- STK
)
INSERT INTO CuaHang(TEN_CUA_HANG,TEN_NGUOI_DAI_DIEN,SDT,STK)
VALUES(
	N'Circle K',  -- TEN_CUA_HANG,
	N'Vũ Tiến Dũng',-- TEN_NGUOI_DAI_DIEN,
	'0896011456',-- SDT,
	'1500203824585'-- STK
)
INSERT INTO CuaHang(TEN_CUA_HANG,TEN_NGUOI_DAI_DIEN,SDT,STK)
VALUES(
	N'Green Mart',  -- TEN_CUA_HANG,
	N'Phạm Thùy Linh',-- TEN_NGUOI_DAI_DIEN,
	'0896943587',-- SDT,
	'3285483754354' -- STK
)
INSERT INTO CuaHang(TEN_CUA_HANG,TEN_NGUOI_DAI_DIEN,SDT,STK)
VALUES(
	N'Tiệm Bánh IT',  -- TEN_CUA_HANG,
	N'Phạm Xuân Thịnh',-- TEN_NGUOI_DAI_DIEN,
	'0897294576',-- SDT,
	'1500173758432'-- STK
)
INSERT INTO CuaHang(TEN_CUA_HANG,TEN_NGUOI_DAI_DIEN,SDT,STK)
VALUES(
	N'Điện Lạnh Bảo Hoa',  -- TEN_CUA_HANG,
	N'Phạm Xuân Hoa',-- TEN_NGUOI_DAI_DIEN,
	'0897294572',-- SDT,
	'1500173712534'-- STK
)
----update 08/12/2021
INSERT INTO CuaHang(TEN_CUA_HANG,TEN_NGUOI_DAI_DIEN,SDT,STK)
VALUES(
	N'Điện Máy Xanh',  -- TEN_CUA_HANG,
	N'Phạm Xuân Hoa',-- TEN_NGUOI_DAI_DIEN,
	'0893037473',-- SDT,
	'1500173712535'-- STK
)INSERT INTO CuaHang(TEN_CUA_HANG,TEN_NGUOI_DAI_DIEN,SDT,STK)
VALUES(
	N'Shop Giày Hương',  -- TEN_CUA_HANG,
	N'Nguyễn Lan Hương',-- TEN_NGUOI_DAI_DIEN,
	'0899283653',-- SDT,
	'1500173712536'-- STK
)
INSERT INTO CuaHang(TEN_CUA_HANG,TEN_NGUOI_DAI_DIEN,SDT,STK)
VALUES(
	N'Big Mom',  -- TEN_CUA_HANG,
	N'Nguyễn Thị Quỳnh',-- TEN_NGUOI_DAI_DIEN,
	'0897294573',-- SDT,
	'1500173712537'-- STK
)
INSERT INTO CuaHang(TEN_CUA_HANG,TEN_NGUOI_DAI_DIEN,SDT,STK)
VALUES(
	N'Big G',  -- TEN_CUA_HANG,
	N'Vũ Trường Giang',-- TEN_NGUOI_DAI_DIEN,
	'0897294577',-- SDT,
	'1500173712538'-- STK
)
SELECT * FROM CuaHang
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Cơ Sở cửa hàng
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'1',  -- BA_ID,
	'1111',-- P_ID,
	N'222-Trần Duy Hưng-Hà Nội',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'2',  -- BA_ID,
	'1111',-- P_ID,
	N'TTTM The Garden-Hà Nội',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'3',  -- BA_ID,
	'1111',-- P_ID,
	N'7-9 Nguyễn Văn Linh-Long Biên-Hà Nội',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'4',  -- BA_ID,
	'1116',-- P_ID,
	N'12A1-Ngô Thì Nhậm',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'5',  -- BA_ID,
	'1116',-- P_ID,
	N'F6-Bồ Hỏa',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'6',  -- BA_ID,
	'1116',-- P_ID,
	N'105-Phố Chùa Láng',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'7',  -- BA_ID,
	'1116',-- P_ID,
	N'138-P.Trung Hòa',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'8',  -- BA_ID,
	'1121',-- P_ID,
	N'222-Đống Đa-Hà Nội',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'9',  -- BA_ID,
	'1121',-- P_ID,
	N'146-Trần Hưng Đạo',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'10',  -- BA_ID,
	'1131',-- P_ID,
	N'47-Lý Thường Kiệt',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'11',  -- BA_ID,
	'1136',-- P_ID,
	N'68-Hoàn Kiếm',-- Dia Chi,
	N'Mở'-- Trang thai
)
INSERT INTO CoSoCH(BA_ID,P_ID,DIA_CHI,TRANG_THAI)
VALUES(
	'12',  -- BA_ID,
	'1141',-- P_ID,
	N'12-Trương Định',-- Dia Chi,
	N'Mở'-- Trang thai
)--
Select * from CoSoCH
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Mặt Hàng
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1111', -- P_ID,
	N'Dầu Ăn A', -- Tên Mặt Hàng,
	'25000', -- Giá,
	'0', -- Khuyến Mại,
	'27' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1111', -- P_ID,
	N'Nước mắm Chinsu', -- Tên Mặt Hàng,
	'26000', -- Giá,
	'0', -- Khuyến Mại,
	'40' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1111', -- P_ID,
	N'CoCa 1,5', -- Tên Mặt Hàng,
	'15000', -- Giá,
	'0', -- Khuyến Mại,
	'50' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1111', -- P_ID,
	N'Bánh Orio', -- Tên Mặt Hàng,
	'12000', -- Giá,
	'0', -- Khuyến Mại,
	'130' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1116', -- P_ID,
	N'Bánh Đậu Xanh', -- Tên Mặt Hàng,
	'45000', -- Giá,
	'0', -- Khuyến Mại,
	'23' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1116', -- P_ID,
	N'Sữa Vinamilk', -- Tên Mặt Hàng,
	'90000', -- Giá,
	'0', -- Khuyến Mại,
	'29' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1116', -- P_ID,
	N'Mì Hảo Hảo', -- Tên Mặt Hàng,
	'90000', -- Giá,
	'0', -- Khuyến Mại,
	'22' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1121', -- P_ID,
	N'Bia 333', -- Tên Mặt Hàng,
	'6000', -- Giá,
	'0', -- Khuyến Mại,
	'130' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1121', -- P_ID,
	N'Strongbow', -- Tên Mặt Hàng,
	'10000', -- Giá,
	'0', -- Khuyến Mại,
	'100' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1121', -- P_ID,
	N'Bia 333', -- Tên Mặt Hàng,
	'6000', -- Giá,
	'0', -- Khuyến Mại,
	'130' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1121', -- P_ID,
	N'Trà o long', -- Tên Mặt Hàng,
	'6000', -- Giá,
	'0', -- Khuyến Mại,
	'200' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1126', -- P_ID,
	N'Bánh Dâu s16', -- Tên Mặt Hàng,
	'179000', -- Giá,
	'0', -- Khuyến Mại,
	'8' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1126', -- P_ID,
	N'Bánh SCL s18', -- Tên Mặt Hàng,
	'230000', -- Giá,
	'0', -- Khuyến Mại,
	'4' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1126', -- P_ID,
	N'Bánh Su Kem', -- Tên Mặt Hàng,
	'30000', -- Giá,
	'0', -- Khuyến Mại,
	'40' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1126', -- P_ID,
	N'Bánh Mì Pate', -- Tên Mặt Hàng,
	'15000', -- Giá,
	'5000', -- Khuyến Mại,
	'40' -- Số lượng còn lại trong Kho
)--
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1131', -- P_ID,
	N'Điều Hòa Capo', -- Tên Mặt Hàng,
	'4999999', -- Giá,
	'100000', -- Khuyến Mại,
	'20' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1131', -- P_ID,
	N'Máy Giặt', -- Tên Mặt Hàng,
	'3999999', -- Giá,
	'99999', -- Khuyến Mại,
	'40' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1141', -- P_ID,
	N'Nike air force 1', -- Tên Mặt Hàng,
	'500000', -- Giá,
	'50000', -- Khuyến Mại,
	'40' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1141', -- P_ID,
	N'Sneaker MC', -- Tên Mặt Hàng,
	'400000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Bắp cải sạch', -- Tên Mặt Hàng,
	'15000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)--
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Trứng', -- Tên Mặt Hàng,
	'3000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Thịt bò', -- Tên Mặt Hàng,
	'300000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Cua hoàng đế', -- Tên Mặt Hàng,
	'50000000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Tôm hùm', -- Tên Mặt Hàng,
	'2000000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Súp lơ', -- Tên Mặt Hàng,
	'10000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Su hào', -- Tên Mặt Hàng,
	'8000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Thịt cừu', -- Tên Mặt Hàng,
	'7000000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Đậu bắp', -- Tên Mặt Hàng,
	'40000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
INSERT INTO MatHang(P_ID, TEN_MAT_HANG, GIA, KHUYEN_MAI, CON_LAI)
VALUES(
	'1146', -- P_ID,
	N'Cà chua', -- Tên Mặt Hàng,
	'12000', -- Giá,
	'0', -- Khuyến Mại,
	'26' -- Số lượng còn lại trong Kho
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Nhap shipper
SELECT * FROM Shippers
INSERT INTO Shippers(HO_VA_TEN, CMT, SDT, DIA_CHI, BIEN_SO_XE, STK)
VALUES(
	N'Dương Ngọc Long', -- HO_VA_TEN,
	'036202010555', -- CMT,
	'0935745479', --SDT,
	N'136-Thái Hà', -- DIA_CHI,
	N'29-D2 666.34', -- BIEN_SO_XE,
	'3172478326572' -- STK
)
INSERT INTO Shippers(HO_VA_TEN, CMT, SDT, DIA_CHI, BIEN_SO_XE, STK)
VALUES(
	N'Đặng Minh Ngọc', -- HO_VA_TEN,
	'036202093257', -- CMT,
	'0935745946', --SDT,
	N'142-Đại Từ', -- DIA_CHI,
	N'29-D2 236.32', -- BIEN_SO_XE,
	'3172478216435' -- STK
)
INSERT INTO Shippers(HO_VA_TEN, CMT, SDT, DIA_CHI, BIEN_SO_XE, STK)
VALUES(
	N'Dương Ngọc Long', -- HO_VA_TEN,
	'036820207346', -- CMT,
	'0935814763', --SDT,
	N'136-Thái Hà', -- DIA_CHI,
	N'18-D1 356.34', -- BIEN_SO_XE,
	'3174376547464' -- STK
)
INSERT INTO Shippers(HO_VA_TEN, CMT, SDT, DIA_CHI, BIEN_SO_XE, STK)
VALUES(
	N'Nguyễn Việt Anh', -- HO_VA_TEN,
	'036202038947', -- CMT,
	'0938347348', --SDT,
	N'142-Xuân Thủy', -- DIA_CHI,
	N'29-D2 746.83', -- BIEN_SO_XE,
	'3193275478354' -- STK
)
INSERT INTO Shippers(HO_VA_TEN, CMT, SDT, DIA_CHI, BIEN_SO_XE, STK)
VALUES(
	N'Dương Ngọc Long', -- HO_VA_TEN,
	'036201834555', -- CMT,
	'0935749375', --SDT,
	N'136-Thái Hà', -- DIA_CHI,
	N'29-D2 676.34', -- BIEN_SO_XE,
	'3172478927482' -- STK
)
INSERT INTO Shippers(HO_VA_TEN, CMT, SDT, DIA_CHI, BIEN_SO_XE, STK)
VALUES(
	N'Dương Ngọc Vũ', -- HO_VA_TEN,
	'036202181736', -- CMT,
	'0931824734', --SDT,
	N'114-Mai Hắc Đế', -- DIA_CHI,
	N'99-D2 384.83', -- BIEN_SO_XE,
	'3178397548356' -- STK
)
INSERT INTO Shippers(HO_VA_TEN, CMT, SDT, DIA_CHI, BIEN_SO_XE, STK)
VALUES(
	N'Nguyễn Phương Nam', -- HO_VA_TEN,
	'036202112345', -- CMT,
	'0931824738', --SDT,
	N'116-Mai Hắc Đế', -- DIA_CHI,
	N'99-D2 384.84', -- BIEN_SO_XE,
	'3178397548482' -- STK
)
INSERT INTO Shippers(HO_VA_TEN, CMT, SDT, DIA_CHI, BIEN_SO_XE, STK)
VALUES(
	N'Dương Ngọc Minh', -- HO_VA_TEN,
	'036207181736', -- CMT,
	'0931824234', --SDT,
	N'114-Kim Hoa', -- DIA_CHI,
	N'19-D2 394.83', -- BIEN_SO_XE,
	'3178975483560' -- STK
)
INSERT INTO Shippers(HO_VA_TEN, CMT, SDT, DIA_CHI, BIEN_SO_XE, STK)
VALUES(
	N'Đào Văn Hiệu', -- HO_VA_TEN,
	'036202341736', -- CMT,
	'0931836734', --SDT,
	N'97-Chương Dương', -- DIA_CHI,
	N'49-D2 384.62', -- BIEN_SO_XE,
	'3178397768356' -- STK
)
