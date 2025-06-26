import os
import pandas as pd
import re

# 設定資料夾路徑
folder_path = "data_0613"
output_file = "data_0613.txt"
fingerprints = []

# 讀取資料夾內的所有csv檔案
for filename in os.listdir(folder_path):
    if filename.startswith("region_") and filename.endswith(".csv"):
        # 取得座標
        match = re.search(r"region_(.*),(.*)\.csv", filename)
        if match:
            x = float(match.group(1))
            y = float(match.group(2))
            # 讀取csv檔案
            file_path = os.path.join(folder_path, filename)
            df = pd.read_csv(file_path, header=None)
            # 提取max rssi
            max_rssi = []
            for i in range(1, 9):  # 2-1 到 2-8
                row = df[(df[0] == "Summary") & (df[1] == "2") & (df[2] == str(i))]
                if not row.empty:
                    max_rssi_value = int(row.iloc[0, 3])  # 取 max rssi
                    max_rssi.append(max_rssi_value)
            
            # 建立Fingerprint格式
            fingerprint = f"Fingerprint(x: {x}, y: {y}, rssi: {max_rssi}),"
            fingerprints.append(fingerprint)

# 將結果寫入檔案
with open(output_file, "w") as f:
    f.write("\n".join(fingerprints))

print(f"✅ 已產生 Fingerprint 檔案: {output_file}")
