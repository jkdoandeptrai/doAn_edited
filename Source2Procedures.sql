----------------------------------------Cài đặt database đồ án của nhóm 9--------------------

--Cập nhật ID của CuaHang mới trong hệ thống vào bảng PhiCuaHang:
    --CREATE OR ALTER PROCEDURE ADD_Phi AS
        -- cửa hàng
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
        -- Shippers tương tự
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


        -------------------------------------------------------------------------------------
--Tính phí phải trả của Shipper mỗi cuối tháng và cập nhật vào trong bảng PhiShippers 
    --CREATE or ALTER PROCEDURE Update_ShipperFee AS
        UPDATE PhiShippers
            SET PhiShippers.SO_TIEN_KIEM_DUOC_TRONG_THANG = sSum.TONG_TIEN_SHIP ,
                PhiShippers.TIEN_PHI_THANG = sSum.PHI_PHAI_TRA
            FROM
                PhiShippers as s
                INNER JOIN(
                SELECT  HoaDon.S_ID,
                        SUM(HoaDon.PHI_SHIP_VND) as TONG_TIEN_SHIP,
                        SUM(HoaDon.PHI_SHIP_VND)*0.3 as PHI_PHAI_TRA,
                        -- Hệ số tính: Lấy 30% tổng số tiền phí ship mà shipper nhận được trong mỗi đơn hàng
                        MONTH(GETDATE()) as Thang ,
                        YEAR(GETDATE()) as NAM
                    from HoaDon
                    WHERE HoaDon.TRANG_THAI = N'Đã giao' 
                    AND  MONTH(HoaDon.THOI_GIAN_NHAN_HANG) = MONTH(GETDATE())
                    AND  YEAR(HoaDon.THOI_GIAN_NHAN_HANG) = YEAR(GETDATE())
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
        -- Kiểm tra các tham số, liệu có được thêm vào hay không?
        -- bắt buộc cả 3 đều được hoặc không được thêm vào
        IF (@NGUOI_NHAN != N'' and @STD != N'' and @STD != N'') or ( @NGUOI_NHAN = N'' and @STD = N'' and @DCGH = N'')
            BEGIN
                -- nếu được thêm vào
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
                -- nếu không được thêm vào
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
                -- các tham số còn lại nếu được thêm vào thì cập nhật theo tham số, không thì sẽ về mặc định hoặc để trống
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
--------
            END
        ELSE
            SELECT N'Bỏ trống(mặc định giá trị của khách hàng) @NGUOI_NHAN, @STD,@STD hoặc nhập cả 3 tùy chọn.' AS THAT_BAI
        -------------END-----------------

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
                SELECT COUNT(H_ID) from MatHang_HD 
                WHERE  B_ID = @B_ID
            )
            ------ 
        -- Nếu @command hợp lệ
        -- và hóa đơn ở trạng thái đang xử lý thì mới thêm vào được
        IF (LOWER(@command) = 'end' or LOWER(@command) = 'add' or  LOWER(@command)= 'delete') and @trangthai = N'Đang xử lý'
        BEGIN
            IF LOWER(@command)  = 'end' -- add có nghĩa là chốt đơn hàng, hóa đơn sẵn sàng được shipper xác nhận
                BEGIN
                    -- nếu command là 'end' thì cần kiểm tra liệu hóa đơn đó có rỗng hay không
                    IF @checkZero = 0
                        BEGIN
                        -- Đơn hàng không có mặt hàng nào sẽ bị xóa khỏi hệ thống
                            DELETE FROM HoaDon WHERE B_ID = @B_ID
                        -- Thông báo
                            SELECT N'Đã xóa đơn hàng' AS XOA_DON_HANG
                        END
                    ELSE
                        BEGIN
                            IF @phiship <= -1 -- Chưa chỉ định phí ship
                                BEGIN
                                    SELECT N'Nhập phí ship cho đơn hàng!' AS CHUA_NHAP_PHI_SHIP  
                                END
                            ELSE -- chỉ định phí ship rồi thì cập nhật 
                                BEGIN
                                    UPDATE HoaDon
                                    SET TRANG_THAI = N'Chờ xác nhận',TONG_TIEN = TONG_TIEN + @phiship,PHI_SHIP_VND = @phiship,THOI_GIAN_DAT_HANG = GETDATE()
                                    WHERE B_ID = @B_ID
                                    SELECT N'Đơn hàng đã chuyển sang trạng thái chờ' AS SUCCESS
                                END
                        END
                END 
            --
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

                            SELECT N'Bạn đã xóa thành công' as XOA_THANH_CONG
                        END
                    ELSE
                        BEGIN
                            SELECT N'Mặt hàng này không còn tồn tại trong hóa đơn!' AS THAT_BAI
                        END

                END
            ---
            IF  LOWER(@command) = 'add' -- add có nghĩa là thêm mặt hàng vào trong hóa đơn
                BEGIN
                    IF @soluonghangconlai >= @amount
                        -- Kiểm tra trong kho hàng có đủ lượng hàng là @amount mà khách hàng yêu cầu hay không.
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
            --           
        END
    ELSE
        BEGIN
            SELECT N'Có lỗi xảy ra, xin thử lại' AS ERORR
        END


