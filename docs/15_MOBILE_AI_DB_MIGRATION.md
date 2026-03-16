# Đề xuất Migration: Mở rộng tính năng Mobile & AI

Dưới đây là mã SQL dự kiến để nâng cấp hệ thống hiện tại, sẵn sàng cho việc tích hợp Mobile App và AI Dharma Bot.

---

## 1. Kích hoạt PostGIS và Vector Search
```sql
-- Kích hoạt tiện ích địa lý và vector (Hỗ trợ AI)
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS vector; -- Yêu cầu Supabase có hỗ trợ pgvector
```

---

## 2. Nâng cấp bảng Tenants (Tọa độ chùa)
```sql
-- Bổ sung thông tin địa lý vào bảng tenants
ALTER TABLE tenants 
ADD COLUMN latitude FLOAT8,
ADD COLUMN longitude FLOAT8,
ADD COLUMN address_vi TEXT,
ADD COLUMN geog GEOGRAPHY(POINT);

-- Index GIST để tìm kiếm "Chùa gần đây" với tốc độ cực nhanh
CREATE INDEX idx_tenants_geog ON tenants USING GIST (geog);

-- Trigger tự động cập nhật geog khi nhập latitude/longitude
CREATE OR REPLACE FUNCTION update_tenants_geog()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
    NEW.geog := ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4324)::geography;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_update_tenants_geog
BEFORE INSERT OR UPDATE ON tenants
FOR EACH ROW EXECUTE FUNCTION update_tenants_geog();
```

---

## 3. Bảng Embedding hỗ trợ AI Dharma Bot (RAG)
```sql
-- Lưu trữ các vector đặc trưng của nội dung để AI tìm kiếm
CREATE TABLE dharma_embeddings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
  content_id UUID, -- Link tới pages.id hoặc dharma_talks.id
  content_type TEXT, -- 'page', 'talk', 'news'
  content_text TEXT, -- Đoạn text được cắt nhỏ (Chunks)
  embedding vector(1536), -- 1536 là số chiều của OpenAI/Gemini embedding
  metadata JSONB
);

CREATE INDEX idx_dharma_embeddings_vector ON dharma_embeddings 
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);
```

---

## 4. Bảng Geofencing Log (Vận hành tự động)
```sql
-- Lưu vết khi người dùng bước vào khu vực chùa để phân tích hành vi
CREATE TABLE geofencing_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  tenant_id UUID REFERENCES tenants(id),
  action_type TEXT, -- 'enter', 'exit'
  occurred_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```
