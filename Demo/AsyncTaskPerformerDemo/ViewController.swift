//
//  ViewController.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let api = FakeAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("...")
        api.getObjectByID(1) { (object, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print(object!.name)
            }
        }
    }
}

