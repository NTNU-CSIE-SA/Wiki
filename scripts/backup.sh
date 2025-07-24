#!/usr/bin/env bash
set -e

# 載入環境變數
source .env

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="data/backups/${TIMESTAMP}"
mkdir -p "${BACKUP_DIR}"

echo "正在建立備份: ${BACKUP_DIR}"

# 備份資料庫
echo "正在備份資料庫..."
docker compose exec db pg_dump -U "${POSTGRES_USER}" "${POSTGRES_DB}" \
  > "${BACKUP_DIR}/wiki.sql"
echo "✅ 資料庫備份完成"

# 備份上傳檔案
echo "正在備份上傳檔案..."
if [ -d "data/wiki/uploads" ]; then
    tar -czf "${BACKUP_DIR}/uploads.tar.gz" -C data/wiki uploads
    echo "✅ 上傳檔案備份完成"
else
    echo "⚠️  警告: 沒有找到上傳檔案目錄"
fi

# 建立備份資訊檔案
cat > "${BACKUP_DIR}/backup_info.txt" << EOF
備份時間: $(date)
Wiki.js 版本: $(docker compose exec wiki cat /app/package.json | grep version | head -1)
PostgreSQL 版本: $(docker compose exec db postgres --version)
備份大小: $(du -sh "${BACKUP_DIR}" | cut -f1)
EOF

echo "✅ 備份完成: ${BACKUP_DIR}"
echo "備份大小: $(du -sh "${BACKUP_DIR}" | cut -f1)"
