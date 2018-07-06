//
//  AyncOperationWithCompletion.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import Foundation

/// Async operation that has a typed completion block.
class AsyncOperationWithCompletion<T>: AsyncOperation {
    
    /// Completion block with type.
    var completion: ((T?, Error?) -> Void)?
    
}
