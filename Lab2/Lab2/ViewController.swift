//
//  ViewController.swift
//  Lab2
//
//  Created by annie on 2025/4/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var digitLabel: UILabel!
    // MARK: - State Properties

    /// 按下運算符後，下一次輸入是否要清空顯示開始新數字
    private var shouldStartNewNumberInput = false
    /// 暫存上一個操作數（連續運算用）
    private var pendendingNumber = ""
    /// 紀錄目前運算符（+ - × ÷）
    private var lastOperator = ""
    /// 紀錄上一次運算的第二個操作數（重複等號用）
    private var lastOperand: Double = 0.0
    /// 紀錄是否剛做完一次運算（控制重複等號）
    private var hasCalculated = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        resetAll()
    }

    // MARK: - IBActions

    /// 處理數字鍵 (0–9) 及小數點
    @IBAction func digitalButtonPressed(_ sender: UIButton) {
        guard let digit = sender.titleLabel?.text else { return }

        if shouldStartNewNumberInput {
            digitLabel.text = "0"
            shouldStartNewNumberInput = false
        }

        // 小數點只允許一次
        if digit == "." && digitLabel.text!.contains(".") {
            return
        }

        // 若顯示為 "0" 且不是小數點，直接以該輸入取代
        if digitLabel.text == "0" && digit != "." {
            digitLabel.text = digit
        } else {
            digitLabel.text! += digit
        }

        hasCalculated = false
    }

    /// 處理 +, -, ×, ÷ 鍵（連續運算）
    @IBAction func operatorButtonPressed(_ sender: UIButton) {
        guard let op = sender.titleLabel?.text else { return }

        // 若已有 pendendingNumber 且剛剛未切換到新數字，先執行一次上一次運算
        if !pendendingNumber.isEmpty && !shouldStartNewNumberInput {
            if let lhs = Double(pendendingNumber),
               let rhs = Double(digitLabel.text!) {
                let interim = calculate(lhs: lhs, rhs: rhs, op: lastOperator)
                digitLabel.text = formatResult(interim)
                pendendingNumber = formatResult(interim)
            }
        }
        // 若是第一次按運算符，則暫存當前顯示
        else if pendendingNumber.isEmpty {
            pendendingNumber = digitLabel.text!
        }

        operatorLabel.text = op
        lastOperator = op
        shouldStartNewNumberInput = true
        hasCalculated = false
    }

    /// 處理 = 鍵，以及「重複等號」功能
    @IBAction func equalButtonPressed(_ sender: Any) {
        guard let op = operatorLabel.text, !op.isEmpty else { return }

        if !hasCalculated {
            // 正常第一次計算
            if let lhs = Double(pendendingNumber),
               let rhs = Double(digitLabel.text!) {
                let result = calculate(lhs: lhs, rhs: rhs, op: op)
                digitLabel.text = formatResult(result)
                lastOperand = rhs
                hasCalculated = true
            }
        } else {
            // 重複等號：用目前顯示值與 lastOperand 再運算一次
            if let current = Double(digitLabel.text!) {
                let result = calculate(lhs: current, rhs: lastOperand, op: op)
                digitLabel.text = formatResult(result)
            }
        }

        pendendingNumber = ""
        shouldStartNewNumberInput = true
    }

    /// 處理 AC（All Clear）
    @IBAction func allClearButtonPressed(_ sender: Any) {
        resetAll()
    }

    /// 加分題：Back 鍵（刪除最後一個字元）
    @IBAction func backButtonPressed(_ sender: Any) {
        var text = digitLabel.text!
        guard !text.isEmpty else { return }
        text.removeLast()
        digitLabel.text = text.isEmpty ? "0" : text
    }

    // MARK: - Helpers

    /// 重置所有顯示及狀態
    private func resetAll() {
        digitLabel.text = "0"
        operatorLabel.text = ""
        pendendingNumber = ""
        lastOperator = ""
        lastOperand = 0.0
        shouldStartNewNumberInput = false
        hasCalculated = false
    }

    /// 執行單一運算
    private func calculate(lhs: Double, rhs: Double, op: String) -> Double {
        switch op {
        case "+": return lhs + rhs
        case "-": return lhs - rhs
        case "x": return lhs * rhs
        case "/": return rhs == 0 ? Double.nan : lhs / rhs
        default:  return rhs
        }
    }

    /// 格式化結果：整數不顯示小數點
    private func formatResult(_ value: Double) -> String {
        if value.isNaN { return "Error" }
        if floor(value) == value {
            return String(format: "%.0f", value)
        } else {
            return String(value)
        }
    }
}

