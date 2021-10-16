----------------------------------------Cài đặt database đồ án của nhóm 9--------------------


--  1, CuaHang:
        /*Cập nhật ID của CuaHang mới trong hệ thống vào bảng PhiCuaHang: */
    --CREATE OR ALTER PROCEDURE ADD_CuaHang AS
        INSERT INTO 
        PhiCuaHang(P_ID)
            SELECT P_ID from CuaHang 
                WHERE MONTH(GETDATE()) > ALL (
                        SELECT THANG FROM PhiCuaHang --- Trường hợp sang tháng mới
                    )  OR YEAR(GETDATE()) > ALL (
                        SELECT NAM FROM PhiCuaHang --- Trường hợp sang năm mới
                    )  OR P_ID != ALL (
                        SELECT P_ID from PhiCuaHang  --- Trường hợp có thêm CuaHang mới
                    )
        -------------------------------------------------------------------------------------
    -- -- SELECT * from PhiCuaHang

-- 2, Shippers
    --     /*Cập nhật ID của Shipper mới trong hệ thống vào bảng PhiShippers */

    --CREATE OR ALTER PROCEDURE ADD_Shipper AS

        INSERT INTO 
        PhiShippers(S_ID)
            SELECT S_ID from Shippers 
                WHERE MONTH(GETDATE()) > ALL (
                        SELECT THANG FROM PhiShippers
                    ) OR YEAR(GETDATE()) > ALL (
                        SELECT NAM FROM PhiShippers
                    ) OR S_ID != ALL (
                        SELECT S_ID from PhiShippers
                    )
                
        -- SELECT * from PhiShippers
/*Tính phí phải trả của Shipper mỗi cuối tháng và cập nhật vào trong bảng PhiShippers */
    --CREATE or ALTER PROCEDURE Update_ShipperFee AS
        UPDATE PhiShippers
            SET PhiShippers.SO_TIEN_KIEM_DUOC_TRONG_THANG = sSum.TONG_TIEN_SHIP ,
                PhiShippers.TIEN_PHI_THANG = sSum.PHI_PHAI_TRA
            FROM
                PhiShippers as s
                INNER JOIN
                (
                SELECT  HoaDon.S_ID,
                    SUM(HoaDon.PHI_SHIP_VND) as TONG_TIEN_SHIP,
                    SUM(HoaDon.PHI_SHIP_VND)*0.3 as PHI_PHAI_TRA,
                    -- Hệ số tính: Lấy 30% tổng số tiền phí ship mà shipper nhận được trong mỗi đơn hàng
                    MONTH(GETDATE()) as Thang ,
                    YEAR(GETDATE()) as NAM
                from HoaDon
                WHERE HoaDon.TRANG_THAI = N'Đã giao' 
                    AND  
                    MONTH(HoaDon.THOI_GIAN_NHAN_HANG) = MONTH(GETDATE())
                    AND 
                    YEAR(HoaDon.THOI_GIAN_NHAN_HANG) = YEAR(GETDATE())

                /*
                *chỉ những đơn hàng "Đã giao" thì hệ thống mới thực sự tính phí cho shipper, nếu đơn hàng ở trạng thái đang giao thì vẫn chưa coi
                 là một đơn hàng thành công -> shipper vẫn chưa nhận được tiền phí ship.
                * Điều kiện WHERE nhấn mạnh rằng tiền phí tháng/ năm nào thì phải tính cho shipper ở tháng/ năm đấy
                 */
                GROUP BY S_ID
                ) as sSum
                ON s.S_ID = sSum.S_ID and sSum.Thang = s.THANG and sSum.NAM = s.NAM



-----------------------------------------------------------------------------------------------------------------------------------------------------


