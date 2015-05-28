//
//  MAGCoreDataTests.swift
//  MAGCoreData
//
//  Created by Dmytro Lisitsyn on 27.05.15.
//  Copyright (c) 2015 Dmytro Lisitsyn. All rights reserved.
//

import UIKit
import XCTest
import CoreData

class MAGCoreDataTests: XCTestCase {

    let testString = "MAGCoreDataTestString"
    let testInt = 42239
    let testBool = true
    let testDouble = 3230423.5
    let testDate = NSDate(timeIntervalSinceNow: 6000)
    
    override func setUp() {
        super.setUp()
        
        var error: NSError?
        MAGCoreData.prepareCoreData(&error)
        if let error = error {
            println("MAGCoreDataTestCase \(error)")
        } else {
            println("MAGCoreData was prepared.")
        }
    }
    
    override func tearDown() {
        var error: NSError?
        MAGCoreData.deleteAll(&error)
        MAGCoreData.save(&error)
        if let error = error {
            println("MAGCoreDataTestCase \(error)")
        } else {
            println("MAGCoreData was closed.")
        }
        
        super.tearDown()
    }
    
    func testThatMAGCoreDataIsSingletone() {
        XCTAssertEqual(MAGCoreData.instance, MAGCoreData.instance)
    }
    
    func testThatMAGCoreDataPreparedCorrectly() {
        MAGCoreData.close()
        
        var error: NSError?
        XCTAssertTrue(MAGCoreData.prepareCoreData(&error))
        XCTAssertNil(error, "Should be nil.")
    }
    
    func testThatMainAndPrivateContextsAreDifferent() {
        XCTAssertNotEqual(MAGCoreData.context, MAGCoreData.createPrivateContext())
    }
    
    func testThatMAGCoreDataSavesData() {
        var testInstance = TestModel.create() as TestModel
        testInstance.entityId = NSUUID().UUIDString
        testInstance.string = testString
        testInstance.doubleValue = testDouble
        testInstance.date = testDate

        var error: NSError?
        MAGCoreData.save(&error)
        XCTAssertNil(error)
        
        println(TestModel.firstForAttribute("string", attributeValue: testString, error: &error) as? TestModel)
        
        error = nil
        if let savedTestInstance = TestModel.firstForAttribute("string", attributeValue: testString, error: &error) {
            println("oudnierubfiuerbgiuegoiwu")
        } else {
            XCTFail("Test instance wasn't saved.")
        }
    }
}
