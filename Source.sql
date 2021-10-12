/*
    * Đồ án hệ cơ sở dữ liệu nhóm 9, lớp 65IT6
    * Thành Viên: Mai Ngọc Đoàn; Vũ Tiến Dũng(IT3), Vũ Tiến Dũng(IT6), Ninh Thị Thu Hà
    * Đoạn code dưới đây mô tả cấu trúc các bảng dữ liệu
    * cài đặt tên SQL server.
*/

-- CREATE DATABASE DO_AN_NHOM9
-- DROP DATABASE DO_AN_NHOM9
-- DROP TABLE CoSoCH
-- DROP TABLE CuaHang
-- DROP TABLE KhachHang
-- DROP TABLE MatHang
-- DROP TABLE MatHang_HD
-- DROP TABLE Shippers
-- DROP TABLE PhiCuaHang
-- DROP TABLE PhiShippers
-- DROP TABLE HoaDon



-- Bang Shippers:
/* 
    S_ID: bắt đầu bằng 1000, tự động tăng thêm 1 khi có bản ghi mới được thêm vào
    DANH_GIA : nằm trong đoạn từ 1 - 5, mặc định mỗi shipper mới có DANH_GIA = 3
    NGAY_VAO_LAM: mặc định là thời điểm shipper được cập nhật lên hệ thống
*/
CREATE TABLE Shippers(
    S_ID                    SMALLINT PRIMARY KEY IDENTITY(1000,1) ,
    HO_VA_TEN               NVARCHAR(30) NOT NULL,
    CMT                     CHAR(13) NOT NULL UNIQUE,
    SDT                     CHAR(13) NOT NULL UNIQUE,
    DIA_CHI                 NVARCHAR(50) NOT NULL,
    BIEN_SO_XE              NVARCHAR(20) NOT NULL UNIQUE,
    STK                     CHAR(15) UNIQUE,
    NGAY_VAO_LAM            DATE DEFAULT(GETDATE()),
    DANH_GIA                DECIMAL(2,1) CHECK ( DANH_GIA <= 5 and DANH_GIA >= 1 ) DEFAULT(3)
);
-- Bang KhanhHang
/*
    C_ID : Tự động tăng 1 đơn vị
    DIEM_TICH_LUY : luôn lớn hơn hoặc bằng 0, mặc định khách hàng mới có 0 điểm
*/
CREATE TABLE KhachHang(
    C_ID                    SMALLINT PRIMARY KEY IDENTITY(10,1),
    HO_VA_TEN               NVARCHAR(30) NOT NULL,
    SDT                     CHAR(13) NOT NULL UNIQUE,
    NGAY_SINH               DATE,
    DIA_CHI                 NVARCHAR(50) NOT NULL,
    DIEM_TICH_LUY           SMALLINT DEFAULT(0) CHECK( DIEM_TICH_LUY >= 0 )
);
-- Bang CuaHang
/*
    P_ID : Tự động tăng 1 đơn vị
    STK,SDT : là duy nhất
*/
CREATE TABLE CuaHang(
    P_ID                    SMALLINT PRIMARY KEY IDENTITY(1111,5),
    TEN_CUA_HANG            NVARCHAR(30) NOT NULL,
    TEN_NGUOI_DAI_DIEN      NVARCHAR(30) NOT NULL,
    SDT                     CHAR(13) NOT NULL UNIQUE,
    STK                     CHAR(15) UNIQUE,
    
);
-- Bang MatHang
/*
    H_ID : Tự động tăng 1 đơn vị
    P_ID : là khóa ngoại đến bảng CuaHang, yêu cầu mặt hàng trong bảng phải thuộc một cửa hàng nào đó
    CON_LAI : số lượng còn lại hàng trong kho ở mỗi cửa hàng, chỉ số này do cửa hàng cập nhật.
             mỗi một đơn hàng mua hàng có H_ID với số lượng X thì CON_LAI -= x 
*/
CREATE TABLE MatHang(
    H_ID                    SMALLINT PRIMARY KEY IDENTITY(100,1),
    P_ID                    SMALLINT FOREIGN KEY REFERENCES CuaHang(P_ID), --ON DELETE CASCADE
    TEN_MAT_HANG            NVARCHAR(20) NOT NULL,
    GIA                     INT NOT NULL,
    KHUYEN_MAI              INT NOT NULL DEFAULT(0),
    CON_LAI                 INT CHECK(CON_LAI >=0), -- Số lượng còn lại trong kho của cửa hàng.
);
-- Bang HoaDon
/*
    PHUONG_THUC_THANH_TOAN : yêu cầu chỉ có 2 loại, nếu nhập khác sẽ báo lỗi
    TRANG_THAI : thể hiện trạng thái của đơn hàng, nếu đơn hàng vừa mới được phát đi thì ở trạng thái "Chờ xác nhận"
                khi shipper xác nhận đơn hàng thì chuyển thành "Đang giao", khi khách hàng nhận hàng thì chuyển sang "Đã nhận".
    DANH_GIA_DON_HANG : thuộc đoạn [1,5]
    GHI_CHU : ghi yêu cầu của khách hàng đối với đơn hàng( thời gian khách hàng có thể nhận được hàng...).
*/
CREATE TABLE HoaDon(
    B_ID                    SMALLINT PRIMARY KEY IDENTITY(100,1),
    S_ID                    SMALLINT FOREIGN KEY REFERENCES Shippers(S_ID), --ON DELETE CASCADE
    C_ID                    SMALLINT FOREIGN KEY REFERENCES KhachHang(C_ID) ,--ON DELETE CASCADE,
    NGUOI_NHAN              NVARCHAR(30) NOT NULL,
    SDT_NGUOI_NHAN          CHAR(13) NOT NULL,
    DIA_CHI_GIAO_HANG       NVARCHAR(50) NOT NULL,
    PHI_SHIP_VND            INT DEFAULT(30000),
    KHUYEN_MAI_VND          INT DEFAULT (NULL) CHECK ( KHUYEN_MAI_VND >= 0),
    TONG_TIEN               INT  CHECK(TONG_TIEN >= 0),
    PHUONG_THUC_THANH_TOAN  NVARCHAR(50)  CHECK (PHUONG_THUC_THANH_TOAN =N'Thanh toán khi nhận hàng'
                                                 or PHUONG_THUC_THANH_TOAN = N'Chuyển khoản' ) 
                                                 DEFAULT(N'Thanh toán khi nhận hàng'),
    THOI_GIAN_DAT_HANG      DATETIME DEFAULT(GETDATE()),
    THOI_GIAN_SHIPPER_XAC_NHAN DATETIME,
    TRANG_THAI              NVARCHAR(20) CHECK( TRANG_THAI = N'Chờ xác nhận' 
                                        or TRANG_THAI = N'Đang giao'  or TRANG_THAI = N'Đã giao') 
                                        DEFAULT(N'Chờ xác nhận') ,
    THOI_GIAN_NHAN_HANG     DATETIME,
    TINH_TRANG_DON_HANG     NVARCHAR(50),
    DANH_GIA_DON_HANG       TINYINT CHECK( DANH_GIA_DON_HANG >=1 and DANH_GIA_DON_HANG<=5) DEFAULT(NULL),
    GHI_CHU                 NVARCHAR(100),
);
-- Bang MatHang_HD  // danh sach mat hang nam trong hoa don
CREATE TABLE MatHang_HD(
    H_ID                    SMALLINT FOREIGN KEY REFERENCES MatHang(H_ID),  -- ON DELETE CASCADE,
    B_ID                    SMALLINT FOREIGN KEY REFERENCES HoaDon(B_ID),  -- ON DELETE CASCADE,
    SO_LUONG                SMALLINT CHECK(SO_LUONG >=0),
                            CONSTRAINT PR_KEY PRIMARY KEY (H_ID, B_ID)
);
-- Bang CoSoCH
/*
    TRANG_THAI: Check xem cửa hàng có BA_ID nào tại thời điểm hiện tại đang mở cửa hay không
*/
CREATE TABLE CoSoCH(
    BA_ID                   SMALLINT ,
    P_ID                    SMALLINT FOREIGN KEY REFERENCES CuaHang(P_ID), --ON DELETE CASCADE,
    DIA_CHI                 NVARCHAR(100) NOT NULL,
                            CONSTRAINT PK_CS PRIMARY KEY (BA_ID, P_ID),
    TRANG_THAI              NVARCHAR(10) CHECK(TRANG_THAI = N'Đóng' or TRANG_THAI = N'Mở')
);