-- kiểm tra mặt hàng có tên @name, số lượng ít nhất là @min có cửa hàng nào đáp ứng được không
    --CREATE OR ALTER PROCEDURE Check_If_Available @name NVARCHAR(10),@min INT = 1 AS
        SELECT H_ID,BA_ID,CuaHang.P_ID,TEN_CUA_HANG,DIA_CHI,TRANG_THAI,TEN_MAT_HANG,GIA,KHUYEN_MAI from 
        MatHang
        INNER JOIN
        CuaHang
        ON MatHang.P_ID = CuaHang.P_ID
        INNER JOIN
        CoSoCH
        ON CoSoCH.P_ID = CuaHang.P_ID
        WHERE   MatHang.CON_LAI >= @min and TRANG_THAI = N'Mở'  AND MatHang.TEN_MAT_HANG LIKE @name



-- Tạo một hóa đơn mới :
    --CREATE OR ALTER PROCEDURE ADD_BILL 
        @C_ID SMALLINT,
        @NGUOI_NHAN NVARCHAR(30) =  N'', 
        @DCGH NVARCHAR(60) = '',
        @STD CHAR(13) = '', 
        @PTTT NVARCHAR(40) ='', 
        @GC NVARCHAR(50) = N''
        AS
    -- Thêm hóa đơn cho khách hàng có mã id là @C_ID
        DECLARE @bid SMALLINT;
        -- Kiểm tra các tham số mặc địch, liệu có được thêm vào hay không?
            --- NGUOI NHAN
        IF (@NGUOI_NHAN != N'' and @STD != N'' and @STD != N'') or ( @NGUOI_NHAN = N'' and @STD = N'' and @DCGH = N'')
            BEGIN
                IF @NGUOI_NHAN != N'' and @STD != N'' and @STD != N''
                    BEGIN
                        INSERT INTO HoaDon( C_ID,NGUOI_NHAN,SDT_NGUOI_NHAN, DIA_CHI_GIAO_HANG ) 
                        VALUES(@C_ID,@NGUOI_NHAN,@STD,@DCGH)
                        SET @bid = (
                            SELECT B_ID FROM HoaDon WHERE C_ID = @C_ID and TRANG_THAI = N'Đang xử lý'
                        )
                        UPDATE HoaDon
                        SET NGUOI_NHAN = @NGUOI_NHAN,SDT_NGUOI_NHAN = @STD,DIA_CHI_GIAO_HANG = @DCGH
                        WHERE B_ID = @bid 
                    END
                IF @NGUOI_NHAN = N'' and @STD = N'' and @DCGH = N''
                    BEGIN
                        INSERT INTO HoaDon( C_ID,NGUOI_NHAN,SDT_NGUOI_NHAN, DIA_CHI_GIAO_HANG ) 
                        VALUES(@C_ID,@NGUOI_NHAN,@STD,@DCGH)
                        SET @bid = (
                                SELECT B_ID FROM HoaDon WHERE C_ID = @C_ID and TRANG_THAI = N'Đang xử lý'
                            )
                        SET @NGUOI_NHAN = (
                            SELECT HO_VA_TEN FROM KhachHang
                            WHERE @C_ID = C_ID
                        )
                        SET  @STD  = (
                            SELECT SDT FROM KhachHang
                            WHERE @C_ID = C_ID
                        )

                        SET @DCGH = (
                            SELECT DIA_CHI FROM KhachHang
                            WHERE @C_ID = C_ID
                        )
                        UPDATE HoaDon
                        SET NGUOI_NHAN = @NGUOI_NHAN,SDT_NGUOI_NHAN = @STD,DIA_CHI_GIAO_HANG = @DCGH
                        WHERE B_ID = @bid 
                    END
            END
        ELSE
            SELECT N'Bỏ trống(mặc định giá trị của khách hàng) @NGUOI_NHAN, @STD,@STD hoặc nhập cả 3 tùy chọn.' AS THAT_BAI
        -- SDT Nguoi nhan:
        --- DIA CHI GIAO HANG
        ---  PHUONG THUC THANH TOAN, NẾU KHÔNG GHI THÊM GÌ THÌ PTTT MẶC ĐỊNH LÀ THANH TOÁN KHI NHẬN HÀNG
        IF @PTTT != N''
            BEGIN
                UPDATE HoaDon
                SET PHUONG_THUC_THANH_TOAN = @PTTT
                WHERE B_ID = @bid 
            END
        --- Ghi chú
        IF @GC != N''
            BEGIN
                UPDATE HoaDon
                SET GHI_CHU = @GC
                WHERE B_ID = @bid 
            END
