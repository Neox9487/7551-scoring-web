# 網站架設
## 前置動作
在電腦上這些軟體來跑這個網站
- Node.js (https://nodejs.org/zh-tw/download)
- Ngrok 想要發佈到網際網路上才需要裝 (https://ngrok.com/)
- MySQL (安裝教學 https://chwang12341.medium.com/mysql-%E5%AD%B8%E7%BF%92%E7%AD%86%E8%A8%98-%E4%BA%8C-%E4%B8%80%E5%88%86%E9%90%98%E8%BC%95%E9%AC%86%E7%9E%AD%E8%A7%A3%E5%A6%82%E4%BD%95%E5%9C%A8windows%E4%B8%8A%E5%AE%89%E8%A3%9Dmysql-63cce07c6a6c)

安裝好後打開 cmd 輸入
`node -v`, `npm -v` 和 `ngrok -v` 確認有安裝好  

## 1. MySQL
打開 MySQL Command Line Client (可以用 Windows 搜尋欄找)  
輸入密碼 (安裝 MySQL 時所設定的密碼，預設為空)  
進入後輸入以下指令建立 Database
```
-- 建立資料庫
CREATE DATABASE IF NOT EXISTS frc_scouting;

-- 切換到該資料庫
USE frc_scouting;

-- 建立 records 資料表
CREATE TABLE IF NOT EXISTS records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    team_number VARCHAR(20) NOT NULL,
    match_id VARCHAR(50),
    auto_shot_pos VARCHAR(100),
    auto_max_score INT DEFAULT 0,
    auto_climb VARCHAR(20),
    fixed_shot_pos VARCHAR(20),
    intake VARCHAR(20),
    strategy VARCHAR(50),
    climb_level VARCHAR(20),
    remark TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## 2. 編譯網頁
打開 cmd 輸入
```
cd (你放專案資料夾的位置)/client
npm install
npm run build
```
之後應該會出現一個叫 `dist` 的資料夾，這就代表編譯完成了

## 3. 架伺服器
打開 cmd 輸入
```
cd (你放專案資料夾的位置)/server
npm install
```
之後打開 server 資料夾內的 index.js 找到以下兩行程試碼  
並將你 MySQL 的帳號和密碼輸入進單引號內
```
user: '(你的帳號，預設為 root)',
password: '(你的密碼，預設為空)',
```
並打開 cmd 輸入讓伺服器跑起來
```
cd (你放專案資料夾的位置)/server
node index.js
```

## 4. 發佈到網際網路上
>如果是以區域網路連線，可以直接輸入 http::/(伺服器電腦 ip):3001 連線網站，不用操作這個步驟

打開 cmd 後，輸入
```
ngrok http 3001
```
他會給你一個網址如
```
 https://xxxxx.ngrok-free.app
```
之後其他人就可以透過這個網址連接到這個網站了  
>注意: 每次輸入取得的網址都會不同，重開伺服器後要記得更新 ngrok 所給的網址

# 記分板
## 搜尋 & 排序 & 過濾
可以透過上方的下拉選單來幫助你更好的觀察與整理資料
- `檢視模式` 可以決定要看所有隊伍的場次與紀錄還是所有隊伍的摘要資訊
- `搜索框` 可以透過隊號用來搜尋特定隊伍的資訊
- `打法篩選` 可以查找特定打法的特定場次/隊伍
- `排序方式` 可以選擇要以什麼資訊做資料排序(升序)

## 隊伍詳細資訊
可以點擊欄位的資料列來進入此資料隊伍的詳細頁面

## 刪除資料
可以透過操作欄位或隊伍詳細頁 HISTORY LOHS 內場次紀錄的 `刪除` 按鈕刪除資料