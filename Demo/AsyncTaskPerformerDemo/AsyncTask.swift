//
//  AsyncTask.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import Foundation

/// Represents a task whose execution is asynchronous, such as an API call.
protocol AsyncTask {
    
    /// Executes asynchronous task.
    ///
    /// - Parameter completion: Completion called when task is complete.
    func execute(completion: @escaping () -> Void)
    
}
