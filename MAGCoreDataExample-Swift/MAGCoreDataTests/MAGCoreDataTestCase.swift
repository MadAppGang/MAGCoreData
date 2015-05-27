//
//  MAGCoreDataTestCase.swift
//  MAGCoreData
//
//  Created by Dmytro Lisitsyn on 27.05.15.
//  Copyright (c) 2015 Dmytro Lisitsyn. All rights reserved.
//

import UIKit
import XCTest

class MAGCoreDataTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        
        var error: NSError?
        MAGCoreData.prepareCoreDataWithModelName("TestModel", storageName: "TestStorage", error: &error)
        if let error = error {
            println("MAGCoreDataTestCase \(error)")
        }
    }
    
    override func tearDown() {
        var error: NSError?
        MAGCoreData.deleteAll(&error)
        if let error = error {
            println("MAGCoreDataTestCase \(error)")
        }
        
        super.tearDown()
    }    
}
