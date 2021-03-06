//
//  SynchronousDispatchGroup.swift
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

/// Executes a set of asynchrnous tasks with single completion point.
/// Utilizes DispatchGroup.
public final class SynchronousDispatchGroup {
    
    // MARK - Properties
    
    /// System queue used to execute tasks.
    public let systemQueue: DispatchQueue
    
    // MARK: - Init/Deinit
    
    /// Creates new instance.
    ///
    /// Defaults to using `main` queue.s
    public convenience init() {
        self.init(systemQueue: .main)
    }
    
    /// Cretes new instance.
    ///
    /// - Parameter systemQueue: Syscm queue used to execute tasks.
    public init(systemQueue: DispatchQueue) {
        self.systemQueue = systemQueue
    }
    
    // MARK: - Protocol conformance
    
    // MARK: AsyncTaskSynchronizer
    
    public func executeTasks(_ tasks: [AsyncTask],
                           completion: @escaping () -> ()) {
        let taskGroup = DispatchGroup()
        
        for task in tasks {
            taskGroup.enter()
            
            task.execute {
                taskGroup.leave()
            }
        }
        
        taskGroup.notify(queue: systemQueue,
                         work: DispatchWorkItem(block: {
                            completion()
                         }
        ))
    }
    
}
