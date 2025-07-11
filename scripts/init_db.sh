#!/bin/bash

# 資料庫初始化腳本
# 檢查 PostgreSQL 連線並執行資料庫遷移

echo "正在檢查 PostgreSQL 連線..."

# 檢查 PostgreSQL port 5432 是否開啟
while ! nc -z localhost 5432; do
    echo "等待 PostgreSQL 啟動中..."
    sleep 5
done

echo "PostgreSQL 已啟動，開始執行資料庫遷移..."

# 切換到 outline 目錄並執行遷移
cd outline
yarn db:migrate

if [ $? -eq 0 ]; then
    echo "資料庫初始化成功！"
else
    echo "資料庫初始化失敗！"
    exit 1
fi
