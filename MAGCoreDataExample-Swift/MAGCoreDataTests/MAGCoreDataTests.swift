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
        var person = PersonModel.create() as! PersonModel
        let entityId = NSUUID().UUIDString
        person.entityId = entityId

        var error: NSError?
        MAGCoreData.save(error: &error)
        XCTAssertNil(error, "Saving error.")
        
        error = nil
        let returnedPerson = PersonModel.firstWithKey("entityId", value: entityId, error: &error) as? PersonModel
        if returnedPerson == nil || error != nil {
            XCTFail("Test instance wasn't saved or returned.")
        }
    }
    
    func testThatDateUpdatedAttributeNameSetsAndGets() {
        let dateUpdatedAttributeName = "dateUpdated"
        PersonModel.updateDateKeyName = dateUpdatedAttributeName
        if let testModeldateUpdatedAttributeName = PersonModel.updateDateKeyName {
            XCTAssertEqual(dateUpdatedAttributeName, testModeldateUpdatedAttributeName, "Saving/getting error.")
        } else {
            XCTFail("Saving/getting error. TestModel's updateDateKeyName: \(PersonModel.updateDateKeyName).")
        }
    }
    
    func testThatAttributesSetFromCollections() {
        var person = PersonModel.create() as! PersonModel
        let entityId = NSUUID().UUIDString
        let name = "Dave"
        let age = 10
        let attributes: [String: AnyObject] = ["entityId": entityId, "name": name, "age": age]
        person.safeSetValuesForKeysWithDictionary(attributes)
        
        
        XCTAssertEqual(person.entityId, entityId, "Attributes setting error.")
        XCTAssertEqual(person.name, name, "Attributes setting error.")
        XCTAssertEqual(person.name, name, "Attributes setting error.")

        if let ageNumber = person.age {
            XCTAssertEqual(ageNumber.integerValue, age, "Attributes setting error.")
        } else {
            XCTFail("Attributes setting error.")
        }
    }    
}
