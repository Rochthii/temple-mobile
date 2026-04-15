---
name: Tech RAG
description: Workflow kích hoạt AI tìm kiếm kiến thức chuyên môn kỹ thuật phần mềm (Tech RAG) trước khi code. Giảm ảo giác (Hallucination) công nghệ.
---

# Tech RAG Workflow 🧠

**Cảnh báo:** Đây là quy trình "Meta-Agentic" - Dành riêng cho AI (như tôi) hoặc thành viên nội bộ để trích xuất Technical Data.

## 1. Mục đích
Khi làm việc với các Framework thay đổi liên tục (như Riverpod, Supabase v2), AI có xu hướng "học vẹt" code cũ trên mạng. Tech RAG ép AI phải lấy kiến thức lập trình từ Database chuẩn (`tech_documents`) trước khi gõ phím.

## 2. Các bước bắt buộc đối với AI khi nhận lệnh refactor/code tính năng lớn:
Nếu được gọi từ một workflow khác bằng từ khóa `Tech_Refactor_RAG` hoặc người dùng yêu cầu "Dùng RAG code":

1.  **Dừng lại và không viết code vội.**
2.  Trích xuất từ khóa trọng tâm của yêu cầu (VD: `Riverpod state management async`, `Supabase edge functions caching`).
3.  **Tự động thực thi lệnh Bash (Bắt buộc chạy Tool):**
    ```bash
    node E:\MULTITENANT_TEMPLES\scripts\search_tech_rag.js "<Từ khóa trọng tâm>"
    ```
4.  **Đọc kết quả:** Quét terminal để xem các Chunk được trả về. Chú ý "Độ khớp (%)".
5.  **Dóng khung kiến trúc:** Chỉ được phép viết code dựa trên các pattern được trả ra từ công cụ này. Nếu kết quả rỗng, thông báo với người dùng: *"Không có tài liệu kỹ thuật nội bộ nào khớp với truy vấn."*

## 3. Cách thêm tài liệu cho Tech RAG
Người quản trị hệ thống có thể thả file Document `.md`, `.txt` vào thư mục dự án và chạy:
```bash
node E:\MULTITENANT_TEMPLES\scripts\ingest_tech_gemini.js <đường_dẫn_file> "<Tên Tài Liệu>" "<Tên Framework>"
```
VD: `node scripts/ingest_tech_gemini.js docs/riverpod_best_practices.md "Riverpod Guidelines" "Flutter"`
