//
//  ViewController.swift
//  MAGCoreDataSwiftExample
//
//  Created by Alexander Malovichko on 6/5/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init core data
        var coreData = MAGCoreData()
        var error2:NSError
        coreData.prepareCoreData()
    }

}

