-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Xem khách hàng nào đạt được các mốc điểm 50,100,200,500 để thực hiện chương trình khuyến mại  
SELECT * FROM KH_DiemTichLuy( 0 /*Mốc điểm*/)
Select* from KhachHang
-- Xem cửa hàng nào có mặt hàng bán chạy nhất tháng:
EXEC _MVP_ @when = '%10/2021'
-- Xem shipper nào hoạt động tích cực nhất tháng:
EXEC _MVS_ @when = '%10/2021'
-- tìm xem khách hàng nào có điểm tích lũy tăng nhiều nhất(hay số đơn hàng mua nhiều nhất tháng):
EXEC _MVC_ @when = '%10/2021'
-- Tìm xem những khách hàng nào có ngày sinh hôm nay để áp dụng chương trình khuyến mãi
EXEC Sinh_Nhat
--Tìm mặt hàng có tên(gần giống) có đủ số lượng ít nhất mà khách hàng cần hay không
EXEC Check_If_Available '%Coca&',10  ---(/*Tên hàng - Dùng được cả regular expression (hay Wild card)*/, /*Số lượng ít nhất cần tìm*/)
Select* from MatHang
-- thêm các cửa hàng, shipper vào bảng tính phí.
EXEC ADD_Phi

-- Tính phí cho Shipper
EXEC Update_ShipperFee -- Cửa hàng tính phí cố định theo thỏa thuận, không phụ thuộc vào đơn hàng nên không cần cập nhật dạng này.

EXEC NopPhi 102, 's',10,2021 -- @ID,@Ob,@mth,@yr: Shipper chỉ có thể nộp phí cho tháng trước đó, tức là phải hết 1 tháng làm việc mới được nộp.
Select* from PhiShippers
-- Xem những ai đang nợ tiền trong các tháng nhỏ hơn @thang
SELECT * FROM TON_NO( 12,2021 ) --@thang, @nam
-- Xem mặt hàng nào bán chạy nhất trong @thang
EXEC Best_Selling 10 --@thang
-- Xem mặt hàng không bán được trong tháng
EXEC DeadStock @when = '%10/2021'
-- Xem tổng tiền mà công ty đã nhận được từ shipper và cửa hàng ( trừ những CH, SP nào chưa gửi tiền)
EXEC Monthly_Revenue 10 --@thang
-- tự động lấy năm là năm hiện tại -> không cần nhập năm.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Thêm khách hàng
        INSERT INTO KhachHang(HO_VA_TEN,SDT,DIA_CHI,NGAY_SINH)
                VALUES(
                N'Mai Ngoc Doan',  -- HO_VA_TEN,
                        '0385779443',-- SDT,
                        N'Thanh Hóa',-- DIA_CHI,
                        N'2001-09-18'-- NGAY_SINH
                )
        SELECT * FROM KhachHang

-- Thêm hóa đơn cho khách hàng có mã là C_ID
         EXEC   ADD_BILL 
        --@param:
                @C_ID= 13 ,
                @NGUOI_NHAN= N'Mai Ngoc Doan' , 
                @DCGH= N'Hoàng Mai' ,
                @STD= '0385779443', 
                @PTTT= N'Thanh toán khi nhận hàng', 
                @GC= N'Gửi vào giờ hành chính.'
        -- @PTTT & @GC có thể bỏ trống
        -- @C_ID, @NGUOI_NHAN, @DCGH buộc cả 3 có hoặc không có(không có thì để mặc định thông tin đối với khách hàng có @C_ID)
Select* from HoaDon
-- Cập nhật mặt hàng có trong hóa đơn có B_ID
        EXEC Cap_nhat_mat_hang_trong_hoa_don
        --@param:
                @B_ID= 117 ,
                -- @H_ID = 101,
                -- @amount = 3,
                @command= 'end',                                        -- command : 'end','delete', default= 'add'
                @phiship= 15000
        -- lúc này hóa đơn đang ở trạng thái 'đang xử lý' tức là hóa đơn được thay đổi thông tin mặt hàng và không thể bị 'xác nhận'
        -- EXEC Cap_nhat_mat_hang_trong_hoa_don @B_ID = 10,@H_ID=11                // Thêm 1 mặt hàng ID=11 vào hóa đơn ID=10 ;Optional param: command='add'
        -- EXEC Cap_nhat_mat_hang_trong_hoa_don @B_ID = 10,@H_ID=11,@amount=3      // Thêm 3 mặt hàng ID=11 vào hóa đơn ID=10
        -- EXEC Cap_nhat_mat_hang_trong_hoa_don @B_ID = 10,@H_ID=11,@command='delete'     // Xóa mặt hàng ID=11 ra khỏi hóa đơn ID=10, command = 'delete'
        -- EXEC Cap_nhat_mat_hang_trong_hoa_don @B_ID = 10,@phiship=50000,@command='end'  // Cập nhật tiền ship cho đơn hàng và kết thúc việc chỉnh sửa hóa đơn
        --                                                                                   đưa hóa đơn vào trạng thái 'chờ xác nhận'
        -- Nếu hóa đơn được tạo mà @command = 'end' khi không có đơn hàng nào sẽ tự động bị xóa ra khỏi hệ thông và không lưu.
        -- Trước khi đơn hàng chuyển trang trạng thái 'đang giao' thì khách hàng có thể thực hiện hủy đơn
        -- và đơn hàng đó được chuyển sang trạng thái 'hủy' và vẫn được lưu vào hệ thống.
        EXEC Customer_Cancel 
                @WhichBill = 117 
        -- Hủy đơn hàng ID=10
        SELECT * FROM MatHang_HD
-- Khi khách hàng đưa hóa đơn từ trạng thái 'xử lý' sang 'chờ' thì shipper có thể xác nhận nhận đơn hàng đó.
        EXEC Shipper_Confirm_Bill
                @Who = 1000, -- Mã id của shipper
                @WhichBill = 117 --Đơn hàng có mã nào
                -- Hóa đơn sang trạng thái 'đang giao'
SELECT * from Shippers 

-- Khách hàng nhận được hàng, chỉ được xác nhận và đánh giá đơn hàng 1 lần
        EXEC Customer_Received
                @WhichBill = 117 ,      -- mã đơn hàng đã nhận được
                @TinhTrang = N'Tốt',  -- để lại đánh giá đơn hàng, tình trạng khi nhận được
                @danhgia   = 5          -- đánh giá cho shipper
        -- Khi khách hàng thực hiện xác nhận thì:
        --  +, Khách hàng được cộng 1 điểm tích lũy.
        --  +, Shipper được tính trung bình đánh giá cho mình

--- hết---Nhóm 9-----65IT3-----Huce-------Nuce-----Đại học Xây dựng-----Mai Ngọc Đoàn---Ninh Thu Hà---Vũ Tiến Dũng---Vũ Tiến Dũng(IT6)--------------------------------