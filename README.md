# Wiki.js 部署專案

這是一個用於快速部署 Wiki.js 服務的 Docker Compose 專案。Wiki.js 是一個現代化、輕量級且功能強大的 wiki 軟體。

## 前置需求

- Docker Engine (已測試版本: 28.3.2+)
- Docker Compose (已測試版本: 2.38.2+)
- 系統需求: Linux 建議 4GB+ RAM

## 快速部署

### 1. 克隆專案
```bash
git clone <repository-url>
cd Wiki
```

### 2. 環境配置
```bash
# 複製環境變數範例檔案
cp .env.example .env

# 編輯 .env 檔案，設定以下項目：
# - POSTGRES_PASSWORD: 資料庫密碼 (建議使用強密碼)
# - WIKI_PORT: Wiki 服務埠號 (預設: 3000)
```

### 3. 啟動服務
```bash
# 啟動所有服務 (背景執行)
docker compose up -d

# 檢查服務狀態
docker compose ps
```

### 4. 初始化 Wiki
1. 開啟瀏覽器，前往 `http://localhost:3000` (或您設定的埠號)
2. 按照 Wiki.js 安裝精靈完成初始設定
   - 選擇 PostgreSQL 資料庫
   - 資料庫主機: `db`
   - 資料庫名稱: `wiki`
   - 使用者名稱: `wikijs`
   - 密碼: 您在 `.env` 中設定的密碼

## 專案架構

```
Wiki/
├── docker-compose.yml    # Docker 服務定義
├── .env                  # 環境變數配置
├── .env.example         # 環境變數範例
├── data/                # 資料持久化目錄
│   ├── db/             # PostgreSQL 資料庫檔案
│   └── wiki/           # Wiki.js 配置和上傳檔案
├── scripts/            # 管理腳本
│   ├── backup.sh       # 資料備份腳本
│   └── restore.sh      # 資料還原腳本
└── README.md           # 專案說明文件
```

## 常用指令

### 服務管理
```bash
# 啟動服務
docker compose up -d

# 停止服務
docker compose down

# 重啟服務
docker compose restart

# 查看服務狀態
docker compose ps

# 查看服務日誌
docker compose logs -f wiki
docker compose logs -f db
```

### 維護操作
```bash
# 進入 PostgreSQL 容器
docker compose exec db bash

# 進入 Wiki.js 容器
docker compose exec wiki sh

# 查看資料庫
docker compose exec db psql -U wikijs -d wiki
```

## 資料備份與還原

### 備份
```bash
# 執行完整備份 (資料庫 + 上傳檔案)
./scripts/backup.sh

# 備份檔案會儲存在 data/backups/ 目錄下
```

### 還原
```bash
# 1. 編輯 scripts/restore.sh，設定 BACKUP_DIR 路徑
# 2. 執行還原
./scripts/restore.sh
```

## 功能擴充

### Wiki.js 本身的擴充方式：
1. **插件系統**: 透過 Wiki.js 管理介面安裝官方或第三方插件
2. **主題自定義**: 在管理介面中自定義外觀和主題
3. **API 整合**: 使用 Wiki.js 的 GraphQL API 開發外部整合
4. **認證整合**: 支援 LDAP, OAuth, SAML 等多種認證方式

### 部署層級的擴充：
- 添加反向代理 (如 Nginx, Traefik)
- 整合監控服務 (如 Prometheus, Grafana)
- 添加自動備份排程
- SSL/TLS 憑證管理

## 故障排除

### 常見問題
1. **服務無法啟動**: 檢查 Docker 是否正常運行，埠號是否衝突
2. **資料庫連線失敗**: 確認 `.env` 中的資料庫設定正確
3. **權限問題**: 確保 `data/` 目錄有適當的寫入權限

### 日誌查看
```bash
# 查看 Wiki.js 詳細日誌
docker compose logs --tail=100 -f wiki

# 查看資料庫日誌
docker compose logs --tail=100 -f db
```

## 安全建議

1. **變更預設密碼**: 務必設定強密碼並定期更換
2. **網路安全**: 在生產環境中使用反向代理並配置 SSL
3. **定期備份**: 建立定期備份機制
4. **更新維護**: 定期更新 Docker images 以獲得安全修補

## 授權

本專案採用 MIT 授權條款。Wiki.js 本身的授權請參考其官方文件。