---------------------END-----------------




-- Ghi các mặt hàng có trong hóa đơn vào bảng MatHang_HD, hay 'thêm vào giỏ hàng'

    --CREATE OR ALTER PROCEDURE Cap_nhat_mat_hang_trong_hoa_don
        @B_ID SMALLINT, 
        @H_ID SMALLINT = -1,
        @amount TINYINT = 1,
        @command CHAR(10) ='add',
        @phiship INT = -1
        AS 
        /*
            @param: @command: 'add'; 'end'; 'delete'
                Có 3 trường hợp xảy ra:
                    khách hàng muốn thêm mặt hàng vào hóa đơn của mình
                    Khách hàng khi đã thêm hóa đơn nhưng lại thay đổi ý định và xóa mặt hàng đó ra khỏi hóa đơn vì một vài lý do
                    khách hàng xác nhận command = 'end' với trạng thái không có mặt hàng nào trong hóa đơn
                Ví dụ các cặp value - command hợp lệ(thường có):
                EXEC   Cap_nhat_mat_hang_trong_hoa_don @B_ID = 100, @H_ID =100, @command = 'add' // thêm mặt hàng 100 và hóa đơn mã 100, số lượng =1 
                EXEC   Cap_nhat_mat_hang_trong_hoa_don @B_ID = 100, @H_ID =100,@amount = n, @command = 'add' // thêm mặt hàng 100 và hóa đơn mã 100, số lượng = n
                EXEC   Cap_nhat_mat_hang_trong_hoa_don @B_ID = 100, @H_ID =100,@amount = n // thêm mặt hàng 100 và hóa đơn mã 100, số lượng = n
                EXEC   Cap_nhat_mat_hang_trong_hoa_don @B_ID = 100,@phiship = 30000,@command = 'end' // kết kết thúc hóa đơn, phí ship là 30000
                EXEC   Cap_nhat_mat_hang_trong_hoa_don @B_ID = 100,@H_ID = 101, @command = 'delete' // xóa mặt hàng 101 khỏi hóa đơn 100
        */
        -- Khai báo các biến số cần có
            DECLARE @soluonghangconlai TINYINT = (
                SELECT CON_LAI FROM MatHang
                WHERE MatHang.H_ID = @H_ID
            ); -- lấy số lượng còn lại của mặt hàng có mã @H_ID trong kho
            DECLARE @trangthai NVARCHAR(15)  = (
                select TRANG_THAI from HoaDon
                WHERE HoaDon.B_ID = @B_ID
            ); -- lấy trạng thái của đơn hàng có mã @B_ID
            DECLARE @checkZero TINYINT = (
                SELECT COUNT(H_ID) from MatHang_HD WHERE  B_ID = @B_ID
            )
            ------
        IF (LOWER(@command) = 'end' or LOWER(@command) = 'add' or  LOWER(@command)= 'delete') and @trangthai = N'Đang xử lý'
        BEGIN

            IF LOWER(@command)  = 'end' -- add có nghĩa là chốt đơn hàng, hóa đơn sẵn sàng được shipper xác nhận
                BEGIN

                    IF @checkZero = 0
                        BEGIN
                        -- Đơn hàng không có mặt hàng nào sẽ bị xóa khỏi hệ thống
                            DELETE FROM HoaDon WHERE B_ID = @B_ID
                        -- Thông báo
                            SELECT N'Đã xóa đơn hàng' AS XOA_DON_HANG
                        END

                    IF @phiship <= -1 and @checkZero !=0
                        BEGIN
                            SELECT N'Nhập phí ship cho đơn hàng!' AS CHUA_NHAP_PHI_SHIP  
                        END
                    IF @phiship >=0 and @checkZero !=0
                        BEGIN
                            UPDATE HoaDon
                            SET TRANG_THAI = N'Chờ xác nhận',TONG_TIEN = TONG_TIEN + @phiship,PHI_SHIP_VND = @phiship,THOI_GIAN_DAT_HANG = GETDATE()
                            WHERE B_ID = @B_ID
                            SELECT N'Đơn hàng đã chuyển sang trạng thái chờ' AS SUCCESS
                        END
                END 
            IF @H_ID IN (SELECT @H_ID FROM MatHang)
                BEGIN   
                    IF LOWER(@command)  = 'delete' -- delete có nghĩa là xóa mặt hàng có mã H_ID ra khỏi hóa đơn
                        BEGIN
                            SET @amount = (
                                SELECT SO_LUONG  FROM MatHang_HD WHERE @H_ID = H_ID and B_ID = @B_ID
                            ) -- lấy số lượng hàng có mã H_ID trong BILL mã B_ID
                            IF @amount != 0 or @amount != NULL
                                BEGIN 
                                    -- Trả lại hàng
                                    UPDATE MatHang
                                        SET MatHang.CON_LAI = (MatHang.CON_LAI + @amount) -- trả lại kho
                                        WHERE MatHang.H_ID = @H_ID
                                    ---- Xóa mặt hàng khỏi hóa đơn
                                    DELETE from MatHang_HD WHERE H_ID = @H_ID
                                    -- Cập nhật lại hóa đơn:
                                    UPDATE HoaDon
                                        SET HoaDon.TONG_TIEN = bSum.SUM, 
                                            HoaDon.KHUYEN_MAI_VND = bSum.DISCOUNT
                                    FROM (
                                        SELECT SUM( SO_LUONG* (GIA - KHUYEN_MAI)  )  as [SUM],
                                                SUM(SO_LUONG*KHUYEN_MAI) as DISCOUNT
                                        FROM VIEWALL -- XEM KHAI BÁO BẢNG VIEWALL ở dưới
                                        WHERE B_ID = @B_ID and TRANG_THAI = N'Đang xử lý'
                                    ) as bSum
                                    WHERE B_ID = @B_ID
                                END
                            ELSE
                                BEGIN
                                    SELECT N'Bạn đã xóa mặt hàng này rồi' AS THAT_BAI
                                END
                        END
                END
            IF  LOWER(@command) = 'add' -- add có nghĩa là add thêm hàng
                BEGIN
                    IF @soluonghangconlai >= @amount

                            -- Kiểm tra trong kho hàng có đủ lượng @amount khách hàng yêu cầu hay không.
                        BEGIN
                            -- Thêm vào giỏ hàng
                            INSERT INTO MatHang_HD(H_ID, B_ID,SO_LUONG) 
                                VALUES(
                                    @H_ID, -- H_ID; ID mặt hàng mua
                                    @B_ID,-- B_ID; ID hóa đơn mua
                                    @amount -- SO_LUONG 
                                )
                            -- sau khi (thêm) bán thì phải trừ đi số lượng đã bán trong bảng MatHang
                            UPDATE MatHang
                                SET MatHang.CON_LAI = (MatHang.CON_LAI - @amount)
                                WHERE MatHang.H_ID = @H_ID
                            -- Thêm hàng thì phải nhảy số tiền trên hóa đơn:
                            UPDATE HoaDon
                                SET HoaDon.TONG_TIEN = bSum.SUM, 
                                    HoaDon.KHUYEN_MAI_VND = bSum.DISCOUNT
                            FROM (
                                SELECT SUM( SO_LUONG* (GIA - KHUYEN_MAI)  )  as [SUM],
                                        SUM(SO_LUONG*KHUYEN_MAI) as DISCOUNT
                                FROM VIEWALL -- XEM KHAI BÁO BẢNG VIEWALL ở dưới
                                WHERE B_ID = @B_ID and TRANG_THAI = N'Đang xử lý'
                            ) as bSum
                            WHERE B_ID = @B_ID
                            -- Thông báo thêm mặt hàng thành công cho khách hàng biết
                            SELECT N'Thành công!' AS THANH_CONG
                            SELECT TONG_TIEN AS TAM_TINH FROM HoaDon WHERE B_ID = @B_ID
                        END
                    ELSE  -- Nếu kho không đủ thì không thực hiện cập nhật
                        BEGIN
                            (SELECT N'Thất bại, hãy thử lại.' AS THAT_BAI)
                        END
                END
                                
        END
    ELSE
        BEGIN
            SELECT N'Có lỗi xảy ra, xin thử lại' AS ERORR
        END


