//
//  AsyncOperationQueue.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import Foundation

/// Operation queue with convenience function for running a list of async operations.
final class AsyncOperationQueue<T>: OperationQueue {
    
    // MARK: - Types
    
    /// Async queue type.
    ///
    /// - concurrent: Queue with multiple operations running concurrently.
    /// - nonConcurrent: Queue where operaitons run one-at-a-time.
    enum QueueType {
        case concurrent(maxConcurrentOperations: Int)
        case nonConcurrent
    }
    
    // MARK: - Properties
    
    /// Initial value. Will be returned if queue executed with no operations.
    var defaultValue: T
    
    // MARK: - Init/Deinit
    
    convenience init(defaultValue: T) {
        self.init(defaultValue: defaultValue,
                  type: .nonConcurrent)
    }
    
    required init(defaultValue: T, type: QueueType) {
        self.defaultValue = defaultValue
        
        let maxConcurrentOperationCount: Int
        
        switch type {
        case .concurrent(let maxConcurrentOperations):
            maxConcurrentOperationCount = maxConcurrentOperations
        case .nonConcurrent:
            maxConcurrentOperationCount = 1
        }
        
        super.init()
        
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
    // MARK: - Instance functions
    
    /// Runs a list of async operations with single completion block.
    /// Note: If any individual operation reports an error, all subsequent
    /// operations are cancelled and function exits early.
    ///
    /// - Parameters:
    ///   - operations: List of operations to execute.
    ///   - completion: Single point of completion for all operations.
    func executeOperations(_ operations: [AsyncOperationWithCompletion<T>],
                           completion: @escaping (T?, Error?) -> Void) {
        guard !operations.isEmpty else {
            completion(defaultValue, nil)
            return
        }
        
        var finalResult: (data: T?, error: Error?) = (nil, AsynchronousOperationQueueError.neverExecuted)
        let completion: () -> Void = {
            DispatchQueue.main.async {
                completion(finalResult.data, finalResult.error)
            }
        }
        let finalOperation = BlockOperation(block: completion)
        
        for operation in operations {
            operation.completion = { (data, error) in
                if let error = error {
                    finalResult = (nil, error)
                    self.cancelAllOperations()
                    completion()
                } else {
                    finalResult = (data, nil)
                }
            }
            
            finalOperation.addDependency(operation)
            self.addOperation(operation)
        }
        
        self.addOperation(finalOperation)
    }
    
}
