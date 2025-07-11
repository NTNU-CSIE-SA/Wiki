# Wiki 專案

## 專案簡介

本專案是一個基於 Outline 的知識管理系統，整合了 GPT AI 功能，提供強大的文檔創建、編輯和智能輔助功能。

## 目錄結構說明

```
Wiki/
├── outline/                     # Fork 後的 Outline 原始碼
├── gpt/                         # GPT API 服務
│   ├── api/                     # Flask API 應用
│   │   └── app.py
│   ├── prompts/                 # AI 提示詞模板
│   │   ├── summarize.md
│   │   └── generate.md
│   └── requirements.txt         # Python 依賴
├── deploy/                      # 部署相關配置
│   ├── docker-compose.yml      # Docker 容器編排
│   ├── systemd/                # Systemd 服務配置
│   │   ├── outline.service
│   │   └── gpt.service
│   └── nginx.conf              # Nginx 反向代理配置
├── scripts/                    # 自動化腳本
│   ├── init_db.sh             # 資料庫初始化
│   └── backup.sh              # 資料備份
├── docs/                      # 專案文檔
│   └── README.md
├── .env.example               # 環境變數範例
└── README.md                  # 專案說明文件
```

## 快速開始

### 環境需求
- Node.js 20.x (推薦使用 nvm 管理)
- Python 3.11+
- PostgreSQL 16+
- Git
- 作業系統：Arch Linux 或 Ubuntu/Debian

### 初始化流程

1. Clone 專案並進入目錄
```bash
git clone <repository-url>
cd Wiki
```

2. Fork Outline 並安裝依賴
```bash
git submodule add https://github.com/outline/outline.git outline
cd outline
yarn install
cd ..
```

3. 設定環境變數
```bash
cp .env.example .env
# 編輯 .env 檔案，填入實際的配置值
```

4. 初始化資料庫
```bash
chmod +x scripts/init_db.sh
./scripts/init_db.sh
```

## Outline 部署指南

### 前置需求
- Node.js 20.x (使用 nvm 管理)
- PostgreSQL 16+
- Git
- 作業系統：Arch Linux 或 Ubuntu/Debian

### 系統套件安裝

##### Arch Linux
```bash
# 更新系統並安裝基本套件
sudo pacman -Syu
sudo pacman -S git curl wget
```

##### Ubuntu/Debian
```bash
# 更新系統並安裝基本套件
sudo apt update && sudo apt upgrade -y
sudo apt install git curl wget build-essential
```

### 1. 環境準備

#### 安裝 Node Version Manager (nvm)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 20
nvm use 20
```

#### 安裝 PostgreSQL

##### Arch Linux
```bash
sudo pacman -S postgresql
sudo -u postgres initdb -D /var/lib/postgres/data
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

##### Ubuntu/Debian
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### 2. 資料庫設置

#### 建立 Outline 資料庫
```bash
sudo -u postgres createdb outline
```

#### 驗證資料庫連接
```bash
sudo -u postgres psql -c "\l"  # 列出所有資料庫
```

### 3. Outline 配置

#### 建立環境配置檔案
在 `outline/` 目錄中建立 `.env` 檔案：

```bash
cd outline
cp .env.sample .env
```

#### 基本配置範例
```env
NODE_ENV=development
URL=http://localhost:3000
PORT=3000

# 使用 openssl rand -hex 32 生成密鑰
SECRET_KEY=your_32_byte_hex_secret_key
UTILS_SECRET=your_32_byte_hex_utils_secret

# 語言設置
DEFAULT_LANGUAGE=zh_TW

# 資料庫連接
DATABASE_URL=postgresql://postgres@localhost:5432/outline
PGSSLMODE=disable

# 本地檔案儲存
FILE_STORAGE=local
FILE_STORAGE_LOCAL_ROOT_DIR=./data

# 可選：Redis (建議生產環境使用)
# REDIS_URL=redis://localhost:6379
```

#### 生成安全密鑰
```bash
openssl rand -hex 32  # 為 SECRET_KEY 生成
openssl rand -hex 32  # 為 UTILS_SECRET 生成
```

### 4. 安裝與執行

#### 安裝依賴套件
```bash
cd outline
yarn install
```

#### 執行資料庫遷移
```bash
yarn db:create  # 如果需要建立資料庫
yarn db:migrate
```

