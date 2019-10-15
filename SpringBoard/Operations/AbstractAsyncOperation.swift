//
//  AbstractAsyncOperation.swift
//  SpringBoard
//
//  Created by Alexandr Regino on 10/15/19.
//  Copyright © 2019 Alexandr Regino. All rights reserved.
//

import UIKit

class AbstractAsyncOperation: Operation {
    
    public enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
}

extension AbstractAsyncOperation {
    
    open override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    open override var isExecuting: Bool {
        return state == .executing
    }
    
    open override var isFinished: Bool {
        return state == .finished
    }
    
    open override var isAsynchronous: Bool {
        return true
    }
    
    open override func start() {
        if isCancelled {
            state = .finished
            return
        }
        
        main()
        state = .executing
    }
    
    open override func cancel() {
        super.cancel()
        state = .finished
    }
    
}
