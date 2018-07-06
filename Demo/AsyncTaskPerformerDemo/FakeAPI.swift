//
//  FakeAPI.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import Foundation

struct FakeObject {
    
    let id: Int
    let name: String
    
}

enum FakeAPIError: Error {
    case invalidID
}

final class FakeAPI {
    
    private let timer = Timer()
    private let fakeObjects = [
        FakeObject(id: 1, name: "A"),
        FakeObject(id: 2, name: "B"),
        FakeObject(id: 3, name: "C")
    ]
    private var finalObject = FakeObject(id: 0, name: "")
    
    func getObjectByID(_ id: Int, completion: @escaping (FakeObject?, Error?) -> Void) {
        var error: Error? = nil
        
        if !((fakeObjects.map { $0.id }).contains(id)) {
            error = FakeAPIError.invalidID
        }
        
        timer.executeAfter(seconds: 5) { [weak self] in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let object = self!.fakeObjects[id - 1]
            self?.finalObject = FakeObject(id: self!.finalObject.id + id,
                                           name: self!.finalObject.name + object.name)
            completion(self!.finalObject, nil)
        }
    }
    
}
