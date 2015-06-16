//
//  MAGCoreDataExampleTests.swift
//  MAGCoreDataExampleTests
//
//  Created by Dmytro Lisitsyn on 16.06.15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit
import XCTest
import CoreData

class MAGCoreDataExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        var error: NSError?
        MAGCoreData.prepareCoreDataWithModelName("Model", storageName: "TestStorage")
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
            XCTFail("Saving/getting error. PersonModel's updateDateKeyName: \(PersonModel.updateDateKeyName).")
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
        
        if let ageNumber = person.age {
            XCTAssertEqual(ageNumber.integerValue, age, "Attributes setting error.")
        } else {
            XCTFail("Attributes setting error.")
        }
    }
    
    func testThatManagedObjectCreatesFromDictionary() {
        let entityId = NSUUID().UUIDString
        let name = "Dave"
        let age = 10
        let attributes: [String: AnyObject] = ["entityId": entityId, "name": name, "age": age]
        var person = PersonModel.createFromDictionary(attributes) as! PersonModel
        
        XCTAssertEqual(person.entityId, entityId, "Attributes setting error.")
        XCTAssertEqual(person.name, name, "Attributes setting error.")
        
        if let ageNumber = person.age {
            XCTAssertEqual(ageNumber.integerValue, age, "Attributes setting error.")
        } else {
            XCTFail("Attributes setting error.")
        }
    }
    
    func testThatMAGCoreDataReturnsAllManagedObjects() {
        let numberOfObjects = 10
        for _ in 1...numberOfObjects {
            PersonModel.create() as! PersonModel
        }
        
        XCTAssertEqual(PersonModel.all().count, numberOfObjects, "Atrributes getting error.")
    }
    
    func testThatRelationsCreateProperlyWhenObjectCreatesFromDictionary() {
        PersonModel.relationClasses = ["cars": CarModel.self]
        
        let personEntityId = NSUUID().UUIDString
        let firstCarEntityId = NSUUID().UUIDString
        let seconfCarEntityId = NSUUID().UUIDString
        
        let firstCar = CarModel.createFromDictionary(["entityId": firstCarEntityId])
        let secondCar = CarModel.createFromDictionary(["entityId": seconfCarEntityId])
        
        let attributes: [String: AnyObject] = ["entityId": personEntityId, "cars": [["entityId": firstCarEntityId], ["entityId": seconfCarEntityId]]]
        
        var person = PersonModel.createFromDictionary(attributes) as! PersonModel
//        person.addCars([firstCar, secondCar])
        
        MAGCoreData.save()
        
        var error: NSError?
        if let returnedPerson = PersonModel.firstWithKey("entityId", value: personEntityId, error: &error) as? PersonModel {
            XCTAssertTrue(returnedPerson.cars.count == 2, "Relations creation error.")
            println(returnedPerson.cars.allObjects)
            XCTAssertTrue((contains(returnedPerson.cars.allObjects as! [NSManagedObject], firstCar)), "Relations creation error.")
            XCTAssertTrue((contains(returnedPerson.cars.allObjects as! [NSManagedObject], secondCar)), "Relations creation error.")
        } else {
            XCTFail("Saving/getting error. Error: \(error)")
        }
    }
}
