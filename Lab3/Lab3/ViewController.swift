//
//  ViewController.swift
//  Lab3
//
//  Created by annie on 2025/3/18.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //var dataArray:[Double] = [123, 456, 789]
    var dataArray = [[String:Any]]()
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var newCostField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadDataArray()
        updateTotal()
    }
    @IBAction func addData(_ sender: Any) {
        guard let newCostString = newCostField.text, !newCostString.isEmpty else { return }
        
        guard let newCost = Double(newCostString) else { return }
        guard let newName = nameField.text, !newName.isEmpty else { return }
        let newDate = Date()
        dataArray.append(["name":newName, "cost":newCost, "date":newDate])
        saveDataArray()
        tableView.reloadData()
        updateTotal()
        newCostField.text = ""
        nameField.text = ""
        newCostField.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic Cell", for: indexPath)
        
        let name = dataArray[indexPath.row]["name"] as? String ?? "No Name"
        
        let cost = dataArray[indexPath.row]["cost"] as? Double ?? 0.0
        let date = dataArray[indexPath.row]["date"] as? Date ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: date)
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = "\(cost) - \(dateString)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            updateTotal()
            saveDataArray()
        default:
            break
        }
    }
    
    func updateTotal() {
        var total: Double = 0
        for item in dataArray {
            if let cost = item["cost"] as? Double {
                total += cost
            }
        }
        totalCostLabel.text = "\(total)"
    }
    
    func writeStringToFile(writeString: String, fileName: String) {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = dir.appendingPathComponent(fileName)
        do {
            try writeString.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print("write error")
        }
    }
    
    func readFileToString(fileName: String) -> String {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return ""
        }
        let fileURL = dir.appendingPathComponent(fileName)
        var readString = ""
        do {
            try readString = String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print("read error")
        }
        return readString
    }
    
    func saveDataArray() {
        var finalString = ""
        for item in dataArray{
            if let name = item["name"] as? String,
               let cost = item["cost"] as? Double,
               let date = item["date"] as? Date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let dateString =  dateFormatter.string(from: date)
                finalString += "\(dateString),\(name),\(cost)\n"
            }
            
        }
        writeStringToFile(writeString: finalString, fileName: "data.txt")
    }
    
    func loadDataArray() {
        var finalArray = [[String:Any]]()
        let csvString = readFileToString(fileName: "data.txt")
        let rows = csvString.split(separator: "\n")
        for row in rows{
            let columns = row.split(separator: ",")
            if columns.count == 3{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let date = dateFormatter.date(from: String(columns[0])) ?? Date()
                let name = String(columns[1])
                let cost = Double(columns[2]) ?? 0.0
                finalArray.append(["date": date, "name": name, "cost": cost])
            }
        }
        dataArray = finalArray
        tableView.reloadData()
        updateTotal()
    }
    
}
