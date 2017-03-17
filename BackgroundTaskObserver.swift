//
//  BackgroundTaskObserver.swift
//  Trygve
//
//  Created by Nan Wang on 2016-11-24.
//  Copyright © 2016 Trygve. All rights reserved.
//

import UIKit
/**
 `BackgroundObserver` is an `OperationObserver` that will automatically begin
 and end a background task if the application transitions to the background.
 This would be useful if you had a vital `Operation` whose execution *must* complete,
 regardless of the activation state of the app. Some kinds network connections
 may fall in to this category, for example.
 */
final class BackgroundTaskObserver: NSObject, OperationObserver {

    /// properties
    private var identifier = UIBackgroundTaskInvalid
    private var isInBackground = false
    private let sharedApplication: UIApplication? = UIApplication.value(forKey: "sharedApplication") as? UIApplication

    /// initialization
    override init() {
        super.init()

        // We need to know when the application moves to/from the background.
        NotificationCenter.default.addObserver(self, selector: #selector(BackgroundTaskObserver.didEnterBackground(_:)), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BackgroundTaskObserver.didEnterForeground(_:)), name: .UIApplicationDidBecomeActive, object: nil)

        // if we are in background already, immediately begin the background task
        if isInBackground {
            startBackgroundTask()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func didEnterBackground(_ notification: NSNotification) {
        if !isInBackground {
            isInBackground = true
            startBackgroundTask()
        }
    }

    func didEnterForeground(_ notification: NSNotification) {
        if isInBackground {
            isInBackground = false
            endBackgroundTask()
        }
    }

    private func startBackgroundTask() {
        if identifier == UIBackgroundTaskInvalid {
            identifier = sharedApplication!.beginBackgroundTask(withName: "BackgroundTaskObserver", expirationHandler: {
                self.endBackgroundTask()
            })
        }
    }

    private func endBackgroundTask() {
        if identifier != UIBackgroundTaskInvalid {
            sharedApplication?.endBackgroundTask(identifier)
            identifier = UIBackgroundTaskInvalid
        }
    }

    func operationDidFinish(_ operation: Operation, errors: [NSError]) {
        endBackgroundTask()
    }
    func operationDidStart(_ operation: Operation) { }
    func operationDidCancel(_ operation: Operation) { }
    func operation(_ operation: Operation, didProduceOperation newOperation: Foundation.Operation) { }
}
