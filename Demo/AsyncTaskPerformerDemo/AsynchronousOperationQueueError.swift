//
//  AsynchronousOperationQueueError.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import Foundation

/// Async OperationQueue error.
///
/// - neverExecuted: Operations in queue were never executed.
enum AsynchronousOperationQueueError: Error {
    case neverExecuted
}
