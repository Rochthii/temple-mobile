# DOCUMENT 19: CHIẾN LƯỢC PHÁT TRIỂN 5 BƯỚC - HỆ SINH THÁI ĐA CHÙA (MOBILE APP)

## 1. Triết lý phát triển (Development Philosophy)
- **Feature-Driven Development (FDD)**: Phát triển theo từng tính năng hoàn chỉnh từ Data -> Domain -> UI.
- **Clean Architecture**: Đảm bảo sự tách biệt giữa logic nghiệp vụ (Business Logic) và giao diện (UI).
- **AI-Powered Workflow**: Tối ưu hóa sự phối hợp giữa Lập trình viên và AI (Assistant) để đẩy nhanh tiến độ mà vẫn đảm bảo chất lượng Senior.

---

## 2. Quy trình 5 Bước thực hiện MVP

### BƯỚC 1: XÂY DỰNG NỀN MÓNG & KIẾN TRÚC LÕI (CORE & INFRASTRUCTURE)
**Mục tiêu**: Đảm bảo app chạy lên vững chãi, giao diện định hình sẵn, kết nối Backend thông suốt.
- **Thư viện cốt lõi**: `supabase_flutter`, `riverpod` (quản lý state), `go_router` (điều hướng).
- **Ngôn ngữ thiết kế (Premium Zen)**: Sử dụng mã màu Saffron (Vàng nghệ), Brown (Nâu trầm), Bone White (Trắng ngà). Hỗ trợ Glassmorphism.
- **Auth Flow**: Xử lý Login/Logout, lưu phiên đăng nhập, bảo mật Token.
- **💡 Phối hợp AI**: Yêu cầu AI viết `app_theme.dart` và Material 3 Theme chuẩn mực ngay từ đầu.

### BƯỚC 2: QUẢN LÝ NGỮ CẢNH ĐA CHÙA (TEMPLE CONTEXT)
**Mục tiêu**: Đảm bảo app không bao giờ bị lẫn lộn dữ liệu giữa các chùa (Multi-tenant Isolation).
- **State Management**: Quản lý 3 trạng thái: `all_temples`, `selected_temple`, `nearby_suggestion`.
- **UI Component**: `TempleContextBadge` (hiển thị ngữ cảnh hiện tại) và `TemplePickerModal` (để đổi chùa).
- **API Interceptor**: Mọi request lấy dữ liệu đều phải ràng buộc theo `selected_temple_id`.
- **💡 Phối hợp AI**: Yêu cầu AI viết logic Provider/Cubit để tự động kiểm tra ngữ cảnh trước khi truy cập các tính năng nhạy cảm.

### BƯỚC 3: XÂY DỰNG CÁC PHÂN HỆ MVP (MVP FEATURES)
**Mục tiêu**: Ráp UI và tính năng cho từng Tab chính.
- **Trang chủ & Cá nhân**: Màn hình News Feed, Profile người dùng.
- **Công Đức (Phước Điền)**: Nhập số tiền -> Sinh mã VietQR động -> Nhật ký công đức minh bạch.
- **Khám phá & Bản đồ (GIS)**: OpenStreetMap (OSM) + PostGIS (`find_nearby_temples`) để đưa tọa độ lên bản đồ.
- **Pháp âm (Dharma Media)**: Player phát nhạc/bài giảng (Play, Pause, Progress).
- **💡 Phối hợp AI**: Yêu cầu AI code widget `MeritCreateQRScreen` với xử lý validation tiền tệ và logic định dạng VNĐ.

### BƯỚC 4: TÍCH HỢP AI RAG BOT (DHARMA AI) - TÍNH NĂNG GHI ĐIỂM
**Mục tiêu**: Đưa "Người thầy số" vào ứng dụng, biến dữ liệu Pháp thoại thành trợ lý tương tác.
- **Backend (Edge Function)**: Viết hàm DenoJS nhận câu hỏi -> Embedding -> Vector Search trong `pgvector` -> Gemini AI trả lời.
- **Mobile UI**: Giao diện Chat chuyên nghiệp (typing indicator, bubble chat, Citation badges).
- **💡 Phối hợp AI**: Yêu cầu AI viết mã Edge Function và bóc tách JSON nguồn trích dẫn để hiển thị Chip Widget có thể click.

### BƯỚC 5: TỐI ƯU HÓA, KIỂM THỬ E2E & POLISH
**Mục tiêu**: Cảm giác mượt mà (Premium) và sẵn sàng đóng gói Build bài bản.
- **Skeleton & Shimmer**: Hiệu ứng bóng mờ khi chờ load dữ liệu thay cho vòng xoay nhàm chán.
- **Unit Testing**: Viết Test case cho `TempleContextState` để chứng minh khả năng quản lý Multi-tenant chặt chẽ với Hội đồng chấm thi.
- **Haptic & Feedback**: Thêm rung phản hồi khi nhấn nút, tối ưu cache hình ảnh để giảm tải CPU.
- **💡 Phối hợp AI**: Yêu cầu AI viết 3 Unit Test cases chuẩn mực bằng thư viện `mocktail`.

---

## 3. Tổng kết Chiến lược
Mỗi tính năng được hoàn thiện theo chu kỳ: **Phân tích -> Code Domain/Logic -> Code UI -> Nghiệm thu**. Cách làm này giúp tiến độ Đồ án luôn trong tầm kiểm soát và dễ dàng trình bày trước Hội đồng.
