import os
import pandas as pd
import re

# 設定資料夾路徑
folder_path = "data_b1f"
output_file = "data_0613.txt"
fingerprints = []

def determine_zone(scaled_y):
    if scaled_y <= 3.2:
        return "C"
    elif scaled_y <= 7.2:
        return "B"
    else:
        return "A"
# 讀取資料夾內的所有csv檔案
for filename in os.listdir(folder_path):
    if filename.startswith("region_") and filename.endswith(".csv"):
        # 取得座標
        match = re.search(r"region_(.*),(.*)\.csv", filename)
        if match:
            # x, y填反了
            y = float(match.group(1))
            x = float(match.group(2))
            # 讀取csv檔案
            file_path = os.path.join(folder_path, filename)
            df = pd.read_csv(file_path, header=None)
            # 提取max rssi
            max_rssi = []
            for i in range(1, 5):  # 2-1 到 2-8
                row = df[(df[0] == "Summary") & (df[1] == "1") & (df[2] == str(i))]
                if not row.empty:
                    max_rssi_value = int(row.iloc[0, 3])  # 取 max rssi
                    max_rssi.append(max_rssi_value)

            scaled_x = round(x * 0.8, 2)
            scaled_y = round(y * 0.8, 2)

            # 根據 scaled_y 決定區域
            zone = determine_zone(scaled_y)
            # 建立Fingerprint格式
            fingerprint = f"Fingerprint(x: {scaled_x}, y: {scaled_y}, rssi: {max_rssi}, zone: \"{zone}\"),"
            fingerprints.append(fingerprint)

# 將結果寫入檔案
with open(output_file, "w") as f:
    f.write("\n".join(fingerprints))

print(f"✅ 已產生 Fingerprint 檔案: {output_file}")
