---------------------------------------------------------------------------------------------------------------------------------------------------------------

--                                                                     Phần nhân viên                                                                        --

--                                                                      

-- Xem khách hàng nào đạt được các mốc điểm 50,100,200,500 để thực hiện chương trình khuyến mại  

SELECT * FROM KH_DiemTichLuy( 3 /*Mốc điểm*/)


-- Tìm xem những khách hàng nào có ngày sinh hôm nay để áp dụng chương trình khuyến mãi

EXEC Sinh_Nhat
--Tìm mặt hàng có tên(gần giống) có đủ số lượng ít nhất mà khách hàng cần hay không

SELECT * FROM Check_If_Available ('%',2)  ---(/*Tên hàng - Dùng được cả regular expression hay Wild card*/, /*Số lượng ít nhất cần tìm*/)

-- Thêm khách hàng
                INSERT INTO KhachHang(HO_VA_TEN,SDT,DIA_CHI,NGAY_SINH)
                        VALUES(
                        N'Bùi Đức Nguyên',  -- HO_VA_TEN,
                            '0294874884',-- SDT,
                            N'Thanh Hóa',-- DIA_CHI,
                            N'2001-02-10'-- NGAY_SINH
                        )
-- Thêm hóa đơn cho khách hàng có mã là C_ID
                INSERT INTO HoaDon( C_ID, NGUOI_NHAN, SDT_NGUOI_NHAN, DIA_CHI_GIAO_HANG,PHUONG_THUC_THANH_TOAN,PHI_SHIP_VND,THOI_GIAN_DAT_HANG,GHI_CHU) 
                        VALUES(
                        10, -- C_ID,
                        N'Bùi Đức Nguyên', -- NGUOI_NHAN,
                        '0385779451',-- SDT_NGUOI_NHAN,
                        N'Giải Phóng-Hà Nội',-- DIA_CHI_GIAO_HANG,
                        N'Thanh toán khi nhận hàng',-- PHUONG_THUC_THANH_TOAN,
                        30000,-- PHI_SHIP_VND,
                        GETDATE(),
                        N'Giao lúc 10-12h trưa'
                    )
-- Cập nhật mặt hàng có trong hóa đơn có B_ID
EXEC Cap_nhat_mat_hang_trong_hoa_don  100, 100 ,7      -- @B_ID, @H_ID ,@amount : Parameters
-- Cập nhật tiền đơn hàng
EXEC Update_Bills 
    

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--                                                                     Phần Khách hàng                                                                       --

-- Khách hàng nhận được hàng, chỉ được xác nhận và đánh giá đơn hàng 1 lần
        EXEC Customer_Received 100,N'Tốt',3 @WhichBill , @TinhTrang, @danhgia  
-- Khách hàng hủy đơn hàng có mã B_ID, điều kiện là đơn hàng đó phải chưa được shipper nào xác nhận cả.
        EXEC Customer_Cancel 100  --@WhichBill




---------------------------------------------------------------------------------------------------------------------------------------------------------------

--                                                                     Phần Shipper                                                                       --
     
        EXEC Shipper_Confirm_Bill 1000,100 @praS,@praB  -- Shipper nào xác nhận đơn hàng có mã nào


---------------------------------------------------------------------------------------------------------------------------------------------------------------

--                                                                      Phần Ngoài                                                                       --


EXEC ADD_CuaHang  -- thêm cửa hàng vào bảng phí 

EXEC ADD_Shipper  -- thêm shipper vào bảng phí 

EXEC UpdateKhachHangAndShipper -- Cập nhật điểm tích lũy cho khách hàng, số sao đánh giá cho shippers 

EXEC Update_ShipperFee -- Cập nhật phí dịch vụ cho shipper mỗi cuối tháng

EXEC NopPhi 100, 's',10,2021 -- @ID,@Ob,@mth,@yr: Shipper chỉ có thể nộp phí cho tháng trước đó, tức là phải hết 1 tháng làm việc mới được nộp.

SELECT * FROM KhachHang
SELECT * FROM Shippers
SELECT * FROM PhiShippers
SELECT * FROM PhiCuaHang
-- Cuối tháng cần xem những thông tin  này:

-- Xem những ai dang nợ tiền trong các tháng nhỏ hơn @thang

SELECT * FROM TON_NO( 10,2021 ) --@thang, @nam

-- Xem mặt hàng nào bán chạy nhất trong @thang
EXEC Best_Selling 10 --@thang

-- Xem tổng tiền mà công ty đã nhận được từ shipper và cửa hàng ( trừ những CH, SP nào chưa gửi tiền)
EXEC Monthly_Revenue 10 --@thang