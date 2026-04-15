# ☸️ Rochthii Temple Mobile App

Ứng dụng di động đa chùa (Multi-tenant) dành cho hệ sinh thái Phật giáo Nam tông Khmer. Xây dựng trên nền tảng Flutter, kết nối trực tiếp với hệ quản trị Web tập trung qua Supabase.

---

## 🚀 Chức năng chính

- **⛪ Danh sách Chùa (Multi-tenant)**: Khám phá hàng chục ngôi chùa với hình ảnh, bản đồ và thông tin liên hệ chi tiết.
- **🤖 Sư Số (AI Assistant)**: Trợ lý Pháp học thông minh hỗ trợ trả lời kinh sách Nam Tông 24/7 với phản hồi siêu tốc nhờ công nghệ Semantic Caching.
- **🙏 Phước Điền (Donations)**: Cúng dường minh bạch trực tiếp cho từng dự án của từng chùa.
- **Khám phá (Discovery Map):** Tìm kiếm và dẫn đường tới các ngôi chùa gần nhất dựa trên PostGIS.
- **Pháp âm & Thư viện:** Nghe pháp thoại và đọc kinh sách cổ số hóa.
- **Ghi sổ Công đức:** Tích hợp VietQR động, minh bạch dòng tiền cúng dường qua Zen Ledger.

---

## 🛠 Tech Stack

- **Frontend:** Flutter (Dart)
- **State Management:** Riverpod / Provider
- **Backend/DB:** Supabase (PostgreSQL + pgvector + RLS)
- **AI Engine:** Google Gemini 3 Flash & Gemini Embedding 001 (768px)
- **Maps:** OpenStreetMap (flutter_map)

---

## 📚 Tài liệu liên quan

Các chi tiết về kiến trúc và quy trình được lưu trữ trong thư mục `docs/`:
- [14_ARCHITECTURE_DETAIL.md](./docs/14_MOBILE_APP_ARCHITECTURE_DETAIL.md)
- [16_AI_WORKFLOW_DETAIL.md](./docs/16_MOBILE_AI_WORKFLOW_DETAIL.md)

---

## 🏁 Bắt đầu

1. **Cài đặt Flutter SDK** (>= 3.x)
2. **Cấu hình .env:** Sao chép các khóa Supabase từ hệ thống Web.
3. **Chạy ứng dụng:**
   ```bash
   flutter pub get
   flutter run
   ```
