//
//  ViewController.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import AsyncTaskPerformer
import UIKit

class ViewController: UIViewController {
    
    let api = FakeAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let objectIDs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26]
        dispatchGroupExample(objectIDs: objectIDs)
    }
    
    func dispatchGroupExample(objectIDs: [Int]) {
        let tasks = objectIDs.map { GetObjectByIDTask(id: $0, api: api) }
        let synchronousDispatchGroup = SynchronousDispatchGroup()
        
        synchronousDispatchGroup.executeTasks(tasks) {
            let finalObject = tasks.last!.result
            if finalObject == nil {
                print("ERROR")
            } else {
                print("FINAL OBJECT: " + finalObject!.name)
            }
        }
    }
    
    func operationQueueExample(objectIDs: [Int]) {
        let operations = objectIDs.map { GetObjectByIDOperation(id: $0, api: api) }
        let nullObject = FakeObject(id: -1, name: "NULL")
        let synchronousOperationQueue = SynchronousOperationQueue(defaultValue: nullObject)
        
        synchronousOperationQueue.executeOperations(operations) { (finalObject, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("FINAL OBJECT: " + finalObject!.name)
            }
        }
    }
    
}