--    Shipper xác nhận đơn:
    --CREATE OR ALTER PROCEDURE Shipper_Confirm_Bill
        @Who SMALLINT, 
        @WhichBill SMALLINT AS
        /* 
        *@param: @Who - Mã id shipper
                @WhichBll - Mã id đơn hàng
        */
        UPDATE HoaDon
            SET S_ID = @Who , TRANG_THAI = N'Đang giao', THOI_GIAN_SHIPPER_XAC_NHAN = GETDATE()
        WHERE B_ID = @WhichBill AND TRANG_THAI = N'Chờ xác nhận'  -- chỉ những hóa đơn đang ở trạng thái "Chờ xác nhận" thì shipper mới có quyền nhận đơn



-----------------------------------------------------------------------------------------------------------------------------------------------------

 -- Khách hàng nhận hàng:
    --CREATE OR ALTER PROCEDURE Customer_Received @WhichBill SMALLINT, @TinhTrang NVARCHAR(50), @danhgia TINYINT AS
        /* 
        *@param:  @WhichBill- Mã id đơn hàng
                    @TinhTrang - Cho biết tình trạng, đánh giá tổng quan đơn hàng
                    @danhgia - Đánh giá cho shipper
        */
        UPDATE HoaDon
        SET TRANG_THAI = N'Đã giao', THOI_GIAN_NHAN_HANG = GETDATE(), TINH_TRANG_DON_HANG = @TinhTrang, DANH_GIA_DON_HANG = @danhgia
           WHERE B_ID = @WhichBill AND TRANG_THAI = N'Đang giao'


