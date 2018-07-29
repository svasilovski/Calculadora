//
//  CalculatorBrain.swift
//  Calculadora
//
//  Created by SAMUEL on 9/9/17.
//  Copyright © 2017 SAMUEL VASILOVSKI. All rights reserved.
//

import Foundation

func factorial(_ op: Double) -> Double{
    if op == 1 {
        return op
    }
    return op*factorial(op-1)
}

struct CalculatorBrain{
    private var accumulator: Double?
    
    private enum Operation{
        case consant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case random
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "x⁻¹": Operation.unaryOperation({ 1 / $0 }),
        "x!": Operation.unaryOperation(factorial),
        "nCr": Operation.binaryOperation({ factorial($0)/(factorial($1)*factorial(($0-$1))) }),
        "nPr": Operation.binaryOperation({ factorial($0)/factorial($0-$1) }),
        "Pol(":Operation.binaryOperation({ sqrt((pow($0,2)+pow($1,2))) }),
        "Rec(":Operation.binaryOperation({ $0*cos($1)}), // x=r*cos(ang) y=r*sin(ang)
        "∛": Operation.unaryOperation({ pow($0,(1/3)) }),
        "x³": Operation.unaryOperation({ pow($0,3) }),
        "√": Operation.unaryOperation(sqrt),
        "x²": Operation.unaryOperation({ pow($0,2) }),
        "ˣ√": Operation.binaryOperation({ pow($0,(1/$1)) }),
        "∧": Operation.binaryOperation({ pow($0,$1) }),
        "±": Operation.unaryOperation({ -$0 }),
        "℮ˣ": Operation.unaryOperation({ pow(M_E, $0) }),
        "ln": Operation.consant(M_LOG2E),
        "10ˣ": Operation.unaryOperation({ pow(10, $0) }),
        "log": Operation.consant(M_LOG10E),
        "EXP": Operation.binaryOperation({ $0 * pow(10,$1) }),
        "sin⁻¹": Operation.unaryOperation(asin),
        "sin": Operation.unaryOperation(sin),
        "cos⁻¹": Operation.unaryOperation(acos),
        "cos": Operation.unaryOperation(cos),
        "tan⁻¹": Operation.unaryOperation(atan),
        "tan": Operation.unaryOperation(tan),
        "Ran#": Operation.random, // numero random
        "π": Operation.consant(Double.pi),
        "e": Operation.consant(M_E),
        "%": Operation.binaryOperation({ ($0 * $1) / 100 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "=": Operation.equals,
    ]
    
    mutating func performOperation(_ symbol:String) {
        if let operation = operations[symbol] {
            switch operation {
            case .consant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .random:
                arc4random()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand:Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }

    mutating func setOperand(_ operand: Double) {
        accumulator = operand;
    }
    
    var result: Double? {
        get{
            return accumulator
        }
    }
}
