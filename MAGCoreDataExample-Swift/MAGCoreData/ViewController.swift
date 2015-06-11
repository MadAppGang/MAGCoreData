//
//  ViewController.swift
//  MAGCoreData
//
//  Created by Dmytro Lisitsyn on 25.05.15.
//  Copyright (c) 2015 Dmytro Lisitsyn. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var error: NSError?
//        MAGCoreData.prepareCoreData(error: &error)
//        if let error = error {
//            println("MAGCoreDataTestCase \(error)")
//        } else {
//            //            println("MAGCoreData was prepared.")
//        }
//        
//        var testInstance = TestModel.create() as TestModel
//        let testId = NSUUID().UUIDString
//        testInstance.entityId = testId
//        
//        MAGCoreData.save()
//        
////        println("WVUYWEYE \(TestModel.all(error: &error) as? [TestModel])")
//        
//        error = nil
//        MAGCoreData.deleteAll(error: &error)
//        MAGCoreData.save(error: &error)
//        if let error = error {
//            println("MAGCoreDataTestCase \(error)")
//        } else {
//            //            println("MAGCoreData was closed.")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