--Shipper xác nhận đơn:
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
    --CREATE OR ALTER PROCEDURE Customer_Received 
        @WhichBill SMALLINT, 
        @TinhTrang NVARCHAR(50), 
        @danhgia TINYINT 
        AS
        /* 
        *@param:  @WhichBill- Mã id đơn hàng
                    @TinhTrang - Cho biết tình trạng, đánh giá tổng quan đơn hàng
                    @danhgia - Đánh giá cho shipper
        */
        DECLARE @SID SMALLINT = (
            SELECT S_ID FROM HoaDon
            WHERE B_ID = @WhichBill
        )
        DECLARE @KH SMALLINT = (
            SELECT C_ID FROM HoaDon
            WHERE B_ID = @WhichBill
        )
        UPDATE HoaDon
        SET TRANG_THAI = N'Đã giao', THOI_GIAN_NHAN_HANG = GETDATE(), TINH_TRANG_DON_HANG = @TinhTrang, DANH_GIA_DON_HANG = @danhgia
           WHERE B_ID = @WhichBill AND TRANG_THAI = N'Đang giao'
        -- khách hàng nhận hàng thành công -> cộng 1 điểm tích lũy:
        DECLARE @TTH NVARCHAR(50) = (
            SELECT TRANG_THAI FROM HoaDon WHERE B_ID = @WhichBill
        )
        IF @TTH != N'Đã giao'
            BEGIN
                UPDATE KhachHang
                SET DIEM_TICH_LUY = DIEM_TICH_LUY + 1
                WHERE C_ID = @KH
            -- tương tự với shippers, cập nhật đánh giá trung bình:
                UPDATE Shippers
                    SET Shippers.DANH_GIA = DanhGia.DANH_GIA
                FROM (
                    SELECT S_ID, AVG( DANH_GIA_DON_HANG ) as DANH_GIA 
                    from HoaDon
                    WHERE S_ID = @SID
                    GROUP BY S_ID 
                ) as DanhGia
                WHERE Shippers.S_ID = @SID
            END
        ELSE
            SELECT N'Don hang da duoc xac nhan roi!' AS ERORR

