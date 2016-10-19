//
//  PersonTests.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import XCTest

class PersonTests: XCTestCase {
    
    func testPerson() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        NSLog("TESTOUTPUT" + ted.toString())
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
    }
    
    func testAgeRestrictions() {
        let matt = Person(firstName: "Matthew", lastName: "Neward", age: 15)
        
        matt.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(matt.job == nil)
        
        matt.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(matt.spouse == nil)
    }
    
    func testAdultAgeRestrictions() {
        let mike = Person(firstName: "Michael", lastName: "Neward", age: 22)
        
        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(mike.job != nil)
        
        mike.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(mike.spouse != nil)
    }
    
    func testDescriptionPerson(){
        let mike = Person(firstName: "Michael", lastName: "Neward", age: 22)
        let matt = Person(firstName: "Matthew", lastName: "Neward", age: 15)
        
        XCTAssert(mike.description == "Michael Neward")
        XCTAssert(matt.description == "Matthew Neward")
        
    }
    
}

class FamilyTests : XCTestCase {
    
    func testFamily() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))
        
        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)
        
        let family = Family(spouse1: ted, spouse2: charlotte)
        
        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 1000)
        
        let familyDescription = family.description
        XCTAssert(familyDescription == "Ted Neward, Charlotte Neward")
    }
    
    func testFamilyWithKids() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))
        
        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)
        
        let family = Family(spouse1: ted, spouse2: charlotte)
        
        let mike = Person(firstName: "Mike", lastName: "Neward", age: 22)
        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        
        let matt = Person(firstName: "Matt", lastName: "Neward", age: 16)
        let _ = family.haveChild(mike)
        let _ = family.haveChild(matt)
        
        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 12000)
        
        let familyDescription = family.description
        XCTAssert(familyDescription == "Ted Neward, Charlotte Neward, Mike Neward, Matt Neward")
    }
    
}
