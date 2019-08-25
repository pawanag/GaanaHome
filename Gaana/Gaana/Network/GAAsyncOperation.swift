//
//  GAAsyncOperation.swift
//  Gaana
//
//  Created by Pawan Agarwal on 25/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GAAsyncOperation : Operation{
    
    //MARK:- enum for maintaining states
    enum State: String{
        case ready, executing, finished
        var keyPath : String{
            return "is" + rawValue.capitalized
        }
    }
    
    //MARK:- variables
    var state: State = State.ready{
        willSet{
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        
        didSet{
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    //MARK:- overriden variables
    override var isReady: Bool{
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool{
        return state == .executing
    }
    
    override var isFinished: Bool{
        return state == .finished
    }
    
    override var isAsynchronous: Bool{
        return true
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
}
