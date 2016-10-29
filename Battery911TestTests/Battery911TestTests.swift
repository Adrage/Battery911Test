//
//  Battery911TestTests.swift
//  Battery911TestTests
//
//  Created by Adrian C. Johnson on 10/27/16.
//  Copyright © 2016 Cross Vision Development Studios. All rights reserved.
//

import XCTest
@testable import Battery911Test

class Battery911TestTests: XCTestCase {
    
    var testResultNew: TestResult?
    var testResultDelete: TestResult?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext) in
            if let testResultsArray = TestResult.MR_findAll() as? [TestResult] {
                for testResult in testResultsArray {
                    testResult.MR_deleteEntityInContext(localContext)
                }
            }
        }
        
        // Record created
        testResultNew = TestResult.MR_createEntity()
        testResultNew!.patientName = "John Doe"
        testResultNew!.age = 15
        testResultNew!.hasMigraines = false
        testResultNew!.usedHallucinogenicDrugs = true
        
        // Record deleted
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext) in
            self.testResultDelete = TestResult.MR_createEntityInContext(localContext)
            self.testResultDelete!.patientName = "Delete Person"
            self.testResultDelete!.gender = "Female"
            self.testResultDelete!.age = 22
            self.testResultDelete!.hasMigraines = false
            self.testResultDelete!.usedHallucinogenicDrugs = false
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNewTestResult() {
        XCTAssertEqual(testResultNew!.patientName!, "John Doe")
        XCTAssertEqual(testResultNew!.age!, 15)
        XCTAssertEqual(testResultNew!.hasMigraines!, false)
        XCTAssertEqual(testResultNew!.usedHallucinogenicDrugs!, true)
        XCTAssertNil(testResultNew?.gender)
        XCTAssertNotNil(testResultNew?.patientName)
        XCTAssertNotEqual(testResultNew!.patientName!, "Jane Doe")
        XCTAssertEqual(testResultNew!.dictionaryRepresentation()["patientName"] as? String, "John Doe")
        XCTAssertEqual(testResultNew!.score(), "50%")
    }
    
    func testCoreDataTestResult() {
        let expectation = expectationWithDescription("Create Test Result")
        
        TestResult.createTestResultWithPatientName("James Petterson", hasMigraines: true, age: 20, gender: "Male", usedHallucinogenicDrugs: false, completion: {
            let testResults = TestResult.MR_findAll() as! [TestResult]
            let thisTestResult = testResults.filter({$0.patientName == "James Petterson"}).first
            XCTAssertEqual(thisTestResult?.patientName, "James Petterson")
            XCTAssertEqual(TestResult.MR_findAll()!.count, 3)
            expectation.fulfill()
        }) { (error) in
            XCTFail("Unexpected response")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error: NSError?) in
            if let _error = error {
                XCTFail("Error: \(_error.localizedDescription)")
            }
        }
    }
    
    func testCoreDataTestResultDelete() {
        let expectation = expectationWithDescription("Delete Test Result")
        
        TestResult.deleteTestResult(testResultDelete!, completion: {
            let testResults = TestResult.MR_findAll() as! [TestResult]
            let thisTestResult = testResults.filter({$0.patientName == "Delete Person"}).first
            XCTAssertNil(thisTestResult)
            
            expectation.fulfill()
        }) { (error) in
            XCTFail("Unexpected response")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error: NSError?) in
            if let _error = error {
                XCTFail("Error: \(_error.localizedDescription)")
            }
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
