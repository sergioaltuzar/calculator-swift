//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Sergio Altuzar on 15/08/22.
//

import UIKit

final class HomeViewController: UIViewController {
    // MARK: - Outlets
    
    //Result
    @IBOutlet weak var number0: UIButton!
    
    //Numbers
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    //Operators
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPorncent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorAdittion: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    // MARK: - Variables
    
    private var total: Double = 0 // Total
    private var temp: Double = 0 // Valor pot pantalla
    private var operating = false // Indicar se se ha selecciona un operador
    private var decimal = false // Indicar si el valor es decimal
    private var operation: operationType = .none // Operacion actual
    
    // MARK: Constantes
    
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let kTotal = "total"
    
    private enum operationType {
        case none, adittion, substraction, miltiplication, division, percent
    }
    
    // Formateo de valores auxiliares
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // Formateo de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    // Formateador total de valores auxiliares
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateador de valores en formato cientifico
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    
    
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        total = UserDefaults.standard.double(forKey: kTotal)
        result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //UI
    number0.round()
    number1.round()
    number2.round()
    number3.round()
    number4.round()
    number5.round()
    number6.round()
    number7.round()
    number8.round()
    number9.round()
    numberDecimal.round()
    
    operatorAC.round()
    operatorPlusMinus.round()
    operatorPorncent.round()
    operatorResult.round()
    operatorAdittion.round()
    operatorSubstraction.round()
    operatorMultiplication.round()
    operatorDivision.round()
    }
    
    // MARK: - Button Action
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    @IBAction func operatorPorcentAction(_ sender: UIButton) {
        if operation != .percent {
            result()
        }
        operating = true
        operation = .percent
        result()
        sender.shine()
    }
    @IBAction func operatorAdittionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        
        operating = true
        operation = .adittion
        sender.selecOperation(true)
        sender.shine()
    }
    @IBAction func operatorResultAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        sender.shine()
    }
    @IBAction func operatorSubstractionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .substraction
        sender.selecOperation(true)
        sender.shine()
    }
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .miltiplication
        sender.selecOperation(true)
        sender.shine()
    }
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        if operation != .none {
        result()
    }
        operating = true
        operation = .division
        sender.selecOperation(true)
        sender.shine()
    }
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        selectVisualOperation()
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        operatorAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        // Hemos seleccionado una operacion
        
        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        //Hemos seleccionado decimales
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        selectVisualOperation()
                sender.shine()
    }
    
    // Limpia los valores
    private func clear(){
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        }else {
            total = 0
        }
        
    }
    // Obtiene resultado final
    private func result() {
        switch operation {
            
        case .none:
            // No hacemos nada
            break
        case .adittion:
            total = total + temp
            break
        case .substraction:
            total = total - temp
            break
        case .miltiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
        }
        
    // Formateo en pantalla
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        operation = .none
        selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("Total: \(total)")
    }
    
    private func selectVisualOperation(){
        if !operating {
            //No estamos operando
            operatorAdittion.selecOperation(false)
            operatorSubstraction.selecOperation(false)
            operatorMultiplication.selecOperation(false)
            operatorDivision.selecOperation(false)
        }else {
            switch operation {
            case .none, .percent:
                operatorAdittion.selecOperation(false)
                operatorSubstraction.selecOperation(false)
                operatorMultiplication.selecOperation(false)
                operatorDivision.selecOperation(false)
                break
            case .adittion:
                operatorAdittion.selecOperation(true)
                operatorSubstraction.selecOperation(false)
                operatorMultiplication.selecOperation(false)
                operatorDivision.selecOperation(false)
                break
            case .substraction:
                operatorAdittion.selecOperation(false)
                operatorSubstraction.selecOperation(true)
                operatorMultiplication.selecOperation(false)
                operatorDivision.selecOperation(false)
                break
            case .miltiplication:
                operatorAdittion.selecOperation(false)
                operatorSubstraction.selecOperation(false)
                operatorMultiplication.selecOperation(true)
                operatorDivision.selecOperation(false)
                break
            case .division:
                operatorAdittion.selecOperation(false)
                operatorSubstraction.selecOperation(false)
                operatorMultiplication.selecOperation(false)
                operatorDivision.selecOperation(true)
                break
         
            }
        }
    }
    
}