-- Khách hàng hủy đơn hàng có mã @WhichBill với điều kiện TRANG_THAI = N'Chờ xác nhận'  
    --CREATE OR ALTER PROCEDURE Customer_Cancel 
        @WhichBill SMALLINT AS

            DECLARE @TrangThai NVARCHAR(20) = (
                SELECT TRANG_THAI from HoaDon
            )

        IF @TrangThai = N'Chờ xác nhận'  
            BEGIN
                -- Chuyển hóa đơn về trạng thái hủy
                UPDATE HoaDon
                    SET TRANG_THAI = N'Đã hủy'
                WHERE B_ID = @WhichBill
                -- Trả lại hàng cho quán
                UPDATE MatHang
                    SET MatHang.CON_LAI = MatHang.CON_LAI + VIEWALL.SO_LUONG
                FROM  VIEWALL 
                WHERE VIEWALL.B_ID = @WhichBill AND VIEWALL.H_ID = MatHang.H_ID
            END
        ELSE
            SELECT N'Không thể hoàn tất,đơn hàng đang được giao. Hãy liên lạc với nhân viên để được biết thêm chi tiết.' AS THAT_BAI
            ---------------------------------------------------------------------------------------------------------------------------------------------------


-- 4, Cập nhật điểm tích lũy cho khách hàng, số sao cho Shipper:
    --CREATE or ALTER PROCEDURE UpdateKhachHangAndShipper AS
        -- Khách hàng mua một đơn hàng thành công sẽ +1 điểm tích lũy
        -- KhachHang
        UPDATE KhachHang
            SET KhachHang.DIEM_TICH_LUY = TinhDiem.DIEMTICHLUY
            from
                (SELECT C_ID, COUNT(C_ID) as DIEMTICHLUY from HoaDon
                WHERE TRANG_THAI = N'Đã giao'
                GROUP BY C_ID) AS TinhDiem
            WHERE TinhDiem.C_ID = KhachHang.C_ID
        
        -- Shippers
        -- Shipper giao hàng và được đánh giá sẽ được tính số đánh giá trung bình:
        UPDATE Shippers
            SET Shippers.DANH_GIA = DanhGia.DANH_GIA
        FROM 
        (SELECT S_ID, AVG( DANH_GIA_DON_HANG ) as DANH_GIA 
        from HoaDon
        GROUP BY S_ID ) as DanhGia
        WHERE Shippers.S_ID = DanhGia.S_ID
        
        -- Cập nhật số sao đánh giá, số điểm tích lũy liên tục


