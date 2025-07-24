#!/usr/bin/env bash
set -e

# 使用方式: ./restore.sh <backup_directory>
# 例如: ./restore.sh data/backups/20250724-211500

if [ $# -eq 0 ]; then
    echo "使用方式: $0 <backup_directory>"
    echo "可用的備份:"
    ls -la data/backups/ 2>/dev/null || echo "沒有找到備份目錄"
    exit 1
fi

BACKUP_DIR="$1"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "錯誤: 備份目錄 $BACKUP_DIR 不存在"
    exit 1
fi

echo "正在從 $BACKUP_DIR 還原..."

# 還原上傳檔案
if [ -f "${BACKUP_DIR}/uploads.tar.gz" ]; then
    tar -xzf "${BACKUP_DIR}/uploads.tar.gz" -C data/wiki
    echo "✅ 上傳檔案已還原"
else
    echo "⚠️  警告: 沒有找到上傳檔案備份"
fi

# 還原資料庫
if [ -f "${BACKUP_DIR}/wiki.sql" ]; then
    docker compose exec -T db psql -U "${POSTGRES_USER}" "${POSTGRES_DB}" \
      < "${BACKUP_DIR}/wiki.sql"
    echo "✅ 資料庫已還原"
else
    echo "⚠️  警告: 沒有找到資料庫備份"
fi

echo "✅ 還原完成: ${BACKUP_DIR}"
