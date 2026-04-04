# Changelog - Multitenant Mobile App

Tất cả các thay đổi lớn về tính năng và kiến trúc của ứng dụng Mobile sẽ được ghi lại tại đây theo chuẩn Keep a Changelog.

## [2026-04-04] - Kiến Trúc UI/UX "Heritage Editorial" & Tích Hợp RAG AI Cố Vấn

Ngày hôm nay đã đánh dấu sự thay đổi toàn diện từ giao diện cơ bản lên chuẩn cao cấp (Premium Zen) cũng như nền móng cơ sở hạ tầng phân tán AI.

### Thay đổi Kiến Trúc (Architecture)
- **Bottom Navigation (GlassNavigationBar):** Thiết kế lại thanh điều hướng dùng kính mờ (BackdropFilter 15px) mở rộng lên 5 tuỳ chọn chính (Home, Khám phá, Thầy Số, Pháp âm, Công đức) + 1 (Cá nhân) tạo thành 6 tab bằng GoRouter tích hợp tĩnh.
- **RAG Edge Streaming:** Triển khai API Edge Function `rag-chat` bằng TypeScript/Deno tích hợp bộ Supabase `pgvector`.
- **Database:** Bật `ivfflat` index, cung cấp hàm RPC `match_dharma_embeddings` để map vector khoảng cách Cosine `distance <=>`. Chuyển hoá cấu trúc `chat_messages` để chứa dữ liệu JSONB `citations` tracking nguồn gốc CSDL RAG.

### Added (Đã Thêm Mới)
- **Tab Công Đức (Merit):** Giao diện quét mã `MeritScreen` với typography tiền tệ siêu to, mã QR thẻ kính mờ điểm nhấn góc chữ V Vàng Saffron.
- **Sổ Vàng Danh Sách (MeritLedgerScreen):** Sổ ghi chép công đức dọc (No-lines UI), padding 24px để tạo độ trầm, kết hợp Noto Serif cổ điển. Phân chia rõ ngày tháng, số tiền và lời hồi hướng.
- **Thầy Số (AiChatScreen):** UI cuộc trò chuyện Glassmorphism, luồng StreamBuilder đọc trực tiếp từ Database khi Edge gõ phím. Bổ sung `Citation Badge` ghi nguồn gốc tri thức Phật giáo.
- **Map Discovery (Giai đoạn 4):** Refactor Modal Bottom Sheet và `TempleDetail` UI kiểu dáng Magazine.

### Changed (Cập nhật)
- Đổi quy chuẩn màu sắc hệ thống (`core/theme/colors.dart`): Saffron Gold (#d4af37), Bone White/Parchment (#fcf9f4), Deep Mahogany (#321716).
- Đổi quy chuẩn Typography: Sử dụng phối kết hợp `Noto Serif`/`Playfair Display` (Báo chí) + `Outfit`/`Manrope` (Hiện đại).
- T́i cấu trúc `app_router.dart` để mở rộng hệ thống Tab thay vì chỉ Stack Screens.

### Fixed (Sửa lỗi)
- Tối ưu hoá Dependency: Giải quyết sạch sẽ các lỗi caching `flutter clean`, lỗi sinh code `freezed` của DharmaMediaModel thông qua `build_runner`.
- Sửa lỗi cảnh báo TypeScript Deno trong phân hệ Backend bằng cấu hình `deno.json`.
