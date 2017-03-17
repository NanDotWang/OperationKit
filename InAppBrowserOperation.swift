//
//  InAppBrowserOperation.swift
//  Trygve
//
//  Created by Nan Wang on 2016-11-24.
//  Copyright © 2016 Trygve. All rights reserved.
//

import Foundation
import SafariServices

/// An `Operation` to display an `NSURL` in an app-modal `SFSafariViewController`.
final class InAppBrowserOperation: Operation {

    /// Properties
    let url: URL
    let presentationContext: UIViewController?

    /// Initialization
    init(url: URL, presentationContext: UIViewController? = (UIApplication.value(forKey: "sharedApplication") as? UIApplication)?.keyWindow?.rootViewController) {
        self.url = url
        self.presentationContext = presentationContext

        super.init()

        addCondition(MutuallyExclusive<UIViewController>())
    }

    /// Overrides
    /// *** Must *** call finish() at some point to end this operation
    override func execute() {
        DispatchQueue.main.async {
            self.showSafariViewController()
        }
    }

    private func showSafariViewController() {
        guard let presentationContext = presentationContext else {
            finish()
            return
        }
        let safari = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        safari.delegate = self
        presentationContext.present(safari, animated: true, completion: nil)
    }
}

@available(iOS 9.0, *)
extension InAppBrowserOperation: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
            self.finish()
        }
    }
}
