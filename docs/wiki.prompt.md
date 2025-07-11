你是 GitHub Copilot。目標：在名為 Wiki 的 GitHub 專案根目錄一次產生下列檔案與內容（前端 UI 無須生成），確保格式正確且可直接運行。

================================================================
1. 目錄結構
================================================================
Wiki/
├── outline/
├── gpt/
│   ├── api/
│   │   └── app.py
│   ├── prompts/
│   │   ├── summarize.md
│   │   └── generate.md
│   └── requirements.txt
├── deploy/
│   ├── docker-compose.yml
│   ├── systemd/
│   │   ├── outline.service
│   │   └── gpt.service
│   └── nginx.conf
├── scripts/
│   ├── init_db.sh
│   └── backup.sh
├── docs/
│   └── README.md
├── .env.example
└── README.md

================================================================
2. 檔案內容需求
================================================================
A) .env.example  
   - DATABASE_URL、URL、SECRET_KEY、AWS_ACCESS_KEY_ID、AWS_SECRET_ACCESS_KEY、AWS_S3_UPLOAD_BUCKET_URL 帶預設或空值。

B) gpt/api/app.py（Flask）  
   - 中文頂部註解說明用途。  
   - `/test` 回傳純文字 "GPT service is running"。  
   - `/generate` 以 POST 收 `{ "prompt": "<text>" }`，回傳 `{"result": "mock generated text"}`。  
   - `/summarize` 以 POST 收 `{ "content": "<text>" }`，回傳 `{"summary": "mock summary"}`。  
   - 保留 `OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")`，實際調用請註解或 TODO。

C) gpt/requirements.txt  
   - flask  
   - openai

D) deploy/docker-compose.yml  
   - 服務：outline、gpt、db。  
   - outline 使用 node:18-alpine，端口 3000；環境變數讀 .env。  
   - gpt 使用 python:3.11-slim，端口 5000；掛載 ./gpt。  
   - db 使用 postgres:16-alpine，端口 5432；環境變數 POSTGRES_PASSWORD=outline。  
   - networks、volumes 基本配置。

E) deploy/systemd/outline.service  
   - After=network.target  
   - WorkingDirectory 指向專案根目錄/outline  
   - ExecStart=`/usr/bin/yarn start`  
   - Restart=always

F) deploy/systemd/gpt.service  
   - After=network.target  
   - WorkingDirectory 指向專案根目錄/gpt/api  
   - ExecStart=`/usr/bin/python app.py`  
   - Restart=always

G) deploy/nginx.conf  
   - 反向代理 80 → outline:3000，/api/gpt/* → gpt:5000。  
   - 包含 gzip、proxy_pass 基本設定。

H) scripts/init_db.sh  
   - Bash shebang、中文註解。  
   - 檢查 PostgreSQL port 5432 是否開啟，若沒開 5 秒內重試。  
   - 執行 `yarn db:migrate` 於 outline 目錄。  
   - echo 成功訊息。

I) scripts/backup.sh  
   - Bash shebang、中文註解。  
   - 將 PostgreSQL 資料庫與 uploads 目錄打包到 backups/YYYYMMDD.tar.gz。

J) docs/README.md  
   - 佔位文字：「此處撰寫專案內部技術文件」。

K) README.md  
   - 區段：專案簡介、目錄結構說明、快速開始、初始化流程（clone→yarn install→cp .env.example→編輯→init_db.sh）、本地開發流程、Docker 部署、systemd 部署、FAQ（三條）、成員分工表（四欄：後端、AI、部署、前端，成員留空）。

================================================================
3. 輸出格式
================================================================
- 依序輸出各檔案，格式：「# 檔名」(H1 標題) 後接對應程式碼區塊。  
- 除標題與程式碼外，不加任何多餘敘述。  
- 例：  
  # .env.example  
  ```env  
  ...內容...  
開始依規格產生所有檔案內容。