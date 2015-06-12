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
        
        MAGCoreData.prepareCoreData()
        
//        TestModel.create() as! TestModel
//        TestModel.create() as! TestModel
//        TestModel.create() as! TestModel
//        TestModel.create() as! TestModel
//        TestModel.create() as! TestModel
//
//        
//        MAGCoreData.save()
        
        println("Models: \(TestModel.all().count)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

