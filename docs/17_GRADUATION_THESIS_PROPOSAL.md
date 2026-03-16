# Đề cương Đồ án Tốt nghiệp (Proposal for Graduation Thesis)

**Tên đề tài:** Hệ sinh thái Quản lý và Phát triển Văn hóa Chùa Khmer Đa nền tảng (Web & Mobile) tích hợp công nghệ AI (RAG) và GIS (PostGIS).

---

## 1. Tính cấp thiết của đề tài
- **Bảo tồn văn hóa:** Số hóa di sản chùa Khmer, giúp thế hệ trẻ tiếp cận dễ dàng qua di động.
- **Hiện đại hóa quản lý:** Chuyển đổi từ quản lý truyền thống sang hệ thống đa chùa (Multi-tenant) tập trung.
- **Tiên phong công nghệ:** Ứng dụng AI để giải đáp giáo lý và GIS để kết nối địa lý tâm linh.

---

## 2. Đối tượng & Phạm vi nghiên cứu
- **Đối tượng:** Các ngôi chùa Khmer Nam Bộ (Hệ thống chùa và các chi nhánh).
- **Phạm vi kỹ thuật:**
    - **Web Admin (CMS):** Next.js 15, Tailwind, Supabase.
    - **Mobile App:** Flutter (iOS/Android).
    - **AI/Data:** pgvector, RAG Pipeline, PostGIS.

---

## 3. Các tính năng cốt lõi (Core Features)
1. **Quản trị đa chùa (Multi-tenant):** Một hệ thống duy nhất phục vụ hàng trăm ngôi chùa với bản sắc riêng (theme, nội dung).
2. **Bản đồ Di sản (GIS Discovery):** Tìm kiếm chùa theo vị trí địa lý, tính toán khoảng cách thực tế, điều hướng GPS.
3. **Người thầy số (AI Dharma Bot):** Chatbot thông minh trả lời giáo lý dựa trên kho tàng Pháp thoại của hệ thống.
4. **Cổng công đức minh bạch (Merit Gateway):** Tích hợp VietQR động, công khai sổ cái đóng góp thời gian thực.
5. **Vận hành tự động (Geofencing):** Tự động nhận diện và gửi thông báo khi Phật tử đến chùa.

---

## 4. Kiến trúc kỹ thuật đề xuất
- **Frontend:** Next.js (Web) + Flutter (Mobile).
- **Backend-as-a-Service:** Supabase (PostgreSQL, Auth, Storage, Edge Functions).
- **Integration:** 
    - **FCM** cho thông báo.
    - **Google Maps API** cho bản đồ.
    - **Gemini API** cho trí tuệ nhân tạo.

---

## 5. Kết luận dự kiến
Đồ án không chỉ là một sản phẩm kỹ thuật mà còn là giải pháp xã hội bền vững, giúp kết nối cộng đồng Phật giáo Khmer trong kỷ nguyên số, đảm bảo tính minh bạch, tiện lợi và giáo dục sâu sắc.