#### 啟動開發服務器
```bash
# 開發模式（包含前端和後端）
yarn dev:watch

# 或者分別啟動
yarn build:server  # 建構後端
yarn dev          # 啟動後端服務
```

#### 生產環境部署
```bash
yarn build        # 建構所有檔案
yarn start        # 啟動生產服務器
```

### 5. 驗證部署

開啟瀏覽器訪問 `http://localhost:3000`，如果看到 Outline 的歡迎頁面，表示部署成功。

### 6. 常見問題排除

#### Node.js 版本不相容
```bash
nvm use 20  # 確保使用正確的 Node.js 版本
```

#### 資料庫連接失敗
##### 檢查 PostgreSQL 狀態
```bash
sudo systemctl status postgresql  # 檢查服務狀態
sudo -u postgres psql -c "SELECT version();"  # 測試連接
```

##### 重啟 PostgreSQL 服務
```bash
# Arch Linux & Ubuntu/Debian
sudo systemctl restart postgresql
sudo systemctl status postgresql
```

##### 檢查 PostgreSQL 日誌
**Arch Linux:**
```bash
sudo journalctl -u postgresql -f
```

**Ubuntu/Debian:**
```bash
sudo tail -f /var/log/postgresql/postgresql-*.log
```

#### 端口被佔用
```bash
lsof -i :3000  # 檢查端口使用情況
```

## 本地開發流程

1. 啟動 PostgreSQL 資料庫
2. 啟動 Outline 服務
```bash
cd outline
bash -c '. ~/.nvm/nvm.sh; nvm use 20 && yarn dev:watch'
```

3. 啟動 GPT API 服務
```bash
cd gpt/api
pip install -r ../requirements.txt
python app.py
```

## Docker 部署

### 使用 Docker Compose 部署

1. 安裝 Docker 和 Docker Compose

##### Arch Linux
```bash
sudo pacman -S docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

##### Ubuntu/Debian
```bash
# 安裝 Docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce

# 安裝 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 啟動服務
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

2. 配置環境變數
```bash
cp .env.example .env
# 編輯 .env 檔案，設置正確的配置值
```

3. 啟動所有服務
```bash
docker-compose -f deploy/docker-compose.yml up -d
```

4. 執行資料庫遷移
```bash
docker-compose -f deploy/docker-compose.yml exec outline yarn db:migrate
```

5. 檢查服務狀態
```bash
docker-compose -f deploy/docker-compose.yml ps
docker-compose -f deploy/docker-compose.yml logs outline
```

### Docker 服務說明
- **outline**: Outline Wiki 主服務 (端口 3000)
- **gpt**: GPT API 服務 (端口 5001)
- **db**: PostgreSQL 資料庫 (端口 5432)

## Systemd 部署

### 1. 準備系統服務

複製服務檔案到系統目錄：
```bash
sudo cp deploy/systemd/*.service /etc/systemd/system/
sudo systemctl daemon-reload
```

### 2. 修改服務檔案路徑

編輯服務檔案中的 `WorkingDirectory` 路徑：
```bash
sudo vim /etc/systemd/system/outline.service
sudo vim /etc/systemd/system/gpt.service
```

確保路徑指向正確的專案位置。

### 3. 啟動服務

```bash
# 啟動並啟用 Outline 服務
sudo systemctl enable outline
sudo systemctl start outline

# 啟動並啟用 GPT API 服務
sudo systemctl enable gpt
sudo systemctl start gpt

# 檢查服務狀態
sudo systemctl status outline
sudo systemctl status gpt
```

### 4. 配置 Nginx 反向代理

##### Arch Linux
```bash
# 安裝 Nginx
sudo pacman -S nginx

# 複製配置檔案
sudo cp deploy/nginx.conf /etc/nginx/sites-available/wiki
sudo mkdir -p /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/wiki /etc/nginx/sites-enabled/

# 測試配置並啟動
sudo nginx -t
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl reload nginx
```

##### Ubuntu/Debian
```bash
# 安裝 Nginx
sudo apt update
sudo apt install nginx

# 複製配置檔案
sudo cp deploy/nginx.conf /etc/nginx/sites-available/wiki
sudo ln -s /etc/nginx/sites-available/wiki /etc/nginx/sites-enabled/

# 移除預設站點（可選）
sudo rm /etc/nginx/sites-enabled/default

# 測試配置並重新載入
sudo nginx -t
sudo systemctl reload nginx
```

### Systemd 服務管理

