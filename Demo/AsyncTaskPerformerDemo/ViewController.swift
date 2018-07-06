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
        
        let objectIDs = [1, 2, 3]
        let operations = objectIDs.map { GetObjectByIDOperation(id: $0, api: api) }
        let nullObject = FakeObject(id: -1, name: "NULL")
        let asyncOperationQueue = AsyncOperationQueue(defaultValue: nullObject)
        
        asyncOperationQueue.executeOperations(operations) { [weak self] (finalObject, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print(finalObject!.id)
                print(finalObject!.name)
            }
        }
    }
}

