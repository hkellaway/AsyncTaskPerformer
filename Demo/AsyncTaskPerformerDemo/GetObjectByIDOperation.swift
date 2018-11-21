//
//  GetObjectByIDOperation.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import AsyncTaskPerformer
import Foundation

final class GetObjectByIDOperation: AsyncOperationWithCompletion<FakeObject> {

    let id: Int
    let api: FakeAPI
    
    init(id: Int, api: FakeAPI) {
        self.id = id
        self.api = api
    }
    
    override func main() {
        print("Processing ID \(id)...")
        api.getObjectByID(id) { [weak self] (object, error) in
            self?.completion?(object, error)
            self?.finish()
        }
    }
    
}
