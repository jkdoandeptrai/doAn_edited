--- 1 Quy trình đặt, giao, nhận hàng:
    -- Xem khách hàng nào có điểm tích lũy đạt mốc 50, 100, 200, 500
        SELECT * FROM KH_DiemTichLuy( 3 /*Mốc điểm*/)
    --- Xem khách hàng nào có sinh nhật vào ngày:
        SELECT * from KhachHang
        WHERE NGAY_SINH LIKE '%09-18' --'%---'
    --- Khách hàng đặt hàng bằng gọi điện, hoặc qua app. Nhân viên có nhiệm vụ thêm hóa đơn vào hệ thống
    -- Lấy thông tin khách hàng và lưu vào DB
        INSERT INTO KhachHang(HO_VA_TEN,SDT,DIA_CHI,NGAY_SINH)
            VALUES(
               N'Bùi Đức Nguyên',  -- HO_VA_TEN,
                '0294874884',-- SDT,
                N'Thanh Hóa',-- DIA_CHI,
                N'2001-02-10'-- NGAY_SINH
            )
        SELECT * FROM KhachHang
    -- Ghi nhận hóa đơn cho khách
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
        SELECT * from HoaDon
        SELECT * FROM KhachHang
        -- Tìm mặt hàng trong kho hàng 
        SELECT* from MatHang
        -- Tìm mặt hàng nào còn hay hết với số lượng ít nhất là bao nhiêu
        -- Kiểm tra số lượng mặt hàng còn lại trong kho xem có đáp ứng đủ số lượng cho khách hay không
        SELECT * FROM Check_If_Available ('%',2)  ---(/*Tên hàng - Dùng được cả regular expression hay Wild card*/, /*Số lượng ít nhất cần tìm*/)
        -- Tìm mặt hàng nào còn khuyến mãi:
        EXEC Check_Discount
        -- Cập nhật các mặt hàng trong hóa đơn
        EXEC Cap_nhat_mat_hang_trong_hoa_don  100, 100 ,7      -- @B_ID, @H_ID ,@amount : Parameters
        SELECT * FROM MatHang_HD
        -- Update tất cả các bill mới
        SELECT * FROM HoaDon
        EXEC Update_Bills 
        EXEC Customer_Cancel 100  --@WhichBill
        -- Shipper xác nhận đơn hàng:
        SELECT * FROM Shippers
        EXEC Shipper_Confirm_Bill 1000,100 @praS,@praB  -- Shipper nào xác nhận đơn hàng có mã nào

         -- Khách hàng nhận hàng thì xác nhận lên hệ thống
        EXEC Customer_Received 100,N'Tốt',3 @WhichBill , @TinhTrang, @danhgia  -- Khách hàng nhận được hàng, chỉ được xác nhận và đánh giá đơn hàng 1 lần
    -------------------------------------------Hết quy trình đặt, giao và nhận hàng------------------
-- Tính toán khác
    EXEC ADD_CuaHang  -- add vào bảng phí 
    EXEC ADD_Shipper  -- add vào bảng phí 
    EXEC UpdateKhachHangAndShipper
    EXEC Update_ShipperFee
    EXEC NopPhi 100, 's',10,2021 -- @ID,@Ob,@mth,@yr
    SELECT * FROM KhachHang
    SELECT * FROM Shippers
    SELECT * FROM PhiShippers
    SELECT * FROM PhiCuaHang
-- 2 Cuối tháng cần xem những thông tin  này:
    -- Xem những ai dang nợ tiền trong các tháng nhỏ hơn @thang
    SELECT * FROM TON_NO( 10,2021 ) --@thang, @nam
    -- Xem mặt hàng nào bán chạy nhất trong @thang
    EXEC Best_Selling 10 --@thang
    -- Xem tổng tiền mà công ty đã nhận được từ shipper và cửa hàng ( trừ những CH, SP nào chưa gửi tiền)
    EXEC Monthly_Revenue 10 --@thang

    SELECT * FROM VIEWALL

    




