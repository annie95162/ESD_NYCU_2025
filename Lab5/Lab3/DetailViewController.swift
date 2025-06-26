//
//  DetailViewController.swift
//  Lab3
//
//  Created by annie on 2025/4/1.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var costField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    var data: [String:Any]!
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Data received: \(String(describing: data))")

        if let datashow = data {
            let date = datashow["date"] as! Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy/MM/dd HH:mm:ss"
            dateLabel.text = dateFormatter.string(from: date)  // 顯示日期
            nameField.text = datashow["name"] as? String
            costField.text = String(describing: datashow["cost"] as? Double ?? 0)
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("Data received: \(String(describing: data))")

        //print("prepare of detail is true")
        
        // 解析日期並傳回資料
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd HH:mm:ss"
        let date = Date()
        //let date = dateFormatter.date(from: dateLabel.text ?? "") ?? Date()
        
        // 傳遞回更新後的資料
        self.data = [
            "date": date,  // 儲存 Date 類型的日期
            "name": nameField.text ?? "",
            "cost": Double(costField.text ?? "") ?? 0.0
        ]
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
