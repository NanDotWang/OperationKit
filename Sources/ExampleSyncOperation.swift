//
// Example from:
// http://lorenzoboaro.io/2016/01/05/having-fun-with-operation-in-ios.html

import Foundation

public class ExampleSyncOperation: Foundation.Operation {

    override public func main() {

        if isCancelled {
            return
        }

        // Execute your long task here. The task will execute in background task for you
        // As a suggestion, check the cancelled property
        // in order to rollback an invalid state introduced by the operation
    }
}
