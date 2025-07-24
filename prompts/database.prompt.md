````
你是 GitHub Copilot，任務：在目前的 Wiki 專案根目錄產生「資料庫啟動最小模板」，內容僅包含 PostgreSQL。

============================
1. 產生/修改的項目
============================
A) 根目錄新增 **docker-compose.db.yml**  
B) 根目錄新增 **pgdata/**（空資料夾，請在 README 說明 `mkdir pgdata`，程式碼中不用建立）  
C) 若不存在，複製 **outline/.env.sample → outline/.env** 並補 `DATABASE_URL` 行  
D) 在根目錄 README 區段追加「資料庫啟動指南」

============================
2. docker-compose.db.yml 內容
============================
```yaml
version: "3.9"
services:
  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: outline
      POSTGRES_DB: outline
    volumes:
      - ./pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"
````

\============================
3\. outline/.env 更新（若檔案已存在則插入）
==============================

```env
DATABASE_URL=postgres://postgres:outline@localhost:5432/outline
```

\============================
4\. README 新增段落（插在「快速開始」前）
==========================

````md
## 啟動本地資料庫
```bash
# 建立資料目錄
mkdir -p pgdata

# 一鍵啟動 PostgreSQL
docker compose -f docker-compose.db.yml up -d

# 確認容器
docker ps
````

啟動後 `.env` 裡的 `DATABASE_URL` 已對應 `localhost:5432`，可直接 `yarn db:migrate`。

```

目標：僅產生上述檔案與內容，不生成其他檔案，不修改前端程式碼。
```
