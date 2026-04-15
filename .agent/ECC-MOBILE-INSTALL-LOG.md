# ECC Mobile Install Log

**Nguồn**: https://github.com/affaan-m/everything-claude-code
**Phiên bản nhánh**: Master (tương đương với mã gốc)
**Ngày cài**: 2026-04-04
**Target**: Antigravity IDE (`.agent/`) chuyên trách cho dự án Flutter Mobile

---

## Đã cài đặt thành công

### `.agent/rules/`
Lọc cấu trúc kiểm duyệt chuyên biệt cho Flutter/Dart:
- `rules/dart/`: `coding-style.md`, `hooks.md`, `patterns.md`, `security.md`, `testing.md`
- `rules/common/`: Quy chuẩn chung (`git-workflow`, `code-review`, vân vân).

### `.agent/skills/`
- **Chuyên môn Flutter**: `dart-flutter-patterns`, `flutter-dart-code-review`
- **Core Platform**: `tdd-workflow`, `search-first`, `strategic-compact`, `api-design`, `database-migrations`, `git-workflow`, `security-review`.

### `.agent/agents/`
Lọc các bộ System Prompt có ích cho Mobile:
- Kiến trúc Client: `flutter-reviewer.md`, `dart-build-resolver.md`
- Core AI Tools: `architect.md`, `planner.md`, `code-reviewer.md`, `database-reviewer.md`, `performance-optimizer.md`, `refactor-cleaner.md`, `security-reviewer.md`, `doc-updater.md`.

### `.agent/workflows/` (KHÔNG lấy từ gốc ECC, giữ y hệt như Web App)
- Được đồng bộ trực tiếp từ dự án `MULTITENANT_TEMPLES` để bảo vệ quy trình ra lệnh bằng tiếng Việt của User.

---

## Không cài (lý do)
- Các cấu trúc lập trình Backend, Framework JS/Next.JS đều bị loại bỏ để bảo toàn không gian Token và tránh Agent bị nhiễu ngữ cảnh kiến trúc.
