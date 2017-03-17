//
//  AlertOperation.swift
//  Trygve
//
//  Created by Nan Wang on 2016-11-24.
//  Copyright © 2016 Trygve. All rights reserved.
//

import UIKit

final class AlertOperation: Operation {

    /// MARK: Properties
    private let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    private let sharedApplication: UIApplication? = UIApplication.value(forKey: "sharedApplication") as? UIApplication
    private lazy var presentationContext: UIViewController? = { [unowned self] in
        return self.sharedApplication?.keyWindow?.rootViewController
    }()

    var title: String? {
        get { return alertController.title }
        set {
            alertController.title = newValue
            name = newValue
        }
    }

    var message: String? {
        get { return alertController.message }
        set { alertController.message = newValue }
    }

    /// MARK: Initialization
    init(presentationContext: UIViewController? = nil) {

        super.init()
        /*
         This gurantees another alert will never be shown
         */
        addCondition(MutuallyExclusive<AlertOperation>())

        /*
         This operation modifies the view controller hierarchy.
         Doing this while other such operations are executing can lead to
         inconsistencies in UIKit. So, let's make them mutally exclusive.
         */
        addCondition(MutuallyExclusive<UIViewController>())
    }

    /// MARK: Executions
    /// *** Must *** call finish() at some point to end this operation
    override func execute() {
        guard let presentationContext = presentationContext else {
            finish()
            return
        }
        DispatchQueue.main.async {
            if self.alertController.actions.isEmpty {
                self.addAction(title: "OK")
            }
            presentationContext.present(self.alertController, animated: true, completion: nil)
        }
    }

    /// MARK: helper functions
    func addAction(title: String, style: UIAlertActionStyle = .default, handler: @escaping ((AlertOperation) -> Void) = { _ in }) {
        let action = UIAlertAction(title: title, style: style) { [weak self] _ in
            if let strongSelf = self {
                handler(strongSelf)
            }
            self?.finish()
        }
        alertController.addAction(action)
    }
}
