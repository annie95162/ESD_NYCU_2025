//
//  ViewController.swift
//  iBeacon
//
//  Created by annie on 2025/4/15.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var rangingResultTextView: UITextView!
    @IBOutlet weak var monitorResultTextView: UITextView!
    @IBOutlet weak var pointIDTextField: UITextField!
    
    var locationManager: CLLocationManager = CLLocationManager()
    let uuid = "77C99B62-88FC-4C78-B39C-D6FE06E76372"
    let identifier = "esd region"
    var beaconLog: [[String]] = [["Time", "Major", "Minor", "RSSI", "Accuracy"]]
    var rssiSum: [String: Int] = [:]
    var rssiCount: [String: Int] = [:]
    var rssiMax: [String: Int] = [:]                                
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //要求使用者授權 location service (iOS 14 有改版，大家可自行選擇)
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
            if #available(iOS 14, *){
                let currentStatus = locationManager.authorizationStatus
                if currentStatus != CLAuthorizationStatus.authorizedAlways{
                    locationManager.requestAlwaysAuthorization()
                }
            }else{
                let currentStatus = CLLocationManager.authorizationStatus()
                if currentStatus != CLAuthorizationStatus.authorizedAlways{
                    locationManager.requestAlwaysAuthorization()
                }
            }
        }
        //創造包含同樣 uuid 的 beacon 的 region
        let region = CLBeaconRegion(uuid: UUID.init(uuidString: uuid)!,
        identifier: identifier)
        
        //設定 location manager 的 delegate
        locationManager.delegate = self
        //設定region monitoring 要被通知的時機
        region.notifyEntryStateOnDisplay = true
        region.notifyOnEntry = true
        region.notifyOnExit = true
        //開始 monitoring
        locationManager.startMonitoring(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region:
    CLRegion) {
    //將成功開始 monitor 的 region 的 identifier 加入到 monitor textview 最上方
    monitorResultTextView.text = "did start monitoring \(region.identifier)\n" +
    monitorResultTextView.text
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    //將偵測到進入 region 的狀態加入到 monitor textview 最上方
    monitorResultTextView.text = "did enter\n" + monitorResultTextView.text
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    //將偵測到離開 region 的狀態加入到 monitor textview 最上方
    monitorResultTextView.text = "did exit\n" + monitorResultTextView.text
    }
    func locationManager(_ manager: CLLocationManager, didDetermineState state:
    CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
        //將偵測到在 region 內的狀態加入到 monitor textview 最上方
            monitorResultTextView.text = "state inside\n" + monitorResultTextView.text
            manager.startRangingBeacons(satisfying:
            CLBeaconIdentityConstraint(uuid: UUID.init(uuidString: uuid)!))
        case .outside:
        //將偵測到在 region 外的狀態加入到 monitor textview 最上方
            monitorResultTextView.text = "state outside\n" + monitorResultTextView.text
            manager.stopMonitoring(for: region)
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons:
    [CLBeacon], in region: CLBeaconRegion) {
        //清空原本的ranging textview
        rangingResultTextView.text = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current  // 當前時區
        
        let timeString = formatter.string(from: Date())
        //iterate 每個收到的 beacon
        for beacon in beacons {
        //根據不同 proximity 常數設定 proximityString
            if beacon.major == 1 && beacon.rssi <= -5 {
                let beaconKey = "\(beacon.major)_\(beacon.minor)"
                if rssiSum[beaconKey] == nil {
                    rssiSum[beaconKey] = 0
                    rssiCount[beaconKey] = 0
                    rssiMax[beaconKey] = Int.min
                }
                rssiSum[beaconKey]! += beacon.rssi
                rssiCount[beaconKey]! += 1
                if beacon.rssi > rssiMax[beaconKey]! && beacon.rssi != 0 {
                    rssiMax[beaconKey] = beacon.rssi
                }
                
                let averageRSSI = rssiSum[beaconKey]! / rssiCount[beaconKey]!
                
                var proximityString = ""
                switch beacon.proximity {
                case .far:
                    proximityString = "far"
                case .near:
                    proximityString = "near"
                case .immediate:
                    proximityString = "immediate"
                default :
                    proximityString = "unknown"
                }
                //把這個beacon的數值放到ranging textview上
                rangingResultTextView.text = rangingResultTextView.text +
                "Major: \(beacon.major)" + " Minor: \(beacon.minor)" +
                " RSSI: \(beacon.rssi)" + "\n" + "Avg RSSI: \(averageRSSI)" + "Max RSSI: \(rssiMax[beaconKey]!)" + " Proximity: \(proximityString)" + "\n" +
                " Accuracy: \(beacon.accuracy)" + "\n\n";
                
                beaconLog.append([
                    timeString,
                    "\(beacon.major)",
                    "\(beacon.minor)",
                    "\(beacon.rssi)",
                    String(format: "%.2f", beacon.accuracy)
                ])
            }
        }
    }

    @IBAction func exportCSV(_ sender: Any) {
        // ✅ 確保 pointIDTextField 已連線並有值
        guard let pointID = pointIDTextField?.text, !pointID.isEmpty else {
            print("❌ 請輸入點編號")
            return
        }
        
        print("⏳ 5 秒後將自動匯出 CSV...")
        
        // 5 秒後匯出 CSV
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.exportCSVFile(pointID: pointID)
        }
    }
    
    func exportCSVFile(pointID: String) {
        let fileName = "region_\(pointID).csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        var sortedLog = beaconLog.dropFirst().sorted {  // 忽略標題列
            let major1 = Int($0[1])!
            let minor1 = Int($0[2])!
            let major2 = Int($1[1])!
            let minor2 = Int($1[2])!
            return major1 < major2 || (major1 == major2 && minor1 < minor2)
        }
        // 加入最大 RSSI 列
        for key in rssiSum.keys.sorted() {
            let parts = key.split(separator: "_")
            let major = parts[0]
            let minor = parts[1]
            let maxRSSI = rssiMax[key] ?? 0
            let avgRSSI = rssiSum[key]! / rssiCount[key]!
            
            sortedLog.append([
                "Summary",
                "\(major)",
                "\(minor)",
                "\(maxRSSI)",
                "\(avgRSSI)"
            ])
        }
        var csvText = beaconLog[0].joined(separator: ",") + "\n"
        for row in sortedLog {
            csvText += row.joined(separator: ",") + "\n"
        }

        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            print("✅ \(pointID) 儲存成功：\(path)")
            
            let activityVC = UIActivityViewController(activityItems: [path], applicationActivities: nil)

            // iPad anchor 設定
            if let sourceView = self.view {
                activityVC.popoverPresentationController?.sourceView = sourceView
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 1, height: 1)
            }
            
            self.present(activityVC, animated: true, completion: nil)

        } catch {
            print("❌ 儲存失敗：\(error)")
        }
    }
    
    @IBAction func resetData(_ sender: Any) {
        beaconLog = [["Time", "Major", "Minor", "RSSI", "Accuracy"]]
        rssiSum.removeAll()
        rssiCount.removeAll()
        rssiMax.removeAll()
        rangingResultTextView.text = ""
        print("🔄 記錄已重置")
    }
    
}

