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
import MAGCoreData

class MAGCoreDataTests: XCTestCase {

    let testString = "MAGCoreDataTestString"
    let testInt = 42239
    let testBool = true
    let testDouble = 3230423.5
    let testDate = NSDate(timeIntervalSinceNow: 6000)
    
    override func setUp() {
        super.setUp()
        
        var error: NSError?
        MAGCoreData.prepareCoreData()
        if let error = error {
            println("MAGCoreDataTestCase \(error)")
        } else {
//            println("MAGCoreData was prepared.")
        }
    }
    
    override func tearDown() {
        var error: NSError?
        MAGCoreData.deleteAll(error: &error)
        MAGCoreData.save(error: &error)
        if let error = error {
            println("MAGCoreDataTestCase \(error)")
        } else {
//            println("MAGCoreData was closed.")
        }
        
        super.tearDown()
    }
    
    func testThatMAGCoreDataIsSingletone() {
        XCTAssertEqual(MAGCoreData.instance, MAGCoreData.instance)
    }
    
    func testThatMAGCoreDataPreparedCorrectly() {
        MAGCoreData.close()
        
        var error: NSError?
        XCTAssertTrue(MAGCoreData.prepareCoreData(error: &error))
        XCTAssertNil(error, "Preparing error.")
    }
    
    func testThatMainAndPrivateContextsAreDifferent() {
        XCTAssertNotEqual(MAGCoreData.context, MAGCoreData.createPrivateContext())
    }
        
    func testThatMAGCoreDataSavesAndReturnsData() {
        var testInstance = TestModel.create() as! TestModel
        let testId = NSUUID().UUIDString
        testInstance.entityId = testId

        var error: NSError?
        MAGCoreData.save(error: &error)
        XCTAssertNil(error, "Saving error.")
        
        error = nil
        let returnedTestInstance = TestModel.firstWithKey("entityId", value: testId, error: &error) as? TestModel
        if returnedTestInstance == nil || error != nil {
            XCTFail("Test instance wasn't saved or returned.")
        }
    }
    
    func testThatDateUpdatedAttributeNameSetsAndGets() {
        let dateUpdatedAttributeName = "dateUpdated"
        TestModel.updateDateKeyName = dateUpdatedAttributeName
        if let testModeldateUpdatedAttributeName = TestModel.updateDateKeyName {
            XCTAssertEqual(dateUpdatedAttributeName, testModeldateUpdatedAttributeName, "Saving/getting error.")
        } else {
            XCTFail("Saving/getting error. TestModel's updateDateKeyName: \(TestModel.updateDateKeyName).")
        }
    }
    
    func testThatAttributesSetFromCollections() {
        var testInstance = TestModel.create() as! TestModel
        let testId = NSUUID().UUIDString
        let testAttributes: [String: AnyObject] = ["entityId": testId, "string": testString, "doubleValue": testDouble]
        testInstance.safeSetValuesForKeysWithDictionary(testAttributes)
        XCTAssertEqual(testInstance.entityId, testId, "Attributes setting error.")
        
        if let testInstanceString = testInstance.string {
            XCTAssertEqual(testInstanceString, testString, "Attributes setting error.")
        } else {
            XCTFail("Attributes setting error.")
        }
        
        if let testInstanceDoubleValueNumber = testInstance.doubleValue {
            XCTAssertEqual(testInstanceDoubleValueNumber.doubleValue, testDouble, "Attributes setting error.")
        } else {
            XCTFail("Attributes setting error.")
        }
    }
    
    func testThatAllModelInstancesReturn() {
        var testInstance = TestModel.create() as! TestModel
        let testId = NSUUID().UUIDString
        testInstance.entityId = testId
        
        MAGCoreData.save()

        var error: NSError?
        if let firstTestInstance = TestModel.all(error: &error).first as? TestModel {
            XCTAssertEqual(firstTestInstance.entityId, testId, "Setted and getted entityId's are different.")
        } else {
            XCTFail("Saving/getting error.")
        }
    }
}