-- Bang PhiShippers // tinh phi duy tri cho shippers
CREATE TABLE PhiShippers(
    FS_ID                   SMALLINT PRIMARY KEY IDENTITY(100,1),
    S_ID                    SMALLINT FOREIGN KEY REFERENCES Shippers(S_ID) , -- ON DELETE CASCADE,
    THANG                   TINYINT DEFAULT(MONTH(GETDATE())),
    SO_TIEN_KIEM_DUOC_TRONG_THANG INT DEFAULT (NULL),
    TIEN_PHI_THANG          INT DEFAULT(NULL),
    TRANG_THAI              NVARCHAR(20) DEFAULT(N'Chưa nộp') CHECK (TRANG_THAI = N'Đã nộp' or TRANG_THAI = N'Chưa nộp'),
    THOI_GIAN_NOP           DATETIME,
);
-- Bang PhiCuaHang // tinh phi cho cua hang
CREATE TABLE PhiCuaHang(
    FP_ID                   SMALLINT PRIMARY KEY IDENTITY(100,1),
    P_ID                    SMALLINT FOREIGN KEY REFERENCES CuaHang(P_ID), -- ON DELETE CASCADE,
    THANG                   TINYINT DEFAULT(MONTH(GETDATE())),
    TIEN_PHI_THANG          INT DEFAULT(NULL) CHECK(TIEN_PHI_THANG>=0),
    TRANG_THAI              NVARCHAR(20) DEFAULT(N'Chưa nộp') CHECK (TRANG_THAI = N'Đã nộp' or TRANG_THAI = N'Chưa nộp'),
    THOI_GIAN_NOP           DATETIME,
);


-- DEFAULT(CONCAT_WS('-', MONTH(GETDATE()), YEAR(GETDATE()))),




--                                                                                                                         Mai Ngọc Đoàn