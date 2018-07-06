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
        FakeObject(id: 3, name: "C"),
        FakeObject(id: 4, name: "D"),
        FakeObject(id: 5, name: "E"),
        FakeObject(id: 6, name: "F"),
        FakeObject(id: 7, name: "G"),
        FakeObject(id: 8, name: "H"),
        FakeObject(id: 9, name: "I"),
        FakeObject(id: 10, name: "J"),
        FakeObject(id: 11, name: "K"),
        FakeObject(id: 12, name: "L"),
        FakeObject(id: 13, name: "M"),
        FakeObject(id: 14, name: "N"),
        FakeObject(id: 15, name: "O"),
        FakeObject(id: 16, name: "P"),
        FakeObject(id: 17, name: "Q"),
        FakeObject(id: 18, name: "R"),
        FakeObject(id: 19, name: "S"),
        FakeObject(id: 20, name: "T"),
        FakeObject(id: 21, name: "U"),
        FakeObject(id: 22, name: "V"),
        FakeObject(id: 23, name: "W"),
        FakeObject(id: 24, name: "X"),
        FakeObject(id: 25, name: "Y"),
        FakeObject(id: 26, name: "Z")
    ]
    private var finalObject = FakeObject(id: 123456, name: "")
    
    func getObjectByID(_ id: Int, completion: @escaping (FakeObject?, Error?) -> Void) {
        var error: Error? = nil
        
        if !((fakeObjects.map { $0.id }).contains(id)) {
            error = FakeAPIError.invalidID
        }
        
        timer.executeAfter(seconds: 1) { [weak self] in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let object = self!.fakeObjects[id - 1]
            self?.finalObject = FakeObject(id: self!.finalObject.id,
                                           name: self!.finalObject.name + object.name)
            completion(self!.finalObject, nil)
        }
    }
    
}
