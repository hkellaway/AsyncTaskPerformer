//
//  Timer.swift
//  AsyncTaskPerformerDemo
//
//  Created by Harlan Kellaway on 7/6/18.
//  Copyright © 2018 Harlan Kellaway. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    /// Converts time interval to milliseconds.
    ///
    /// - Returns: Milliseconds in time interval.
    func toMilliseconds() -> DispatchTimeInterval {
        return DispatchTimeInterval.milliseconds(Int(1000.0 * self))
    }
    
}

/// Timer using DispatchQueue.
struct Timer {
    
    // MARK: - Protocol conformance
    
    // MARK: Timer
    
    func executeAfter(seconds: TimeInterval, action: @escaping () -> Void) {
        let nowInMilliseconds = DispatchTime.now()
        let deadline = nowInMilliseconds + seconds.toMilliseconds()
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            action()
        }
    }
    
}
