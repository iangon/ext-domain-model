//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

protocol Mathematics {
    mutating func add(amountToAdd: Int)
    mutating func subtract(amountToSub: Int)
}

extension Double {
    var USD: Money { return Money(amount: Int(self), currency: "USD") }
    var EUR: Money { return Money(amount: Int(self), currency: "EUR") }
    var GBP: Money { return Money(amount: Int(self), currency: "GBP") }
    var CAN: Money { return Money(amount: Int(self), currency: "CAN") }
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
    public var amount : Int
    public var currency : String
    
    public init (amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    public var description : String {
        get { return currency + String(self.amount) }
    }
    
    internal mutating func subtract(amountToSub: Int){
        self.amount -= amountToSub
    }
    
    internal mutating func add(amountToAdd: Int) {
        self.amount += amountToAdd
    }
    
    public func convert(_ to: String) -> Money {
        let conversion = (self.currency, to)
        var newCurrency : String
        var newAmount : Int
        
        switch conversion {
        case ("USD", "USD"), ("EUR", "EUR"), ("GBP", "GBP"), ("CAN", "CAN"):
            return self
        case ("USD", "EUR"):
            newCurrency = to
            newAmount = Int(1.5 * Double(self.amount))
        case ("USD", "GBP"):
            newCurrency = to
            newAmount = Int(0.5 * Double(self.amount))
        case ("USD", "CAN"):
            newCurrency =  to
            newAmount = Int(1.25 * Double(self.amount))
        case ("EUR", "USD"):
            newCurrency = to
            newAmount = Int(1.0/1.5 * Double(self.amount))
        case ("EUR", "GBP"):
            newCurrency = to
            newAmount = Int(0.5/1.5 * Double(self.amount))
        case ("EUR", "CAN"):
            newCurrency = to
            newAmount = Int(1.25/1.5 * Double(self.amount))
        case ("GBP", "USD"):
            newCurrency = to
            newAmount = Int(1.0/0.5 * Double(self.amount))
            
        case ("GBP", "EUR"):
            newCurrency = to
            newAmount = Int(1.5/0.5 * Double(self.amount))
            
        case ("GBP", "CAN"):
            newCurrency = to
            newAmount = Int(1.25/0.5 * Double(self.amount))
            
        case ("CAN", "USD"):
            newCurrency = to
            newAmount = Int(1.0/1.25 * Double(self.amount))
            
        case ("CAN", "EUR"):
            newCurrency = to
            newAmount = Int(1.5/1.25 * Double(self.amount))
            
        case ("CAN", "GBP"):
            newCurrency = to
            newAmount = Int(0.5/1.25 * Double(self.amount))
            
        default:
            return self
        }
        
        
        return Money(amount: newAmount, currency: newCurrency)
    }
    
    public func add(_ to: Money) -> Money {
        let thisMoneyConverted = self.convert(to.currency)
        return Money(amount: thisMoneyConverted.amount + to.amount, currency: to.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        return Money(amount: from.amount - self.amount, currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job: CustomStringConvertible {
    fileprivate var title : String
    fileprivate var type : JobType
    fileprivate var raise : Double = 0.0
    
    public var description : String {
        get { return "Title: \(title); Salary: \(self.calculateIncome(2000))"}
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let hourly):
            return Int((hourly + self.raise) * Double(hours))
        case .Salary(let salary):
            return salary + Int(self.raise)
        }
    }
    
    open func raise(_ amt : Double) {
        raise += amt
    }
}

////////////////////////////////////
// Person
//
open class Person: CustomStringConvertible {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { return _job }
        set(value) {
            _job = value
        }
    }
    
    public var description : String {
        get { return "\(firstName) \(lastName)" }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return _spouse }
        set(value) {
            _spouse = value
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self._job) spouse:\(self._spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family: CustomStringConvertible {
    fileprivate var members : [Person] = []
    
    public var description : String {
        get {
            var family = ""
            
            for (index, member) in members.enumerated() {
                family += member.description
                
                if index < members.count - 1 {
                    family += ", "
                }
            }
            return family
        }
    }
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members += [spouse1]
            members += [spouse2]
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        for member in members {
            if member.age > 21 {
                members.append(child)
                return true
            }
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var total : Int = 0
        for member in members {
            if member._job != nil {
                switch member._job!.type {
                case .Hourly( _):
                    total += member.job!.calculateIncome(2000)
                case .Salary( _):
                    total += member.job!.calculateIncome(2000)
                }
            }
        }
        return total
    }
}





