# Phân Tích Thực Tế Dự Án Hệ Sinh Thái Di Động Khmer (Realistic Project Analysis)

Tài liệu này đánh giá tính khả thi, rủi ro và các điểm mấu chốt kỹ thuật để biến ý tưởng từ bản quy hoạch (Master Plan) thành sản phẩm thực tế vận hành ổn định.

---

## 1. Phân tích Tính khả thi Kỹ thuật (Technical Feasibility)

### **A. Điểm "Dễ" (Quick Wins)**
- **Supabase Backend:** Việc mở rộng Schema (PostGIS, pgvector) cực kỳ đơn giản vì Supabase hỗ trợ sẵn qua Extensions. Toàn bộ logic Multi-tenant đã có sẵn từ bản Web, giúp tiết kiệm 60% thời gian xây dựng Backend.
- **Flutter UI:** Framework này rất mạnh trong việc tạo ra giao diện "Zen Premium" với các hiệu ứng mượt mà (Glassmorphism, Animations) mà không tốn quá nhiều tài nguyên.

### **B. Thách thức "Khó" (Technical Hurdles)**
- **Geofencing hoạt động ngầm (Background Location):**
    - *Vấn đề:* Android và iOS có cơ chế tiết kiệm pin rất khắc nghiệt. Việc nhận diện User vào vùng 200m của chùa khi App đang đóng rất dễ bị hệ điều hành "giết" tiến trình.
    - *Giải pháp thực tế:* Không nên lạm dụng GPS liên tục. Nên dùng `Significant Location Changes` kết hợp với `Region Monitoring` của hệ điều hành thay vì tự code logic tính khoảng cách liên tục.
- **Chất lượng AI RAG:**
    - *Vấn đề:* Nếu dữ liệu văn bản từ các chùa không sạch (unstructured) hoặc quá ngắn, AI sẽ trả lời ngô nghê hoặc "ảo giác" (hallucination).
    - *Giải pháp thực tế:* Cần một giai đoạn "Data Cleaning" chuyên sâu. Phải có nhân sự (hoặc dùng AI phụ) để tóm tắt pháp thoại thành các "Knowledge Chunks" chất lượng trước khi lưu vào Vector DB.

---

## 2. Phân tích Vận hành & Dữ liệu (Operations & Data)

### **A. Bài toán "Dữ liệu Chùa"**
- **Thực tế:** Không phải ngôi chùa nào cũng có nhân sự rành công nghệ để cập nhật tọa độ hay tin tức.
- **Chiến lược thực tế:** 
    1.  **Giai đoạn 1 (Seed Data):** Super Admin (bạn) dùng dữ liệu từ Google Maps/Wiki để tạo 50-100 chùa "Basic POI".
    2.  **Giai đoạn 2 (Community Driven):** Cho phép người dùng App "Gửi tọa độ chùa mới" hoặc "Cập nhật ảnh chùa" (Crowdsourcing). Bạn chỉ cần duyệt.

### **B. Chi phí Công nghệ (Cost)**
- **AI:** Mỗi câu hỏi RAG tốn chi phí Token cho Embedding và LLM (Gemini/OpenAI). 
- **Giải pháp:** Cần giới hạn số câu hỏi mỗi User/ngày hoặc dùng Model nhỏ (Gemini Flash) để tối ưu chi phí.

---

## 3. Phân tích UX cho Đối tượng đặc thù

- **Người cao tuổi:** Đối tượng chính nghe pháp thoại thường là người lớn tuổi.
    - *Yêu cầu:* Font chữ cực lớn, nút bấm to, chức năng nghe (Audio) phải là ưu tiên số 1, dễ tìm hơn cả Map.
- **Kết nối kém:** Các chùa thường ở vùng sâu vùng xa.
    - *Yêu cầu:* Phải có Offline Mode cho các bài kinh/pháp thoại đã lưu.

---

## 4. Lời khuyên cho Đồ án Tốt nghiệp (Thesis Strategy)

Để đạt điểm tối đa mà không bị "bơi" trong khối lượng công việc khổng lồ:

1.  **Tập trung vào "Cái lõi":** Đừng cố làm AR hay Metaverse ngay. Hãy làm thật tốt **AI Dharma Bot** và **Bản đồ GIS**. Đó là 2 điểm "Wow" nhất về mặt kỹ thuật.
2.  **Chứng minh tính "Multi-tenant":** Hội đồng sẽ đánh giá cao nếu bạn trình diễn được: "Em chỉ cần đổi một tham số, toàn bộ App này biến thành giao diện và dữ liệu của Chùa khác".
3.  **Số liệu thực tế:** Hãy chuẩn bị một bảng so sánh hiệu năng tìm kiếm giữa truy vấn SQL thông thường và truy vấn PostGIS (Index GIST). Đây là "bằng chứng" khoa học cho đồ án.

---
*Phân tích bởi Antigravity AI - 16/03/2026*