-- Nộp tiền phí:

    --CREATE OR ALTER PROCEDURE NopPhi 
        @ID_Phi TINYINT,
        @Who CHAR ,
        @month TINYINT,
        @year SMALLINT AS
        /*
        * @param: @ID_Phi : ID nộp phí trong bảng nộp phí, Shipper = FS_ID; CuaHang = FP_ID
                    @Who    : Chỉ định đối tượng nộp phí: 'S' or 's'-> Shipper; 'P' or 'p' -> CuaHang 
                    @month  : Chỉ định tháng mà đối tượng nộp phí
                    @year   : Chỉ định năm đối tượng đóng: // cần thiết cho năm vì trường hợp sang năm mới thì mới nộp cho tháng 12 năm trước
        */ 
        DECLARE @check NVARCHAR(10) = ( SELECT TRANG_THAI 
                                    from PhiShippers 
                                    WHERE FS_ID = @ID_Phi and THANG = @month
                                          and NAM = @year and TIEN_PHI_THANG IS NOT NULL)
            -- Nếu @check = '' thì có nghĩa là FS_ID không tồn tại trong hệ thống
        DECLARE @check1 NVARCHAR(10) = ( SELECT TRANG_THAI 
                                        from PhiCuaHang 
                                        WHERE FP_ID = @ID_Phi and THANG = @month
                                              and NAM = @year and TIEN_PHI_THANG IS NOT NULL)
            -- Nếu @check1 = '' thì có nghĩa là FP_ID không tồn tại trong hệ thống hoặc tháng không hợp lệ
            -- THƯỜNG xảy ra 3 trường hợp:
            --                    1: Không tồn tại @thang, @ID_Phi trong database
            --                    2: @ID_Phi trong @thang đã nộp tiền phí 
            --                    3: @ID_Phi trong @thang chưa nộp tiền phí 

        IF ( LOWER(@who) = 's' ) and @check != ''                                  
            BEGIN
                IF @check = N'Chưa nộp'  --- sau này thêm điều kiện check: @month < Month(Getdate()) để đảm bảo hết tháng shipper mới nộp được
                    BEGIN
                        UPDATE PhiShippers
                            SET TRANG_THAI = N'Đã nộp', THOI_GIAN_NOP = GETDATE()
                        WHERE FS_ID = @ID_Phi and THANG = @month and NAM = @year
                        SELECT N'Đã nộp thành công.' AS SUCCESS
                    END
                ELSE
                    SELECT N'Bạn đã nộp rồi!' AS SHIPPER_DA_NOP
            END
        IF (LOWER(@who) = 'p') and @check1 != ''   
            BEGIN
                IF @check1 = N'Chưa nộp'
                    BEGIN
                        UPDATE PhiCuaHang
                            SET TRANG_THAI = N'Đã nộp',THOI_GIAN_NOP = GETDATE()
                        WHERE FP_ID = @ID_Phi and THANG = @month and NAM = @year 
                        SELECT N'Đã nộp thành công.' AS SUCCESS
                    END
                ELSE
                    SELECT N'Bạn đã nộp rồi!' AS CUA_HANG_DA_NOP
            END
        ELSE
            SELECT N'Có lỗi xảy ra, xin vui lòng thử lại.' AS ERORR



