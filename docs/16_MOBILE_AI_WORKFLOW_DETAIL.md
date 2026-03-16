# Quy trình Hệ thống & Logic AI RAG

Tài liệu này chi tiết hóa cách thức hoạt động của các tính năng "High-tech" trong Đồ án tốt nghiệp.

---

## 1. Quy trình Người dùng (User Journey Workflow)

```mermaid
sequenceDiagram
    participant U as Phật tử (User)
    participant M as Mobile App
    participant G as Google Maps / GPS
    participant S as Supabase (Backend/DB)
    participant A as Edge Function (AI Engine)

    U->>M: Mở tab "Khám phá"
    M->>G: Lấy vị trí hiện tại
    G-->>M: Tọa độ (Lat, Long)
    M->>S: RPC find_nearby_temples(lat, long)
    S-->>M: Danh sách chùa kèm khoảng cách
    M->>U: Hiển thị Map & List

    Note over U,M: Khi bước vào cổng chùa
    M->>G: Kiểm tra Geofence
    G->>M: Enter Geofence
    M->>S: Ghi log Geofencing
    M->>U: Gửi Push Notification: "Chào mừng bạn đến chùa..."
```

---

## 2. Quy trình AI Dharma Bot (RAG Pipeline)

Đây là tính năng "Ghi điểm" cực lớn, biến App thành một người thầy số.

```mermaid
flowchart TD
    subgraph "Giai đoạn Pre-processing (Admin)"
        A1[Web Admin Content] --> A2[Text Splitter - Chunks]
        A2 --> A3[Embedding Model - Gemini]
        A3 --> A4[(pgvector DB)]
    end

    subgraph "Giai đoạn Truy vấn (Mobile App)"
        B1[Phật tử hỏi App] --> B2[Vectorize câu hỏi]
        B2 --> B3[Similarity Search - Cosine]
        B3 --> B4[Retrieve Top Contexts]
        B4 --> B5[Prompt + Context -> Gemini Pro]
        B5 --> B6[AI trả lời bằng giọng văn Nam Tông]
    end
```

---

## 3. Logic Geofencing & Push Notification

- **Mobile side:** Sử dụng thư viện `flutter_geofencing` hoặc `geolocator`.
- **Server side:** 
    - Khi nhận sự kiện "Enter", truy vấn `site_settings` của `tenant_id` tương ứng để lấy lời chào đã cấu trúc sẵn.
    - Gửi qua Firebase Cloud Messaging (FCM).

---

## 4. Tính năng AR (Số hóa di sản)

- **Input:** Camera Frame.
- **Processing:** Image Tracking (nhận diện phù điêu/tượng).
- **Output:** Overlay 3D hoặc Text/Audio thuyết minh.
- **Giá trị:** Nâng tầm trải nghiệm tham quan thực tế tại chùa, biến mỗi ngôi chùa thành một "Bảo tàng số".
