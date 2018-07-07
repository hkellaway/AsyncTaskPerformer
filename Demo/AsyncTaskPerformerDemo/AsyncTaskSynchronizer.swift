//
//  AsyncTaskSynchronizer.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import Foundation

/// Executes a set of asynchrnous tasks with single completion point.
final class AsyncTaskSynchronizer {
    
    // MARK: Init/Deinit
    
    /// Creates new instance.
    public init() { }
    
    // MARK: - Protocol conformance
    
    // MARK: AsyncTaskSynchronizer
    
    func executeTasks(_ tasks: [AsyncTask],
                           completion: @escaping () -> ()) {
        let taskGroup = DispatchGroup()
        
        for task in tasks {
            taskGroup.enter()
            
            task.execute {
                taskGroup.leave()
            }
        }
        
        taskGroup.notify(queue: DispatchQueue.main,
                         work: DispatchWorkItem(block: {
                            completion()
                         }
        ))
    }
    
}
