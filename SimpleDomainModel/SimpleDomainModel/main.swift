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

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Double
    public var currency : currencyType
    
    public enum currencyType {
        case USD
        case GBP
        case EUR
        case CAN
    }
    
    init(amount: Double, currency: currencyType) {
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ to: currencyType) -> Money {
        let convertTo = to
        
        if currency == convertTo {
            return Money(amount: amount, currency: currency)
        }
        
        var converted = amount
        switch currency {
        case .GBP:
            converted *= 2
        case .EUR:
            converted *= (2/3)
        case .CAN:
            converted *= (1/1.25)
        default:
            break
        }
        
        switch convertTo {
        case .GBP:
            converted *= 0.5
        case .EUR:
            converted *= 1.5
        case .CAN:
            converted *= 1.25
        default:
            return Money(amount: converted, currency: .USD)
        }
        
        return Money(amount: converted, currency: convertTo)
    }
    
    // returns money based on to's currency
    public func add(_ to: Money) -> Money {
        if to.currency == currency {
            return Money(amount: amount + to.amount, currency: to.currency)
        } else {
            return Money(amount: to.amount + convert(to.currency).amount, currency: to.currency)
        }
    }
    
    // returns money based on from's currency
    public func subtract(_ from: Money) -> Money {
        if from.currency == currency {
            return Money(amount: amount - from.amount, currency: currency)
        } else {
            return Money(amount: from.amount - convert(from.currency).amount, currency: from.currency)
        }
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let hourlyIncome):
            return Int(Double(hours) * hourlyIncome)
        case .Salary(let salaryIncome):
            return salaryIncome
        }
    }
    
     func raise(_ amt : Double) {
        switch type {
        case .Salary(let salaryIncome):
            self.type = Job.JobType.Salary(Int(Double(salaryIncome) + amt))
        case .Hourly(let hourlyIncome):
            self.type = Job.JobType.Hourly(hourlyIncome + amt)
        }
    }
}


////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            if age < 16 {
                return nil
            } else {
                return _job
            }
        }
        set(value) {
            _job = value
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            if age < 21 {
                return nil
            } else {
                return _spouse
            }
        }
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
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    fileprivate var legal : Bool
    
    public init(spouse1: Person, spouse2: Person) {
        members.append(spouse1)
        members.append(spouse2)
        spouse1._spouse = spouse2
        spouse2._spouse = spouse1
        if spouse1.age < 21 && spouse2.age < 21 {
            legal = false
        } else {
            legal = true
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        // set child's age to 0???
        members.append(child)
        return true
    }
    
    open func householdIncome() -> Int {
        var total = 0
        for member in members {
            if member._job != nil {
                switch member._job!.type {
                case .Hourly(_):
                    total += (member.job?.calculateIncome(2000))!
                case .Salary(let salaryIncome):
                    total += salaryIncome
                }
            }
        }
        return total
    }
}


