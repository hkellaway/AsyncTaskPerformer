//
//  GetObjectByIDTask.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import AsyncTaskPerformer
import Foundation

/// Asynchronouse task for fetching a object from the API.
final class GetObjectByIDTask: AsyncTask {
    
    // MARK: - Properties
    
    let id: Int
    let api: FakeAPI
    private(set) var result: FakeObject?
    
    init(id: Int, api: FakeAPI) {
        self.id = id
        self.api = api
        self.result = nil
    }
    
    // MARK: - Protocol conformance
    
    // MARK: AsyncTask
    
    func execute(completion: @escaping () -> ()) {
        print("Processing ID \(id)...")
        api.getObjectByID(id) { [weak self] (object, error) in
            self?.result = object
            completion()
        }
    }
    
}
