//
//  ViewController.swift
//  MAGCoreData
//
//  Created by Dmytro Lisitsyn on 25.05.15.
//  Copyright (c) 2015 Dmytro Lisitsyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error: NSError?
        MAGCoreData.prepareCoreData(&error)
        if let error = error {
            println("MAGCoreDataTestCase \(error)")
        } else {
            println("MAGCoreData was prepared.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

