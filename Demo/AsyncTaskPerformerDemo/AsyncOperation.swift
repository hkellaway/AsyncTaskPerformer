//
//  AsyncOperation.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import Foundation

/// Operation base class representing an async operation.
class AsyncOperation: Operation {
    
    // MARK: - Properties
    
    // MARK: Private properties
    
    private var _isExecuting: Bool = false
    private var _isFinished: Bool = false
    
    // MARK: - Overrides
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        set {
            if _isExecuting != newValue {
                willChangeValue(forKey: "isExecuting")
                _isExecuting = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
        
        get {
            return _isExecuting
        }
    }
    
    override var isFinished: Bool {
        set {
            if _isFinished != newValue {
                willChangeValue(forKey: "isFinished")
                _isFinished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
        
        get {
            return _isFinished
        }
    }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        isExecuting = true
        isFinished = false
        main()
    }
    
    // MARK: - Instance functions
    
    /// Updates state after operation is finished.
    func finish() {
        isExecuting = false
        isFinished = true
    }
    
}
