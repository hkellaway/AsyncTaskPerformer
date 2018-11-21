//
//  AsyncOperationQueue.swift
//  AsyncTaskPerformer
//
// Copyright (c) 2018 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

/// Operation queue with convenience function for running a list of async operations.
public final class AsyncOperationQueue<T>: OperationQueue {
    
    // MARK: - Types
    
    /// Async queue type.
    ///
    /// - concurrent: Queue with multiple operations running concurrently.
    /// - nonConcurrent: Queue where operaitons run one-at-a-time.
    public enum QueueType {
        case concurrent(maxConcurrentOperations: Int)
        case nonConcurrent
    }
    
    // MARK: - Properties
    
    /// Initial value. Will be returned if queue executed with no operations.
   public var defaultValue: T
    
    // MARK: - Init/Deinit
    
    public convenience init(defaultValue: T) {
        self.init(defaultValue: defaultValue,
                  type: .nonConcurrent)
    }
    
    public required init(defaultValue: T, type: QueueType) {
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
    public func executeOperations(_ operations: [AsyncOperationWithCompletion<T>],
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
