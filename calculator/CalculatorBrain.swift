//
//  CalculatorBrain.swift
//  calculator
//
//  Created by test on 15/5/27.
//  Copyright (c) 2015年 test. All rights reserved.
//

import Foundation

class calculatorBrain {
    
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String ,(Double, Double) -> Double)
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["×"]=Op.BinaryOperation("×",*)
        knownOps["÷"]=Op.BinaryOperation("÷") {$1 / $0 }
        knownOps["+"]=Op.BinaryOperation("+",+)
        knownOps["−"]=Op.BinaryOperation("−") {$1 - $0 }
        knownOps["√"]=Op.UnaryOperation("√") { sqrt($0)}
    }
    
    private func evaluate(ops:[Op]) -> (result: Double?, remainingOps:[Op]){
        if !ops.isEmpty {
            //赋值小技巧
            var remainingOps=ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperation(_,let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand),operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_,let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) ->Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(sysbol: String) -> Double?{
        if let operation = knownOps[sysbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
}