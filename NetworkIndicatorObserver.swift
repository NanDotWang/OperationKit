//
//  NetworkIndicatorObserver.swift
//  Trygve
//
//  Created by Nan Wang on 2016-11-24.
//  Copyright © 2016 Trygve. All rights reserved.
//

import UIKit

/**
 An `OperationObserver` that will cause the network activity indicator to appear
 as long as the `Operation` to which it is attached is executing.
 */
struct NetworkIndicatorObserver: OperationObserver {

    /// Initialization
    init() { }

    func operationDidStart(_ operation: Operation) {
        DispatchQueue.main.async {
            // Increment the network indicator's "reference count"
            NetworkIndicatorController.shared.networkActivityDidStart()
        }
    }

    func operationDidFinish(_ operation: Operation, errors: [NSError]) {
        DispatchQueue.main.async {
            // Decrement the network indicator's "reference count".
            NetworkIndicatorController.shared.networkActivityDidEnd()
        }
    }

    func operationDidCancel(_ operation: Operation) { }
    func operation(_ operation: Operation, didProduceOperation newOperation: Foundation.Operation) { }
}

/// A singleton to manage a visual "reference count" on the network activity indicator.
final private class NetworkIndicatorController {

    /// properties
    static let shared = NetworkIndicatorController()
    private let sharedApplication: UIApplication? = UIApplication.value(forKey: "sharedApplication") as? UIApplication
    private var activityCount = 0
    private var visibilityTimer: CancellableTimer?

    /// methods
    func networkActivityDidStart() {
        assert(Thread.isMainThread, "Altering network activity indicator state can only be done on the main thread.")
        activityCount += 1
        updateIndicatorVisibility()
    }

    func networkActivityDidEnd() {
        assert(Thread.isMainThread, "Altering network activity indicator state can only be done on the main thread.")
        activityCount -= 1
        updateIndicatorVisibility()
    }

    private func updateIndicatorVisibility() {
        if activityCount > 0 {
            showIndicator()
        } else {
            /*
             To prevent the indicator from flickering on and off, we delay the
             hiding of the indicator by one second. This provides the chance
             to come in and invalidate the timer before it fires.
             */
            visibilityTimer = CancellableTimer(interval: 1.0) {
                self.hideIndicator()
            }
        }
    }

    private func showIndicator() {
        visibilityTimer?.cancel()
        visibilityTimer = nil
        sharedApplication?.isNetworkActivityIndicatorVisible = true
    }

    private func hideIndicator() {
        visibilityTimer?.cancel()
        visibilityTimer = nil
        sharedApplication?.isNetworkActivityIndicatorVisible = false
    }
}

/// Essentially a cancellable `dispatch_after`.
final fileprivate class CancellableTimer {
    /// properties 
    private var isCancelled = false

    /// initialization
    init(interval: TimeInterval, handler: @escaping (Void) -> Void) {
        let when = DispatchTime.now() + interval
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).asyncAfter(deadline: when) {
            // If we were cancelled, then finish() has already been called.
            if !self.isCancelled {
                handler()
            }
        }
    }

    func cancel() {
        isCancelled = true
    }
}