```bash
# 查看服務日誌
sudo journalctl -u outline -f
sudo journalctl -u gpt -f

# 重啟服務
sudo systemctl restart outline
sudo systemctl restart gpt

# 停止服務
sudo systemctl stop outline gpt
```

## FAQ

### Q: 如何重設資料庫？
A: 停止服務後，刪除資料庫並重新執行初始化：
```bash
sudo systemctl stop outline
sudo -u postgres dropdb outline
sudo -u postgres createdb outline
cd outline && yarn db:migrate
sudo systemctl start outline
```

### Q: GPT API 回傳 mock 資料怎麼辦？
A: 需要在 `.env` 中設定有效的 OPENAI_API_KEY，並在 `gpt/api/app.py` 中解除相關程式碼的註解：
```python
import openai
openai.api_key = OPENAI_API_KEY
# 解除 TODO 註解並實作實際的 API 調用
```

### Q: 如何備份資料？
A: 執行 `scripts/backup.sh` 腳本：
```bash
chmod +x scripts/backup.sh
./scripts/backup.sh
```
備份檔案將儲存在 `backups/YYYYMMDD.tar.gz`。

### Q: Outline 啟動失敗怎麼辦？
A: 檢查以下項目：
1. Node.js 版本是否為 20.x
2. PostgreSQL 是否正在運行
3. `.env` 檔案配置是否正確
4. 資料庫是否已建立並執行遷移

### Q: 如何更改 Outline 的預設語言？
A: 在 `.env` 檔案中修改 `DEFAULT_LANGUAGE` 設定：
```env
DEFAULT_LANGUAGE=zh_TW  # 繁體中文
DEFAULT_LANGUAGE=zh_CN  # 簡體中文
DEFAULT_LANGUAGE=en_US  # 英文
```

### Q: 如何啟用 HTTPS？
A: 建議使用 Nginx 作為反向代理並配置 SSL 憑證：

##### Arch Linux
```bash
# 安裝 Nginx 和 Certbot
sudo pacman -S nginx certbot certbot-nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# 獲取 SSL 憑證
sudo certbot --nginx -d yourdomain.com
```

##### Ubuntu/Debian
```bash
# 安裝 Nginx 和 Certbot
sudo apt update
sudo apt install nginx certbot python3-certbot-nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# 獲取 SSL 憑證
sudo certbot --nginx -d yourdomain.com
```

### Q: Arch Linux 和 Ubuntu 有什麼差異？
A: 主要差異在於套件管理和系統配置：

**套件管理：**
- Arch Linux: `pacman -S package_name`
- Ubuntu/Debian: `apt install package_name`

**服務管理：** 兩者都使用 systemd
```bash
sudo systemctl start/stop/restart service_name
sudo systemctl enable/disable service_name
```

**日誌查看：**
- 系統日誌：`sudo journalctl -u service_name`
- 應用日誌：位置可能不同，Ubuntu 通常在 `/var/log/`

**防火牆：**
- Arch Linux: 預設無防火牆，可安裝 `ufw` 或 `iptables`
- Ubuntu: 預設有 `ufw`

### Q: 為什麼需要 Redis？
A: Redis 用於：
- Session 儲存
- 快取管理  
- 背景任務佇列
- WebSocket 連接管理

生產環境強烈建議使用 Redis。

## 系統安全配置

### 防火牆設置

##### Arch Linux
```bash
# 安裝並配置 ufw
sudo pacman -S ufw
sudo ufw enable
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw allow 3000  # Outline (開發環境)
```

##### Ubuntu/Debian
```bash
# ufw 通常已預安裝
sudo ufw enable
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw allow 3000  # Outline (開發環境)
```

### PostgreSQL 安全設置

```bash
# 設置 postgres 用戶密碼
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'your_secure_password';"

# 編輯 PostgreSQL 配置（限制連接）
sudo vim /var/lib/postgres/data/postgresql.conf  # Arch Linux
sudo vim /etc/postgresql/*/main/postgresql.conf  # Ubuntu/Debian

# 設置只監聽本地連接
listen_addresses = 'localhost'
```

## 成員分工表

| 角色 | 成員 | 職責 |
|------|------|------|
| 後端 |      | Outline 後端開發與維護 |
| AI   |      | GPT API 開發與優化 |
| 部署 |      | 系統部署與維運 |
| 前端 |      | 使用者介面開發 |
