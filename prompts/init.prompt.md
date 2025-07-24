# GitHub Copilot Prompt
# 目標：在目前儲存庫生成下列「WIKI/」專案結構與基礎檔案，
#      讓團隊能立即 `docker compose up -d` 測試 Wiki.js 服務。
#      所有需要人工填入的值以 `<<<TODO_...>>>` 標註。
#
# ───────────────────────────────────────────────
# 1. 建立目錄樹
#
# WIKI/
# ├── .env.example
# ├── docker-compose.yml
# ├── README.md
# ├── .gitignore
# ├── data/.keep              # 保持空資料夾被 Git 追蹤
# ├── scripts/
# │   ├── backup.sh
# │   └── restore.sh
# └── ssh/.keep
#
# ───────────────────────────────────────────────
# 2. 檔案內容
#
# • .env.example
#   ------------------------------------------------
#   POSTGRES_USER=wikijs
#   POSTGRES_PASSWORD=<<<TODO_POSTGRES_PASSWORD>>>
#   POSTGRES_DB=wiki
#   WIKI_PORT=<<<TODO_HOST_PORT>>>        # 例如 3000
#   TZ=Asia/Taipei
#   ------------------------------------------------
#
# • docker-compose.yml
#   ------------------------------------------------
#   version: "3.8"
#
#   services:
#     db:
#       image: postgres:15-alpine
#       restart: unless-stopped
#       env_file: .env
#       environment:
#         - POSTGRES_USER=${POSTGRES_USER}
#         - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
#         - POSTGRES_DB=${POSTGRES_DB}
#       volumes:
#         - ./data/db:/var/lib/postgresql/data
#
#     wiki:
#       image: ghcr.io/requarks/wiki:2.5
#       restart: unless-stopped
#       depends_on:
#         - db
#       env_file: .env
#       environment:
#         - DB_TYPE=postgres
#         - DB_HOST=db
#         - DB_PORT=5432
#         - DB_USER=${POSTGRES_USER}
#         - DB_PASS=${POSTGRES_PASSWORD}
#         - DB_NAME=${POSTGRES_DB}
#         - TZ=${TZ}
#       ports:
#         - "${WIKI_PORT}:3000"
#       volumes:
#         - ./data/wiki/config:/config
#         - ./data/wiki/uploads:/data/uploads
#   ------------------------------------------------
#
# • README.md
#   ------------------------------------------------
#   # WIKI.js Quick Start
#
#   1. 依照 `.env.example` 內容建立 `.env`，填入  
#      `<<<TODO_POSTGRES_PASSWORD>>>`、`<<<TODO_HOST_PORT>>>`。
#   2. `docker compose up -d`
#   3. 瀏覽 `http://<SERVER_IP>:<WIKI_PORT>` 進行安裝精靈。
#
#   ## 常用指令
#   ```bash
#   docker compose logs -f wiki      # 即時查看 Wiki.js log
#   docker compose exec db bash      # 進入 PostgreSQL 容器
#   ```
#
#   ## 資料備份 / 還原
#   參見 `scripts/backup.sh` 與 `scripts/restore.sh`。
#   ------------------------------------------------
#
# • .gitignore
#   ------------------------------------------------
#   data/*
#   !data/.keep
#   .env
#   ------------------------------------------------
#
# • scripts/backup.sh
#   ------------------------------------------------
#   #!/usr/bin/env bash
#   set -e
#   TIMESTAMP=$(date +%Y%m%d-%H%M%S)
#   BACKUP_DIR="data/backups/${TIMESTAMP}"
#   mkdir -p "${BACKUP_DIR}"
#
#   docker compose exec db pg_dump -U "${POSTGRES_USER}" "${POSTGRES_DB}" \
#     > "${BACKUP_DIR}/wiki.sql"
#
#   tar -czf "${BACKUP_DIR}/uploads.tar.gz" -C data/wiki uploads
#   echo "✅ Backup completed: ${BACKUP_DIR}"
#   ------------------------------------------------
#
# • scripts/restore.sh
#   ------------------------------------------------
#   #!/usr/bin/env bash
#   set -e
#   BACKUP_DIR="<<<TODO_BACKUP_PATH>>>"
#
#   tar -xzf "${BACKUP_DIR}/uploads.tar.gz" -C data/wiki
#   docker compose exec -T db psql -U "${POSTGRES_USER}" "${POSTGRES_DB}" \
#     < "${BACKUP_DIR}/wiki.sql"
#   echo "✅ Restore completed"
#   ------------------------------------------------
#
# ───────────────────────────────────────────────
# 3. 其他說明
#    - `<<<TODO_...>>>` 區塊需開發者手動替換。
#    - `scripts/*.sh` 需 `chmod +x` 以便執行。
#    - `data/` 與 `ssh/` 透過 `.keep` 佔位，避免空資料夾遺失。
#
# Copilot，請依照以上說明自動生成檔案與內容。