-- Tính số tiền công ty đã nhận được từ việc nộp phí của Shipper và CuaHang
    --CREATE or ALTER PROCEDURE Monthly_Revenue 
        @thang int AS

        SELECT SUM(TONG.TONG) AS TONG_DOANH_THU FROM
            (SELECT SUM(TIEN_PHI_THANG) AS TONG FROM PhiShippers
                WHERE THANG = @thang AND TRANG_THAI = N'Đã nộp' and NAM = YEAR(GETDATE())
            UNION
            SELECT SUM(TIEN_PHI_THANG) AS TONG FROM PhiCuaHang
                WHERE THANG = @thang AND TRANG_THAI = N'Đã nộp' and NAM = YEAR(GETDATE())
            ) AS TONG



-----------------------------------------------------------------------------------------------------------------------------------------------------

--Đưa ra danh sách các khách hàng, shipper, chưa nộp phí dịch vụ trong tháng
    --- Gồm các shipper + Cửa hàng chưa nộp phí trong những tháng < @thang
    --CREATE OR ALTER FUNCTION TON_NO(@thang INT,@year SMALLINT)
    RETURNS TABLE 
    AS  
        RETURN
            SELECT PHI_ID,bang1.ID,TEN,THANG
            from
                (
                Select FS_ID AS PHI_ID,S_ID AS ID,THANG,NAM,TRANG_THAI from PhiShippers
                UNION
                SELECt FP_ID AS PHI_ID, P_ID AS ID,THANG,NAM,TRANG_THAI FROM PhiCuaHang

                AS bang1
                INNER JOIN
                (
                SELECT S_ID AS ID, HO_VA_TEN  AS TEN FROM Shippers
                UNION
                SELECT P_ID,TEN_CUA_HANG from CuaHang
                ) AS bang2
                ON bang1.ID = bang2.ID
            WHERE TRANG_THAI = N'Chưa nộp' AND THANG < @thang and NAM <= @year


 --Đưa ra danh sách khách hàng có điểm tích lũy đạt các mốc: 50,100,200,500
    --CREATE OR ALTER  FUNCTION KH_DiemTichLuy(@diem INT)
         RETURNS TABLE AS RETURN(
            SELECT * FROM dbo.KhachHang
            WHERE DIEM_TICH_LUY = @diem  -- Số điểm mốc cần truy cứu
         )



-- top 3 mặt hàng mua nhiều nhất trong tháng
    --CREATE PROCEDURE Best_Selling @thang INT AS
        SELECT TOP 3 H_ID,TEN_MAT_HANG, SUM(SO_LUONG) AS SO_LUONG_MUA
        FROM VIEWALL
        WHERE THANG = @thang AND NAM = YEAR(GETDATE())
        GROUP BY H_ID,TEN_MAT_HANG
        ORDER BY SO_LUONG_MUA DESC


-- Kiểm tra khuyến mại đang có 
    --CREATE OR ALTER PROCEDURE Check_Discount AS
                SELECT * from MatHang
                WHERE   KHUYEN_MAI > 0

-- 5 Tìm khách hàng có ngày sinh là ngày hôm nay:
    --Create or ALTER PROCEDURE Sinh_Nhat AS
        SELECT * from KhachHang
        WHERE DAY(NGAY_SINH) = DAY(Getdate()) and MONTH(NGAY_SINH) = MONTH(GETDATE())
---------------------------------------------------------------------------------------------------------------
    --CREATE or ALTER VIEW VIEWALL AS 
        SELECT 
            h.B_ID,
            m.H_ID,
            mh.TEN_MAT_HANG,
            h.C_ID,
            m.SO_LUONG,
            mh.CON_LAI,
            mh.GIA,
            mh.KHUYEN_MAI,
            h.PHI_SHIP_VND,
            h.TONG_TIEN,
            h.TRANG_THAI,
            h.DANH_GIA_DON_HANG,
            Month(h.THOI_GIAN_NHAN_HANG) AS THANG,
            YEAR(h.THOI_GIAN_NHAN_HANG) AS NAM
        from ( 
                HoaDon              AS h 
                INNER JOIN 
                    MatHang_HD      AS m 
                on m.B_ID = h.B_ID
                    INNER JOIN
                        MatHang     AS mh 
                    on mh.H_ID = m.H_ID
        )