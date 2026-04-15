# Lộ Trình Triển Khai Hệ Sinh Thái Đa Nền Tảng (Ultimate Roadmap)

Lộ trình này kết hợp toàn bộ các khía cạnh kỹ thuật từ bản quy hoạch, phân tích thực tế và yêu cầu đồ án tốt nghiệp thành một kế hoạch hành động từng bước cụ thể.

---

## GIAI ĐOẠN 0: CHUẨN BỊ LÕI BACKEND (Hạ tầng & CSDL)
*Mục tiêu: Biến Supabase hiện tại thành một "bộ não" hỗ trợ cả Web và Mobile.*

1.  **Kích hoạt Tiện ích (Extensions):**
    - Chạy SQL Migration để bật `postgis` (cho Bản đồ) và `vector` (cho AI).
2.  **Mở rộng Schema `tenants`:**
    - Thêm các cột tọa độ (`lat`, `long`) và địa chỉ.
    - Tạo Trigger tự động cập nhật kiểu dữ liệu `geography` để truy vấn GPS cực nhanh.
3.  **Khởi tạo Bảng AI & Logs:**
    - Tạo bảng `dharma_embeddings` để lưu tri thức Phật giáo.
    - Tạo bảng `geofencing_logs` để theo dõi hiệu quả thông báo tự động.

---

## GIAI ĐOẠN 1: CHUẨN BỊ DỮ LIỆU & TRI THỨC AI (RAG Pipeline)
*Mục tiêu: Làm sạch dữ liệu và nạp vào CSDL Vector.*

1.  **Lập chỉ mục (Indexing) Dữ liệu Chùa:**
    - Nhập tọa độ GPS cho 5-10 chùa trọng điểm hiện có.
2.  **Xây dựng Pipeline cho AI:**
    - Viết Script (Python hoặc Edge Function) để cắt nhỏ (chunking) nội dung từ bảng `about_sections` và `dharma_talks`.
    - Gọi API Gemini để lấy Vector Embedding và lưu vào bảng `dharma_embeddings`.
3.  **Kiểm thử tìm kiếm tương đồng (Similarity Search):**
    - Chạy thử các câu lệnh SQL Cosine Similarity để đảm bảo AI tìm được đúng ngữ cảnh khi Phật tử hỏi.

---

## GIAI ĐOẠN 2: NỀN MÓNG MOBILE APP (Flutter Foundation)
*Mục tiêu: Dựng bộ khung App ổn định với phong cách Zen Premium.*

1.  **Khởi tạo Dự án Flutter:**
    - Cài đặt cấu trúc thư mục tiêu chuẩn (Clean Architecture).
    - Cấu trúc Multi-tenant: App tự định dạng Theme (Màu sắc, Icon) dựa trên `tenant_id`.
2.  **Tích hợp Supabase SDK:**
    - Cài đặt Auth chung với Web (Người dùng có thể dùng 1 tài khoản cho cả 2 nơi).
3.  **Thiết kế UI "Zen Premium":**
    - Áp dụng Glassmorphism cho Bottom Navigation.
    - Xây dựng font chữ lớn, dễ đọc cho người cao tuổi.

---

## GIAI ĐOẠN 3: "ĐÔI MẮT" GIS & "TRÁI TIM" MINH BẠCH
*Mục tiêu: Triển khai các tính năng cốt lõi mang tính thực tế cao.*

1.  **Bản đồ Khám phá (Discovery):**
    - Tích hợp Google Maps API.
    - Code chức năng "Chùa gần tôi" sử dụng hàm `rpc` gọi vào PostGIS.
2.  **Cổng Phước Điền (Merit Gateway):**
    - Tích hợp VietQR động.
    - Xây dựng màn hình "Sổ cái minh bạch" hiển thị Real-time đóng góp.
3.  **Thông báo Geofencing:**
    - Cài đặt thư viện theo dõi vùng địa lý (Background Location).
    - Test luồng: Bước vào vùng 200m -> Nhận Push Notification chào mừng.

---

## GIAI ĐOẠN 4: THÔNG THÁI VỚI AI DHARMA BOT
*Mục tiêu: Đưa "Người thầy số" lên ứng dụng di động.*

1.  **Giao diện Chat:**
    - Thiết kế cửa sổ Chat linh thiêng, tôn nghiêm.
2.  **Kết nối Edge Function:**
    - Mobile gửi User Query -> Supabase Edge Function (RAG) -> Trả kết quả về App.
3.  **Tối ưu hóa Audio:**
    - Tích hợp trình phát nhạc (Audio Player) để Phật tử có thể nghe AI đọc câu trả lời hoặc nghe Pháp thoại.

---

## GIAI ĐOẠN 5: ĐÓNG GÓI & BẢO VỆ ĐỒ ÁN
*Mục tiêu: Hoàn thiện hồ sơ và số liệu khoa học.*

1.  **Kiểm thử Tải & Hiệu năng:**
    - Đo đạc tốc độ phản hồi của AI và Bản đồ.
2.  **Hoàn thiện Tài liệu (Thesis Packaging):**
    - Dùng dữ liệu thực tế từ App để chụp ảnh minh họa cho báo cáo.
    - Xuất các biểu đồ so sánh (SQL vs PostGIS) đã chuẩn bị.

---
*Lộ trình tổng hợp bởi Antigravity AI - 16/03/2026*
