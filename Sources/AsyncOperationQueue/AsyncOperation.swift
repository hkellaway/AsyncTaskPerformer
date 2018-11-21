//
//  AsyncOperation.swift
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
