-- với mỗi tháng, trung bình mỗi khách hàng bỏ ra bao nhiêu để mua sắm.
SELECT* FROM HoaDon

SELECT MONTH(THOI_GIAN_DAT_HANG) AS [MONTH], AVG(TONG_TIEN) AS [AVG] FROM HoaDon
GROUP BY MONTH(THOI_GIAN_DAT_HANG)
-- trung bình một năm mỗi khách hàng bỏ ra bao nhiêu cho việc mua sắm.
SELECT YEAR(THOI_GIAN_DAT_HANG) AS [YEAR], AVG(TONG_TIEN) AS [AVG] FROM HoaDon
WHERE YEAR(THOI_GIAN_DAT_HANG) = YEAR(GETDATE())
GROUP BY YEAR(THOI_GIAN_DAT_HANG)

