//
//  ViewController.swift
//  iBeaconFingerprint
//
//  Created by annie on 2025/5/15.
//

import UIKit
import CoreLocation

// 定義 Beacon 座標
struct Beacon {
    let id: Int
    let x: Double
    let y: Double
}

// 定義數據點結構
struct Fingerprint {
    let x: Double
    let y: Double
    let rssi: [Int] // 8 個 Beacon 的 RSSI
    let zone: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var rssiTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    // 8 個 Beacon 座標 (假設已知)
    let beacons: [Beacon] = [
        Beacon(id: 1, x: 3.45, y: 10.4),
        Beacon(id: 2, x: 0, y: 6.4),
        Beacon(id: 3, x: 5.6, y: 4.0),
        Beacon(id: 4, x: 2.4, y: 0),
    ]
    
    // Radio Map (測量數據)
    let radioMap: [Fingerprint] = [
        Fingerprint(x: 2.4, y: 0.8, rssi: [-57, -51, -58, -35], zone: "C"),
        Fingerprint(x: 0.8, y: 2.4, rssi: [-64, -65, -57, -48], zone: "C"),
        Fingerprint(x: 4.0, y: 5.6, rssi: [-57, -52, -48, -54], zone: "B"),
        Fingerprint(x: 2.4, y: 8.8, rssi: [-46, -54, -56, -53], zone: "A"),
        Fingerprint(x: 1.6, y: 8.8, rssi: [-48, -55, -62, -49], zone: "A"),
        Fingerprint(x: 3.2, y: 5.6, rssi: [-58, -54, -51, -52], zone: "B"),
        Fingerprint(x: 4.8, y: 4.0, rssi: [-61, -57, -39, -48], zone: "B"),
        Fingerprint(x: 1.6, y: 0.8, rssi: [-63, -56, -68, -38], zone: "C"),
        Fingerprint(x: 1.6, y: 2.4, rssi: [-61, -49, -63, -42], zone: "C"),
        Fingerprint(x: 3.2, y: 4.0, rssi: [-59, -59, -48, -49], zone: "B"),
        Fingerprint(x: 4.8, y: 5.6, rssi: [-52, -56, -49, -53], zone: "B"),
        Fingerprint(x: 0.8, y: 8.8, rssi: [-57, -57, -60, -51], zone: "A"),
        Fingerprint(x: 4.0, y: 4.0, rssi: [-62, -58, -44, -49], zone: "B"),
        Fingerprint(x: 2.4, y: 2.4, rssi: [-63, -49, -60, -42], zone: "C"),
        Fingerprint(x: 0.8, y: 0.8, rssi: [-65, -62, -54, -45], zone: "C"),
        Fingerprint(x: 4.0, y: 0.8, rssi: [-64, -63, -53, -43], zone: "C"),
        Fingerprint(x: 0.8, y: 4.0, rssi: [-62, -47, -55, -51], zone: "B"),
        Fingerprint(x: 4.0, y: 8.8, rssi: [-52, -58, -58, -53], zone: "A"),
        Fingerprint(x: 2.4, y: 5.6, rssi: [-56, -51, -51, -51], zone: "B"),
        Fingerprint(x: 1.6, y: 5.6, rssi: [-60, -43, -53, -52], zone: "B"),
        Fingerprint(x: 3.2, y: 8.8, rssi: [-47, -53, -64, -52], zone: "A"),
        Fingerprint(x: 4.8, y: 2.4, rssi: [-62, -57, -47, -44], zone: "C"),
        Fingerprint(x: 3.2, y: 0.8, rssi: [-58, -59, -53, -35], zone: "C"),
        Fingerprint(x: 4.8, y: 0.8, rssi: [-56, -57, -61, -48], zone: "C"),
        Fingerprint(x: 3.2, y: 2.4, rssi: [-57, -62, -47, -44], zone: "C"),
        Fingerprint(x: 1.6, y: 4.0, rssi: [-54, -49, -59, -48], zone: "B"),
        Fingerprint(x: 4.8, y: 8.8, rssi: [-48, -62, -57, -52], zone: "A"),
        Fingerprint(x: 0.8, y: 5.6, rssi: [-60, -47, -59, -51], zone: "B"),
        Fingerprint(x: 2.4, y: 4.0, rssi: [-58, -57, -53, -47], zone: "B"),
        Fingerprint(x: 4.0, y: 2.4, rssi: [-62, -61, -48, -45], zone: "C"),
        Fingerprint(x: 4.8, y: 4.8, rssi: [-52, -57, -42, -50], zone: "B"),
        Fingerprint(x: 3.2, y: 3.2, rssi: [-64, -58, -50, -47], zone: "C"),
        Fingerprint(x: 1.6, y: 9.6, rssi: [-51, -52, -67, -60], zone: "A"),
        Fingerprint(x: 1.6, y: 1.6, rssi: [-60, -52, -56, -42], zone: "C"),
        Fingerprint(x: 2.4, y: 1.6, rssi: [-56, -50, -53, -41], zone: "C"),
        Fingerprint(x: 2.4, y: 9.6, rssi: [-45, -50, -62, -51], zone: "A"),
        Fingerprint(x: 4.0, y: 3.2, rssi: [-59, -56, -45, -46], zone: "C"),
        Fingerprint(x: 0.8, y: 8.0, rssi: [-52, -53, -63, -47], zone: "A"),
        Fingerprint(x: 4.0, y: 4.8, rssi: [-57, -55, -47, -51], zone: "B"),
        Fingerprint(x: 2.4, y: 8.0, rssi: [-50, -48, -60, -48], zone: "A"),
        Fingerprint(x: 0.8, y: 9.6, rssi: [-56, -55, -58, -54], zone: "A"),
        Fingerprint(x: 0.8, y: 1.6, rssi: [-67, -58, -60, -42], zone: "C"),
        Fingerprint(x: 4.8, y: 3.2, rssi: [-64, -56, -43, -48], zone: "C"),
        Fingerprint(x: 1.6, y: 8.0, rssi: [-48, -50, -58, -51], zone: "A"),
        Fingerprint(x: 3.2, y: 4.8, rssi: [-57, -54, -47, -50], zone: "B"),
        Fingerprint(x: 4.8, y: 8.0, rssi: [-52, -62, -56, -50], zone: "A"),
        Fingerprint(x: 3.2, y: 9.6, rssi: [-42, -55, -64, -53], zone: "A"),
        Fingerprint(x: 1.6, y: 3.2, rssi: [-56, -52, -58, -45], zone: "C"),
        Fingerprint(x: 3.2, y: 1.6, rssi: [-60, -59, -50, -38], zone: "C"),
        Fingerprint(x: 4.0, y: 1.6, rssi: [-60, -60, -55, -41], zone: "C"),
        Fingerprint(x: 2.4, y: 3.2, rssi: [-59, -54, -62, -45], zone: "C"),
        Fingerprint(x: 4.0, y: 9.6, rssi: [-42, -63, -56, -60], zone: "A"),
        Fingerprint(x: 0.8, y: 4.8, rssi: [-53, -44, -58, -52], zone: "B"),
        Fingerprint(x: 4.0, y: 8.0, rssi: [-55, -61, -53, -47], zone: "A"),
        Fingerprint(x: 2.4, y: 4.8, rssi: [-60, -46, -53, -45], zone: "B"),
        Fingerprint(x: 0.8, y: 3.2, rssi: [-57, -51, -61, -46], zone: "C"),
        Fingerprint(x: 4.8, y: 1.6, rssi: [-62, -63, -56, -45], zone: "C"),
        Fingerprint(x: 4.8, y: 9.6, rssi: [-49, -55, -60, -63], zone: "A"),
        Fingerprint(x: 1.6, y: 4.8, rssi: [-58, -51, -55, -48], zone: "B"),
        Fingerprint(x: 3.2, y: 8.0, rssi: [-53, -51, -65, -52], zone: "A"),
        Fingerprint(x: 3.6, y: 7.6, rssi: [-63, -51, -63, -57], zone: "A"),
        Fingerprint(x: 2.8, y: 2.8, rssi: [-59, -63, -49, -38], zone: "C"),
        Fingerprint(x: 0.8, y: 6.4, rssi: [-54, -38, -59, -49], zone: "B"),
        Fingerprint(x: 4.4, y: 6.8, rssi: [-60, -59, -54, -54], zone: "B"),
        Fingerprint(x: 1.2, y: 2.8, rssi: [-57, -57, -58, -41], zone: "C"),
        Fingerprint(x: 2.4, y: 6.4, rssi: [-55, -47, -58, -50], zone: "B"),
        Fingerprint(x: 3.6, y: 3.6, rssi: [-65, -52, -51, -45], zone: "B"),
        Fingerprint(x: 1.6, y: 6.4, rssi: [-53, -43, -59, -54], zone: "B"),
        Fingerprint(x: 4.8, y: 6.4, rssi: [-56, -58, -50, -51], zone: "B"),
        Fingerprint(x: 2.0, y: 7.6, rssi: [-52, -52, -60, -57], zone: "A"),
        Fingerprint(x: 0.4, y: 3.6, rssi: [-58, -59, -57, -42], zone: "B"),
        Fingerprint(x: 1.2, y: 6.8, rssi: [-53, -41, -62, -53], zone: "B"),
        Fingerprint(x: 4.4, y: 2.8, rssi: [-62, -56, -52, -44], zone: "C"),
        Fingerprint(x: 4.0, y: 6.4, rssi: [-54, -58, -52, -50], zone: "B"),
        Fingerprint(x: 2.0, y: 3.6, rssi: [-58, -51, -62, -44], zone: "B"),
        Fingerprint(x: 2.8, y: 6.8, rssi: [-56, -48, -58, -56], zone: "B"),
        Fingerprint(x: 0.4, y: 7.6, rssi: [-51, -51, -58, -56], zone: "A"),
        Fingerprint(x: 3.2, y: 6.4, rssi: [-54, -53, -58, -50], zone: "B"),
        Fingerprint(x: 4.4, y: 3.6, rssi: [-62, -58, -47, -45], zone: "B"),
        Fingerprint(x: 3.6, y: 6.8, rssi: [-51, -54, -52, -52], zone: "B"),
        Fingerprint(x: 0.4, y: 2.8, rssi: [-59, -60, -62, -47], zone: "C"),
        Fingerprint(x: 2.4, y: 7.2, rssi: [-55, -48, -62, -52], zone: "B"),
        Fingerprint(x: 1.6, y: 7.2, rssi: [-53, -45, -59, -48], zone: "B"),
        Fingerprint(x: 4.4, y: 7.6, rssi: [-58, -59, -61, -56], zone: "A"),
        Fingerprint(x: 0.8, y: 7.2, rssi: [-52, -46, -63, -58], zone: "B"),
        Fingerprint(x: 2.0, y: 2.8, rssi: [-57, -58, -58, -40], zone: "C"),
        Fingerprint(x: 2.0, y: 6.8, rssi: [-52, -45, -58, -52], zone: "B"),
        Fingerprint(x: 2.8, y: 3.6, rssi: [-64, -61, -49, -43], zone: "B"),
        Fingerprint(x: 4.0, y: 7.2, rssi: [-55, -62, -54, -52], zone: "B"),
        Fingerprint(x: 3.2, y: 7.2, rssi: [-56, -51, -63, -56], zone: "B"),
        Fingerprint(x: 1.2, y: 7.6, rssi: [-53, -49, -60, -54], zone: "A"),
        Fingerprint(x: 2.8, y: 7.6, rssi: [-59, -53, -60, -54], zone: "A"),
        Fingerprint(x: 4.8, y: 7.2, rssi: [-53, -62, -57, -53], zone: "B"),
        Fingerprint(x: 0.4, y: 6.8, rssi: [-55, -42, -63, -49], zone: "B"),
        Fingerprint(x: 3.6, y: 2.8, rssi: [-64, -60, -47, -40], zone: "C"),
        Fingerprint(x: 1.2, y: 3.6, rssi: [-57, -51, -66, -46], zone: "B"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        resultTextView.text = ""
    }
    
    // 計算歐氏距離 (Euclidean Distance)
    func euclideanDistance(_ rssi1: [Int], _ rssi2: [Int]) -> Double {
        var sum: Double = 0.0
        for i in 0..<rssi1.count {
            sum += pow(Double(rssi1[i] - rssi2[i]), 2)
        }
        return sqrt(sum)
    }

    // Fingerprint 定位 (找最相似的座標)
    func fingerprintLocation(currentRSSI: [Int], k: Int = 3) -> (Double, Double, String) {
        // 計算每個數據點的距離
        let distances = radioMap.map { fingerprint in
            (fingerprint, euclideanDistance(currentRSSI, fingerprint.rssi))
        }
        
        // 按距離排序，取前 k 個
        let kNearest = distances.sorted { $0.1 < $1.1 }.prefix(k)
        
        // 計算平均座標 (加權平均也可以)
        var sumX = 0.0
        var sumY = 0.0
        var zoneVotes: [String: Int] = [:]
        for (fingerprint, _) in kNearest {
            sumX += fingerprint.x
            sumY += fingerprint.y
            zoneVotes[fingerprint.zone, default: 0] += 1
        }
        let predictedZone = zoneVotes.max { $0.value < $1.value }?.key ?? "Unknown"
        return (sumX / Double(k), sumY / Double(k), predictedZone)
    }

    @IBAction func locate(_ sender: UIButton) {
        // 讀取 RSSI 輸入
        let rssiString = rssiTextField.text ?? ""
        let rssiValues = rssiString.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        if rssiValues.count != 4 {
            resultTextView.text = "❌ 請輸入 4 個 Beacon 的 RSSI 值，用逗號分隔。"
            return
        }
        
        // 計算位置
        let (x, y, zone) = fingerprintLocation(currentRSSI: rssiValues, k: 3)
        resultTextView.text = String(format: "預測位置：\nx = %.3f, y = %.3f\n📍 區域：%@", x, y, zone)
        print("預測位置: x = \(x), y = \(y), 區域 = \(zone)")

    }
}
