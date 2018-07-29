//
//  ViewController.swift
//  Calculadora
//
//  Created by SAMUEL on 19/8/17.
//  Copyright © 2017 SAMUEL VASILOVSKI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping: Bool = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display!.text!
            display!.text = textCurrentlyInDisplay + digit
        }
        else{
            display!.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain();
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping=false
        }
        if let mathemaicalSymbol = sender.currentTitle{
            brain.performOperation(mathemaicalSymbol)
        }
        if let result = brain.result {
            displayValue=result
        }
    }
    
    @IBAction func clear(_ sender: UIButton){
        displayValue=0
        brain = CalculatorBrain();
    }
}
