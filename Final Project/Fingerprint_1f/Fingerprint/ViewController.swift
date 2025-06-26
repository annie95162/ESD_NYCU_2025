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
}

class ViewController: UIViewController {
    
    @IBOutlet weak var rssiTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    // 8 個 Beacon 座標 (假設已知)
    let beacons: [Beacon] = [
        Beacon(id: 1, x: 0.0, y: 0.0),
        Beacon(id: 2, x: 2.1, y: 2.67),
        Beacon(id: 3, x: 5.4, y: 0),
        Beacon(id: 4, x: 9.6, y: 2.67),
        Beacon(id: 5, x: 10.5, y: 0),
        Beacon(id: 6, x: 12.6, y: 2.67),
        Beacon(id: 7, x: 15.0, y: 0.0),
        Beacon(id: 8, x: 16.5, y: 3.9)
    ]
    
    // Radio Map (測量數據)
    let radioMap: [Fingerprint] = [
        Fingerprint(x: 5.4, y: 1.98, rssi: [-60, -53, -54, -62, -52, -60, -65, -72]),
        Fingerprint(x: 0.0, y: 1.32, rssi: [-42, -60, -58, -75, -63, -63, -77, -76]),
        Fingerprint(x: 9.6, y: 1.98, rssi: [-63, -67, -51, -39, -41, -59, -70, -77]),
        Fingerprint(x: 14.4, y: 1.98, rssi: [-66, -65, -64, -68, -48, -49, -53, -51]),
        Fingerprint(x: 3.0, y: 1.98, rssi: [-51, -48, -50, -65, -60, -62, -70, -70]),
        Fingerprint(x: 12.0, y: 1.98, rssi: [-69, -69, -60, -66, -43, -39, -56, -65]),
        Fingerprint(x: 13.8, y: 1.98, rssi: [-67, -69, -61, -68, -48, -42, -58, -50]),
        Fingerprint(x: 0.6, y: 0.66, rssi: [-40, -57, -55, -69, -66, -70, -78, -78]),
        Fingerprint(x: 15.6, y: 1.98, rssi: [-75, -70, -65, -73, -60, -48, -55, -52]),
        Fingerprint(x: 0.6, y: 1.32, rssi: [-43, -56, -50, -63, -60, -65, -72, -70]),
        Fingerprint(x: 8.4, y: 1.98, rssi: [-58, -60, -52, -54, -44, -53, -65, -72]),
        Fingerprint(x: 13.2, y: 1.98, rssi: [-71, -69, -68, -69, -49, -33, -52, -56]),
        Fingerprint(x: 1.5, y: 3.18, rssi: [-78, -78, -70, -72, -63, -54, -59, -52]),
        Fingerprint(x: 7.2, y: 1.98, rssi: [-60, -67, -51, -61, -54, -57, -65, -69]),
        Fingerprint(x: 16.2, y: 1.98, rssi: [-73, -67, -65, -68, -53, -57, -55, -46]),
        Fingerprint(x: 11.4, y: 1.98, rssi: [-70, -74, -61, -66, -42, -47, -63, -68]),
        Fingerprint(x: 16.8, y: 1.98, rssi: [-70, -70, -72, -72, -62, -59, -60, -45]),
        Fingerprint(x: 7.8, y: 1.98, rssi: [-59, -60, -50, -59, -42, -60, -63, -71]),
        Fingerprint(x: 6.0, y: 1.98, rssi: [-58, -54, -49, -64, -54, -55, -62, -68]),
        Fingerprint(x: 4.8, y: 1.32, rssi: [-55, -59, -51, -65, -51, -55, -64, -69]),
        Fingerprint(x: 4.8, y: 0.66, rssi: [-57, -58, -37, -66, -60, -58, -71, -65]),
        Fingerprint(x: 1.56, y: 3.18, rssi: [-74, -75, -67, -75, -54, -59, -60, -48]),
        Fingerprint(x: 1.68, y: 3.18, rssi: [-72, -70, -63, -77, -59, -52, -61, -50]),
        Fingerprint(x: 4.2, y: 0.66, rssi: [-58, -51, -43, -60, -56, -54, -68, -63]),
        Fingerprint(x: 17.4, y: 3.18, rssi: [-74, -71, -67, -73, -61, -60, -57, -41]),
        Fingerprint(x: 4.2, y: 1.32, rssi: [-54, -51, -42, -60, -59, -51, -65, -69]),
        Fingerprint(x: 1.62, y: 3.18, rssi: [-74, -71, -68, -75, -56, -51, -59, -49]),
        Fingerprint(x: 6.6, y: 1.98, rssi: [-58, -56, -50, -66, -51, -55, -67, -72]),
        Fingerprint(x: 9.0, y: 1.98, rssi: [-54, -63, -58, -49, -48, -53, -62, -70]),
        Fingerprint(x: 10.2, y: 0.66, rssi: [-65, -70, -62, -54, -43, -53, -68, -60]),
        // Fingerprint(x: 1.2, y: 1.32, rssi: [-43, -52, -52, -69, -61, -67," ", -78]),
        Fingerprint(x: 0.0, y: 66.0, rssi: [-35, -56, -56, -69, -60, -70, -78, -76]),
        Fingerprint(x: 10.2, y: 1.32, rssi: [-66, -71, -55, -47, -38, -53, -63, -66]),
        Fingerprint(x: 1.2, y: 0.66, rssi: [-53, -58, -51, -64, -60, -59, -80, -70]),
        Fingerprint(x: 3.6, y: 1.98, rssi: [-55, -51, -45, -64, -54, -62, -68, -62]),
        Fingerprint(x: 12.6, y: 1.98, rssi: [-71, -75, -61, -65, -45, -34, -49, -58]),
        Fingerprint(x: 15.0, y: 1.98, rssi: [-72, -67, -68, -70, -54, -50, -50, -46]),
        Fingerprint(x: 1.8, y: 0.66, rssi: [-54, -57, -53, -65, -55, -65, -69, -67]),
        Fingerprint(x: 10.8, y: 1.32, rssi: [-66, -66, -62, -55, -43, -45, -59, -61]),
        Fingerprint(x: 1.8, y: 1.32, rssi: [-50, -47, -49, -69, -60, -64, -74, -71]),
        Fingerprint(x: 10.8, y: 0.66, rssi: [-70, -59, -59, -51, -39, -45, -62, -59]),
        // Fingerprint(x: 17.4, y: 1.32, rssi: [" ",-73, -65, -77, -64, -49, -61, -49]),
        Fingerprint(x: 2.4, y: 1.98, rssi: [-53, -43, -50, -60, -58, -60, -65, -65]),
        Fingerprint(x: 17.4, y: 0.66, rssi: [-76, -69, -68, -70, -57, -55, -55, -52]),
        Fingerprint(x: 8.4, y: 0.66, rssi: [-60, -56, -55, -56, -47, -52, -70, -61]),
        Fingerprint(x: 15.6, y: 1.32, rssi: [-74, -71, -65, -69, -57, -52, -50, -49]),
        Fingerprint(x: 0.6, y: 1.98, rssi: [-47, -52, -51, -67, -64, -68, -76, -75]),
        Fingerprint(x: 8.4, y: 1.32, rssi: [-57, -63, -51, -57, -45, -59, -69, -63]),
        Fingerprint(x: 15.6, y: 0.66, rssi: [-74, -66, -71, -73, -56, -52, -49, -53]),
        Fingerprint(x: 13.2, y: 1.32, rssi: [-73, -73, -62, -65, -51, -36, -48, -56]),
        Fingerprint(x: 13.2, y: 0.66, rssi: [-72, -67, -72, -65, -52, -52, -53, -55]),
        Fingerprint(x: 0.0, y: 1.98, rssi: [-43, -60, -57, -70, -60, -66, -77, -74]),
        Fingerprint(x: 5.4, y: 1.32, rssi: [-55, -56, -54, -64, -52, -60, -71, -68]),
        Fingerprint(x: 14.4, y: 0.66, rssi: [-71, -73, -66, -67, -55, -48, -42, -56]),
        Fingerprint(x: 9.6, y: 1.32, rssi: [-67, -73, -52, -43, -40, -54, -65, -70]),
        Fingerprint(x: 5.4, y: 0.66, rssi: [-55, -61, -42, -61, -55, -61, -71, -67]),
        Fingerprint(x: 14.4, y: 1.32, rssi: [-78, -68, -68, -73, -56, -47, -54, -53]),
        Fingerprint(x: 9.6, y: 0.66, rssi: [-68, -62, -57, -56, -44, -50, -65, -59]),
        Fingerprint(x: 12.0, y: 0.66, rssi: [-81, -71, -59, -57, -49, -53, -57, -57]),
        Fingerprint(x: 13.8, y: 0.66, rssi: [-74, -69, -69, -62, -51, -48, -52, -56]),
        Fingerprint(x: 3.0, y: 1.32, rssi: [-55, -47, -47, -66, -54, -65, -71, -67]),
        Fingerprint(x: 12.0, y: 1.32, rssi: [-67, -64, -57, -61, -41, -40, -52, -54]),
        Fingerprint(x: 13.8, y: 1.32, rssi: [-72, -67, -60, -67, -53, -44, -54, -49]),
        Fingerprint(x: 3.0, y: 0.66, rssi: [-54, -54, -48, -68, -58, -59, -65, -69]),
        //Fingerprint(x: 11.4, y: 1.32, rssi: [" ",-72, -72, -65, -41, -50, -63, -61]),
        Fingerprint(x: 11.4, y: 0.66, rssi: [-68, -60, -57, -56, -44, -49, -62, -58]),
        Fingerprint(x: 7.8, y: 0.66, rssi: [-60, -55, -53, -55, -52, -51, -67, -61]),
        Fingerprint(x: 16.8, y: 1.32, rssi: [-74, -70, -63, -74, -58, -50, -60, -48]),
        Fingerprint(x: 6.0, y: 0.66, rssi: [-57, -51, -37, -66, -52, -53, -70, -68]),
        Fingerprint(x: 7.8, y: 1.32, rssi: [-55, -62, -47, -64, -44, -57, -63, -65]),
        Fingerprint(x: 16.8, y: 0.66, rssi: [-75, -66, -72, -74, -63, -57, -65, -52]),
        Fingerprint(x: 6.0, y: 1.32, rssi: [-57, -57, -39, -68, -58, -61, -79, -71]),
        //Fingerprint(x: 1.44, y: 3.18, rssi: [-77, -78," ", -73, -59, -55, -62, -56]),
        //Fingerprint(x: 16.2, y: 0.66, rssi: [" ", -65, -63, -72, -60, -56, -57, -47]),
        Fingerprint(x: 7.2, y: 1.32, rssi: [-62, -60, -52, -58, -53, -52, -68, -64]),
        Fingerprint(x: 16.2, y: 1.32, rssi: [-70, -71, -68, -74, -54, -52, -58, -46]),
        Fingerprint(x: 7.2, y: 0.66, rssi: [-57, -62, -49, -56, -49, -51, -64, -64]),
        Fingerprint(x: 4.2, y: 1.98, rssi: [-55, -51, -49, -66, -61, -59, -66, -70]),
        Fingerprint(x: 6.6, y: 0.66, rssi: [-56, -55, -39, -65, -54, -56, -73, -63]),
        Fingerprint(x: 6.6, y: 1.32, rssi: [-57, -55, -50, -58, -51, -55, -64, -66]),
        Fingerprint(x: 4.8, y: 1.98, rssi: [-60, -52, -46, -62, -54, -61, -63, -70]),
        Fingerprint(x: 15.0, y: 1.32, rssi: [-76, -75, -71, -75, -54, -47, -46, -47]),
        Fingerprint(x: 10.8, y: 1.98, rssi: [-73, -73, -65, -61, -47, -46, -54, -66]),
        Fingerprint(x: 1.8, y: 1.98, rssi: [-49, -43, -56, -69, -66, -65, -74, -73]),
        Fingerprint(x: 15.0, y: 0.66, rssi: [-77, -75, -68, -75, -54, -50, -47, -54]),
        Fingerprint(x: 2.4, y: 0.66, rssi: [-55, -58, -49, -64, -55, -66, -65, -67]),
        Fingerprint(x: 17.4, y: 1.98, rssi: [-70, -75, -68, -73, -65, -55, -58, -45]),
        Fingerprint(x: 2.4, y: 1.32, rssi: [-55, -53, -47, -65, -59, -61, -69, -68]),
        Fingerprint(x: 9.0, y: 1.32, rssi: [-67, -61, -55, -48, -45, -59, -64, -66]),
        Fingerprint(x: 1.2, y: 1.98, rssi: [-48, -56, -60, -72, -64, -63, -74, -73]),
        Fingerprint(x: 10.2, y: 1.98, rssi: [-67, -59, -53, -45, -44, -55, -58, -69]),
        Fingerprint(x: 9.0, y: 0.66, rssi: [-63, -58, -54, -58, -44, -50, -74, -64]),
        Fingerprint(x: 3.6, y: 1.32, rssi: [-56, -50, -46, -63, -58, -63, -74, -76]),
        Fingerprint(x: 12.6, y: 0.66, rssi: [-72, -64, -60, -57, -51, -44, -57, -53]),
        Fingerprint(x: 3.6, y: 0.66, rssi: [-58, -53, -47, -65, -58, -60, -68, -69]),
        Fingerprint(x: 12.6, y: 1.32, rssi: [-75, -66, -69, -65, -44, -39, -57, -57]),
        Fingerprint(x: 17.4, y: 3.3, rssi: [-76, -75, -60, -77, -54, -55, -65, -36]),
        //Fingerprint(x: 17.4, y: 2.64, rssi: [-75, -72, -76, -61, -57, -60, -40]),
        //Fingerprint(x: 17.4, y: 1.32, rssi: [-78, -67, -62, -52, -63, -50]),
        Fingerprint(x: 15.0, y: 3.3, rssi: [-77, -73, -68, -78, -57, -58, -58, -46]),
        Fingerprint(x: 15.6, y: 1.32, rssi: [-74, -77, -69, -69, -58, -51, -50, -48]),
        Fingerprint(x: 16.8, y: 2.64, rssi: [-74, -72, -66, -75, -56, -54, -58, -50]),
        Fingerprint(x: 16.2, y: 2.64, rssi: [-81, -73, -62, -76, -56, -52, -63, -49]),
        Fingerprint(x: 16.8, y: 3.3, rssi: [-77, -71, -66, -76, -57, -55, -60, -43]),
        Fingerprint(x: 16.8, y: 1.32, rssi: [-77, -77, -71, -80, -59, -52, -62, -53]),
        Fingerprint(x: 15.6, y: 2.64, rssi: [-75, -66, -61, -75, -53, -55, -57, -46]),
        Fingerprint(x: 14.4, y: 2.64, rssi: [-70, -67, -69, -73, -53, -52, -56, -57]),
        //Fingerprint(x: 16.2, y: 1.32, rssi: [-74, -65, -74, -59, -52, -52, -48]),
        Fingerprint(x: 15.0, y: 2.64, rssi: [-68, -65, -63, -68, -53, -57, -60, -47]),
        Fingerprint(x: 15.6, y: 3.3, rssi: [-77, -73, -70, -74, -55, -58, -62, -49]),
        Fingerprint(x: 16.2, y: 3.3, rssi: [-71, -67, -66, -68, -52, -52, -55, -48]),
        Fingerprint(x: 14.4, y: 3.3, rssi: [-81, -72, -72, -78, -62, -54, -55, -55])
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
    func fingerprintLocation(currentRSSI: [Int], k: Int = 3) -> (Double, Double) {
        // 計算每個數據點的距離
        let distances = radioMap.map { fingerprint in
            (fingerprint, euclideanDistance(currentRSSI, fingerprint.rssi))
        }
        
        // 按距離排序，取前 k 個
        let kNearest = distances.sorted { $0.1 < $1.1 }.prefix(k)
        
        // 計算平均座標 (加權平均也可以)
        var sumX = 0.0
        var sumY = 0.0
        for (fingerprint, _) in kNearest {
            sumX += fingerprint.x
            sumY += fingerprint.y
        }
        
        return (sumX / Double(k), sumY / Double(k))
    }

    @IBAction func locate(_ sender: UIButton) {
        // 讀取 RSSI 輸入
        let rssiString = rssiTextField.text ?? ""
        let rssiValues = rssiString.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        if rssiValues.count != 8 {
            resultTextView.text = "❌ 請輸入 8 個 Beacon 的 RSSI 值，用逗號分隔。"
            return
        }
        
        // 計算位置
        let position = fingerprintLocation(currentRSSI: rssiValues, k: 3)
        resultTextView.text = "預測位置: \n x = \(position.0), y = \(position.1)"
        print("預測位置: x = \(position.0), y = \(position.1)")

    }
}
