#!/bin/bash

# 資料備份腳本
# 備份 PostgreSQL 資料庫和上傳檔案目錄

# 設定備份目錄
BACKUP_DIR="backups"
DATE=$(date +"%Y%m%d")
BACKUP_FILE="${BACKUP_DIR}/${DATE}.tar.gz"

# 建立備份目錄
mkdir -p $BACKUP_DIR

echo "開始備份資料..."

# 備份 PostgreSQL 資料庫
echo "備份 PostgreSQL 資料庫..."
pg_dump -h localhost -U postgres outline > ${BACKUP_DIR}/database_${DATE}.sql

# 備份上傳檔案目錄
echo "備份上傳檔案..."
if [ -d "uploads" ]; then
    tar -czf ${BACKUP_DIR}/uploads_${DATE}.tar.gz uploads/
fi

# 將所有備份檔案打包
echo "打包備份檔案..."
tar -czf $BACKUP_FILE ${BACKUP_DIR}/database_${DATE}.sql ${BACKUP_DIR}/uploads_${DATE}.tar.gz

# 清理臨時檔案
rm -f ${BACKUP_DIR}/database_${DATE}.sql ${BACKUP_DIR}/uploads_${DATE}.tar.gz

echo "備份完成：$BACKUP_FILE"