-- Khách hàng hủy đơn hàng có mã @WhichBill với điều kiện TRANG_THAI = N'Chờ xác nhận'
    --CREATE OR ALTER PROCEDURE Customer_Cancel 
        @WhichBill SMALLINT AS

            DECLARE @TrangThai NVARCHAR(20) = (
                SELECT TRANG_THAI from HoaDon
                WHERE B_ID = @WhichBill
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



-- Nộp tiền phí:

    -- CREATE OR ALTER PROCEDURE NopPhi 
        @ID_Phi INT,
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
        IF (@month < MONTH(GETDATE()) and @year = YEAR(GETDATE()) )-- Dành cho những tháng nhỏ hơn 11.
            or @year < YEAR(GETDATE())
        BEGIN
            IF ( LOWER(@who) = 's' ) and @check != ''                                  
                BEGIN
                    IF @check = N'Chưa nộp'
                        BEGIN
                            UPDATE PhiShippers
                                SET TRANG_THAI = N'Đã nộp', THOI_GIAN_NOP = GETDATE()
                            WHERE FS_ID = @ID_Phi and THANG = @month and NAM = @year
                            SELECT N'Đã nộp thành công.' AS SUCCESS
                        END
                    ELSE
                        SELECT N'Bạn đã nộp rồi!' AS SHIPPER_DA_NOP
                END
            ELSE
                BEGIN
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
                END
        END
        ELSE
        BEGIN
            SELECT N'Ban chua den thoi han phai nop phi, quay lai vao thang sau!' AS ERORR
        END


-- Tính số tiền công ty đã nhận được từ việc nộp phí của Shipper và CuaHang
    --CREATE or ALTER PROCEDURE Monthly_Revenue 
        @thang int AS

        SELECT SUM(TONG.TONG) AS TONG_DOANH_THU FROM(
                SELECT SUM(TIEN_PHI_THANG) AS TONG FROM PhiShippers
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
            SELECT PHI_ID,bang1.ID,TEN,THANG, TIEN_PHI_THANG as PHI_CON_NO
            from(
                Select FS_ID AS PHI_ID,S_ID AS ID,THANG,NAM,TRANG_THAI, TIEN_PHI_THANG from PhiShippers
                UNION
                SELECt FP_ID AS PHI_ID, P_ID AS ID,THANG,NAM,TRANG_THAI, TIEN_PHI_THANG FROM PhiCuaHang
                )
                AS bang1
                INNER JOIN(
                    SELECT S_ID AS ID, HO_VA_TEN  AS TEN FROM Shippers
                    UNION
                    SELECT P_ID,TEN_CUA_HANG from CuaHang
                ) AS bang2
                ON bang1.ID = bang2.ID
            WHERE TRANG_THAI = N'Chưa nộp' AND THANG <= @thang and NAM <= @year


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

-- Tìm khách hàng có ngày sinh là ngày hôm nay:
    --Create or ALTER PROCEDURE Sinh_Nhat AS
        SELECT * from KhachHang
        WHERE DAY(NGAY_SINH) = DAY(Getdate()) and MONTH(NGAY_SINH) = MONTH(GETDATE())

-- tìm xem cuahang nào có mặt hàng tiêu thụ mạnh nhất
        --CREATE OR ALTER PROCEDURE _MVP_ @when VARCHAR(10) AS
        -- tìm số lượng bán được của mặt hàng chiếm lượng tiêu thụ lớn nhất:
        --<B1>: tìm số lượng bán ra nhiều nhất trong tất cả mặt hàng là bao nhiêu
        DECLARE @MHLN INT = (
            SELECT MAX(BANG7.SL) AS MAX_SL FROM(
                SELECT H_ID, SUM(SO_LUONG) AS SL FROM VIEWALL
                WHERE CONVERT(char,THOI_GIAN_DAT_HANG,103) LIKE @when
                GROUP BY H_ID
            ) AS BANG7
        )
        --</B1>
        -- Tìm cửa hàng:
        --<B5>: lấy thông tin cửa hàng
        SELECT * FROM CuaHang
        WHERE P_ID = ANY(
            -- <B4>: chọn các P_ID khác nhau có chứa mặt hàng H_ID bán chạy nhất
            SELECT DISTINCT P_ID FROM MatHang
            WHERE H_ID = ANY (
                -- <B3>: Chọn các H_ID có tổng lượng hàng bán chạy nhất:
                SELECT H_ID FROM(
                    --<B2>: tính tổng số lượng bán ra của mỗi mặt hàng
                    SELECT H_ID, SUM(SO_LUONG) AS SL FROM VIEWALL
                    WHERE CONVERT(char,THOI_GIAN_DAT_HANG,103) LIKE @when
                    GROUP BY H_ID
                    --</B2>
                ) AS BANG8
                WHERE BANG8.SL = @MHLN
                -- </B3>
            )
            --</B4>
        )
        --</B5>
        
-- Danh sách mặt hàng không bán được trong tháng
    --CREATE OR ALTER PROCEDURE DeadStock @when VARCHAR(10) AS  -- @when like : '%10/2021'
        SELECT H_ID, TEN_MAT_HANG FROM MatHang
        WHERE H_ID != ALL(
            SELECT H_ID FROM
            VIEWALL
            WHERE CONVERT(char,THOI_GIAN_DAT_HANG,103)  LIKE  @when -- vì THOI_GIAN_DAT_HANG là kiểu datetime nên gặp rắc rối khi 
            --                                                          dùng LIKE, vậy ta chuyển về định dạng dd/mm/yyyy
        )
-- tìm xem shipper nào hoạt động nhiều nhất(giao được nhiều đơn hàng nhất) trong tháng
    --CREATE OR ALTER PROCEDURE _MVS_ @when VARCHAR(10) AS
        DECLARE @MVS SMALLINT = (
            SELECT MAX(SL) FROM(
                SELECT COUNT(B_ID) AS SL FROM HoaDon
                WHERE CONVERT(char,THOI_GIAN_DAT_HANG,103)  LIKE  @when
                GROUP BY S_ID
            ) AS MVS
        )
        SELECT S_ID, HO_VA_TEN FROM Shippers
        WHERE S_ID = ANY(
            SELECT S_ID FROM(
                SELECT S_ID, COUNT(B_ID) AS SL FROM HoaDon
                WHERE CONVERT(char,THOI_GIAN_DAT_HANG,103)  LIKE  @when
                GROUP BY S_ID
            ) AS MVS2
            WHERE SL = @MVS
        )
-- tìm xem khách hàng nào có điểm tích lũy tăng nhiều nhất (hay số đơn hàng mua nhiều nhất tháng):
    --CREATE OR ALTER PROCEDURE _MVC_ @when VARCHAR(10) AS
        DECLARE @MVC INT = (
            SELECT MAX(MVC) FROM(
                SELECT COUNT(B_ID) AS MVC FROM HoaDon
                WHERE TRANG_THAI !=N'Đã hủy' AND CONVERT(char,THOI_GIAN_DAT_HANG,103)  LIKE  @when
                GROUP BY C_ID
            ) AS MVC
        )
        SELECT C_ID,HO_VA_TEN,SDT FROM KhachHang
        WHERE C_ID = ANY(
            SELECT C_ID FROM(
                SELECT C_ID,COUNT(B_ID) AS MVC FROM HoaDon
                WHERE TRANG_THAI !=N'Đã hủy' AND CONVERT(char,THOI_GIAN_DAT_HANG,103)  LIKE  @when
                GROUP BY C_ID
            ) AS MVC1
            WHERE MVC = @MVC
        ) 
    -- --CREATE OR ALTER PROCEDURE SortByFee @month INT, @year INT AS
    -- SELECT *  FROM (
    --     SELECT Shippers.S_ID, FS_ID, HO_VA_TEN,THANG, NAM, SO_TIEN_KIEM_DUOC_TRONG_THANG FROM
    --     PhiShippers
    --     INNER JOIN Shippers
    --     ON PhiShippers.S_ID = Shippers.S_ID
    --     WHERE THANG = @month and NAM = @year
    --     ORDER BY SO_TIEN_KIEM_DUOC_TRONG_THANG DESC
    -- ) as temp
---------------------------------------------------------------------------------------------------------------
    --CREATE or ALTER VIEW VIEWALL AS 
        SELECT 
            h.B_ID,
            h.S_ID,
            m.H_ID,
            MH.P_ID,
            mh.TEN_MAT_HANG,
            h.C_ID,
            m.SO_LUONG,
            mh.CON_LAI,
            mh.GIA,
            mh.KHUYEN_MAI,
            h.PHI_SHIP_VND,
            h.TONG_TIEN,
            h.TRANG_THAI,
            h.THOI_GIAN_DAT_HANG,
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
        ) WHERE h.TRANG_THAI != 'Đã hủy'