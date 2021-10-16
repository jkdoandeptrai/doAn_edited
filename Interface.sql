---------------------------------------------------------------------------------------------------------------------------------------------------------------

--                                                                     Phần nhân viên                                                                        --

--                                                                      

-- Xem khách hàng nào đạt được các mốc điểm 50,100,200,500 để thực hiện chương trình khuyến mại  

SELECT * FROM KH_DiemTichLuy( 3 /*Mốc điểm*/)


-- Tìm xem những khách hàng nào có ngày sinh hôm nay để áp dụng chương trình khuyến mãi

EXEC Sinh_Nhat
--Tìm mặt hàng có tên(gần giống) có đủ số lượng ít nhất mà khách hàng cần hay không

EXEC Check_If_Available '%',2  ---(/*Tên hàng - Dùng được cả regular expression hay Wild card*/, /*Số lượng ít nhất cần tìm*/)

-- Thêm khách hàng
                INSERT INTO KhachHang(HO_VA_TEN,SDT,DIA_CHI,NGAY_SINH)
                        VALUES(
                        N'Bùi Đức Thành',  -- HO_VA_TEN,
                            '020482754',-- SDT,
                            N'Thanh Hóa',-- DIA_CHI,
                            N'2001-02-10'-- NGAY_SINH
                        )
        SELECT * FROM KhachHang

-- Thêm hóa đơn cho khách hàng có mã là C_ID

 EXEC   ADD_BILL 
      --@param:
        @C_ID = 10 ,
        @NGUOI_NHAN = N'Mai Ngọc Đoàn' , 
        @DCGH = N'Hoàng Mai' ,
        @STD = '0385779443', 
        @PTTT , 
        @GC


-- Cập nhật mặt hàng có trong hóa đơn có B_ID
        EXEC Cap_nhat_mat_hang_trong_hoa_don
        --@param:
                @B_ID = 111 ,
                -- @H_ID = 101,
                -- @amount = 2,
                @command = 'end',                                        -- command : 'end','add' = default,'delete'
                @phiship = 15000

SELECT * FROM MatHang_HD


---------------------------------------------------------------------------------------------------------------------------------------------------------------

--                                                                     Phần Shipper                                                                       --
     
        EXEC Shipper_Confirm_Bill
        @Who = 1000,
        @WhichBill = 111 -- Shipper nào xác nhận đơn hàng có mã nào

        SELECT * from Shippers
---------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--                                                                     Phần Khách hàng                                                                       --

-- Khách hàng nhận được hàng, chỉ được xác nhận và đánh giá đơn hàng 1 lần
        EXEC Customer_Received
                @WhichBill = 111 , 
                @TinhTrang = N'ok em', 
                @danhgia   = 5 
-- Khách hàng hủy đơn hàng có mã B_ID, điều kiện là đơn hàng đó phải chưa được shipper nào xác nhận cả.
        EXEC Customer_Cancel 111  --@WhichBill






--                                                                      Phần Ngoài                                                                       --

-- thêm các cửa hàng, shipper vào bảng tính phí.
EXEC ADD_Phi
EXEC Update_ShipperFee -- Cập nhật phí dịch vụ cho shipper mỗi cuối tháng

EXEC NopPhi 100, 's',10,2021 -- @ID,@Ob,@mth,@yr: Shipper chỉ có thể nộp phí cho tháng trước đó, tức là phải hết 1 tháng làm việc mới được nộp.

-- Cuối tháng cần xem những thông tin  này:

        -- Xem những ai dang nợ tiền trong các tháng nhỏ hơn @thang

        SELECT * FROM TON_NO( 10,2021 ) --@thang, @nam

        -- Xem mặt hàng nào bán chạy nhất trong @thang
        EXEC Best_Selling 10 --@thang

        -- Xem tổng tiền mà công ty đã nhận được từ shipper và cửa hàng ( trừ những CH, SP nào chưa gửi tiền)
        EXEC Monthly_Revenue 10 --@thang


-- công việc tiếp tục: 
-- tạo procedure thêm shipper và cuahang
-- tìm xem cuahang nào có lượng hàng tiêu thụ mạnh nhất
-- tìm xem shipper nào hoạt động nhiều nhất(giao được nhiều hàng nhất) trong tháng