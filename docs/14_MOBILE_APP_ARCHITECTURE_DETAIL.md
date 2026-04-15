# Kế hoạch chi tiết: Hệ sinh thái Ứng dụng Di động (Mobile App Ecosystem)

Dự án này mở rộng nền tảng Web hiện tại thành một hệ sinh thái đa kênh (Cross-platform), lấy dữ liệu từ Supabase làm hướng tâm (Single Source of Truth).

---

## 1. Kiến trúc Hệ thống (System Architecture)

```mermaid
graph TD
    subgraph "Cloud Backend (Supabase)"
        DB[(PostgreSQL + pgvector)]
        Storage[Supabase Storage]
        Auth[Supabase Auth]
        Edge[Edge Functions - Deno RAG AI streaming]
    end

    subgraph "Admin & Content (Web)"
        NextAdmin[Next.js Admin Dashboard]
        CMS[Headless CMS Logic]
    end

    subgraph "Mobile Client (Flutter - Heritage Editorial UI)"
        App[Flutter App - Super Client]
        Nav[Glass Bottom Navigation Bar]
        HomeTab[Home - Smart Feed]
        MapTab[Discovery - OpenStreetMap]
        AITab[Sư Số - Trợ lý Pháp học AI]
        DharmaTab[Dharma - Media Player]
        MeritTab[Merit - Transparent Ledger & VietQR]
        ProfileTab[Profile - Config]
    end

    NextAdmin --> DB
    App --> DB
    App --> Storage
    App --> Auth
    Edge --> DB
    App -.->|SSE Stream| Edge
```

---

## 2. Thiết kế Cơ sở Dữ liệu (Database Schema Extensions)

Để hỗ trợ tính năng **Khám phá (Discovery)** và **Địa lý (Geofencing)**, cần mở rộng bảng `tenants`:

| Trường (Field) | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `latitude` | `FLOAT8` | Vĩ độ thực tế của chùa |
| `longitude` | `FLOAT8` | Kinh độ thực tế của chùa |
| `geog` | `GEOGRAPHY(POINT)` | Kiểu dữ liệu PostGIS để truy vấn bán kính nhanh |
| `address_vi` | `TEXT` | Địa chỉ chi tiết |
| `province_id` | `UUID` | Liên kết đến bảng tỉnh thành để lọc |

---

## 3. Chi tiết các Phân hệ chức năng

### **A. Khám phá (Discovery - Map & GPS)**
- **Công nghệ:** flutter_map (OpenStreetMap) + PostGIS.
- **Tính năng ĐATN:** 
    - Truy vấn SQL "Chùa gần tôi" sử dụng toán tử `<->` trong PostGIS để đạt hiệu năng O(1) với Index GIST.
    - **Geofencing:** Khi `current_location` nằm trong bán kính 200m của `geog`, gửi thông báo chào mừng qua FCM.

### **B. Pháp âm (Dharma - Audio Library)**
- **Công nghệ:** `just_audio` + `audio_service` (chạy nền).
- **Tính năng ĐATN:** 
    - **Offline Sync:** Sử dụng `Isar` hoặc `Hive` để lưu metadata kinh sách.
    - Đồng bộ bài giảng từ `dharma_talks` trên Web Admin.

### **C. Công Đức & Minh Bạch (Merit - Zen Ledger)**
- **Tính năng ĐATN:**
    - Tích hợp **VietQR** động: Tự động truyền số tiền và nội dung vào QR, trình bày trong Giao diện "Frosted Glass".
    - **Sổ Vàng Công Đức (Minh bạch):** Hiển thị danh sách cúng dường với layout dạng "Cuốn sổ lụa" (Heritage Editorial), loại bỏ vạch ngăn để tăng tính thiền (Zen space). Cập nhật realtime từ hệ thống.

---

## 4. Tính năng "Ghi điểm" (Advanced Features)

### **1. AI Dharma Bot (Trợ lý Pháp học "Sư Số")**
- **Quy trình:** 
    1. Lưu trữ và đánh chỉ mục ngữ nghĩa tài liệu bằng cấu trúc `dharma_documents` và `pgvector` (`dharma_embeddings`) dùng chuẩn **Gemini Embedding 001 (768px)**.
    2. Mobile (Flutter) gửi câu hỏi lên Supabase Edge Function (`rag-chat`).
    - **AI Chat Service**: Kết nối Gemini 3 Flash qua Edge Functions.
    - **Semantic Caching Layer**: Tầng đệm ngữ nghĩa thông minh, xử lý truy vấn tương đồng (95% similarity) tại Database để phục vụ kết quả tức thì.
    - **RAG Engine**: Công cụ trích xuất tri thức từ kho kinh điển Nam Tông, tư vấn theo phong cách Sư Nam Tông Khmer và trả về **Stream** qua định dạng Server-Sent Events (SSE).
    4. Mobile sử dụng `StreamBuilder` để hiển thị chữ kiểu "đang gõ" trên form bong bóng Glassmorphism kèm Trích dẫn (Citation Badges) minh bạch.

### **2. Augmented Reality (AR) Gateway**
- Sử dụng `ARCore`/`ARKit` cơ bản.
- **Kịch bản:** Quét hình ảnh tượng Phật tại chùa để hiện lên thông tin lịch sử và bài tụng liên quan.

---

## 5. Lộ trình Triển khai (Roadmap)

1.  **Tuần 1-2:** Khởi tạo Flutter Project, cấu trúc Multi-tenant (Super Client), tích hợp Auth chung.
2.  **Tuần 3:** Xây dựng Map & PostGIS Query, hoàn thiện tính năng "Chùa gần tôi".
3.  **Tuần 4:** Tích hợp Audio Player và Thư viện Pháp bảo.
4.  **Tuần 5:** Triển khai AI Bot và Geofencing.
5.  **Tuần 6:** Kiểm thử, đóng gói (Android/iOS) và viết báo cáo ĐATN.
