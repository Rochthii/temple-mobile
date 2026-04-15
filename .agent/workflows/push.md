---
description: Kiểm tra lint, build và push code lên GitHub
---

1. Chạy kiểm tra TypeScript để phát hiện lỗi type.
// turbo
2. Chạy lệnh sau để kiểm tra lỗi lint:
```
npx next lint
```
3. Nếu có lỗi lint nghiêm trọng, hãy tự sửa rồi tiếp tục. Nếu chỉ là cảnh báo, bỏ qua.
4. Xem lại toàn bộ những thay đổi đã thực hiện (diff) và tóm tắt ngắn gọn cho tôi.
5. Hãy đề xuất một commit message theo chuẩn Conventional Commits (feat/fix/refactor/chore/docs/style...).
6. Chạy lệnh git add và commit với message đã đề xuất. Sau đó push lên nhánh main.
