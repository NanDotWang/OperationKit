//
// Example from:
// http://lorenzoboaro.io/2016/01/05/having-fun-with-operation-in-ios.html

/*Apple documentation encourages the usage of non-asynchronous operations in combination with an NSOperationQueue. 
 This way is simpler than the asynchronous one since you don’t need to do the dirty work yourself. 
 A possible problem that can arise is that if you override the main method and you start an async task within it, 
 that task will not be completed. As soon the main method reaches the end, the operation is removed from its queue.
 So, for example, if you want to take advantage of NSURLSession API within an operation, 
 you need to rely on an asynchronous operation.*/

import Foundation

public class ExampleAsyncOperation: Foundation.Operation {

    override public var isAsynchronous: Bool {
        return true
    }

    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }

    override public var isExecuting: Bool {
        return _executing
    }

    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }

    override public var isFinished: Bool {
        return _finished
    }

    override public func start() {
        _executing = true
        execute()
    }

    func execute() {
        // Execute your async task here
    }

    func finish() {
        // Notify the completion of async task and hence the completion of the operation
        _executing = false
        _finished = true
    }
}
