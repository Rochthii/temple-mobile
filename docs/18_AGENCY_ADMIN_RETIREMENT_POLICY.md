# DOCUMENT 18: AGENCY ADMIN & RETIREMENT POLICY

## 1. Tổng quan (Overview)
Tài liệu này quy định về cơ chế "Rút lui" (Retirement Policy) nhằm đảm bảo chủ sở hữu hệ thống (Bạn) có thể bàn giao quyền quản trị Web cho đối tác/đại lý (`agency_admin`) mà không làm lộ bí mật công nghệ, bản quyền Mobile App và dữ liệu của các chi nhánh riêng tư.

## 2. Vai trò Agency Admin (Role Definition)
- **Định danh trong Code**: `agency_admin`.
- **Phạm vi**: Là một Global Admin có quyền trên toàn hệ thống Web nhưng bị giới hạn nghiêm ngặt về tài nguyên.

## 3. Các mục bị chặn/ẩn (Restricted Items)

### A. Giao diện Sidebar (UI Layer)
Hệ thống tự động ẩn các mục sau đây khi người dùng đăng nhập với role `agency_admin`:

1.  **Global Sidebar**:
    -   **Cài đặt hệ thống (Settings)**: Ẩn hoàn toàn để tránh can thiệp cấu hình Server, API Keys.
    -   **Phân tích (Analytics)**: Ẩn báo cáo tổng thể toàn hệ thống.
    -   **Logs**: Ẩn Audit Logs hệ thống (Backup, Restore).
2.  **Temple Sidebar (Quản trị từng chùa)**:
    -   **Mobile App**: Ẩn toàn bộ menu cấu hình Mobile App (Cấu hình AI, Build App, Push Notification).

### B. Dữ liệu (Data Layer - Multi-tenant Isolation)
-   **Thuộc tính**: `has_web_frontend` (boolean) trong bảng `public.tenants`.
-   **Logic**:
    -   Nếu `has_web_frontend = false`: Chùa này được coi là **"App-only"**.
    -   `agency_admin` sẽ **không bao giờ** thấy hoặc truy cập được các chùa này trong danh sách quản lý.
    -   Chỉ `super_admin` hoặc `admin` mới thấy được các chùa ẩn này.

### C. Quyền hạn API (Backend/Permissions Layer)
Trong file `lib/permissions.ts`, các tài nguyên (Resource) sau đây bị chặn:
-   `mobile_app`: Chặn `create`, `read`, `update`, `delete`.
-   `settings`: Chặn truy cập cấu hình sâu.

## 4. Cách bảo mật dữ liệu sau này
Khi bạn muốn thêm một ngôi chùa mới mà **không muốn Châu (Agency) thấy**:
1.  Truy cập trang **Quản lý Chùa** với quyền Super Admin.
2.  Khi tạo mới hoặc sửa chùa đó, hãy tắt tùy chọn: **"Chế độ hiển thị Web công khai"**.
3.  Hệ thống sẽ gán `has_web_frontend = false` và tài khoản của Châu sẽ hoàn toàn không biết chùa này tồn tại.

## 5. Duy trì và Nâng cấp
Mọi tính năng mới liên quan đến Mobile App trong tương lai **bắt buộc** phải được gán vào Resource `mobile_app` để đảm bảo cơ chế chặn tự động này luôn có hiệu lực.
