//
//  AppManager.swift
//  Ecommerce MVP
//
//  Created by Saurabh on 24/08/18.
//  Copyright © 2018 Saurabh. All rights reserved.
//

import UIKit

class AppManager: NSObject {

    static var touchBlocker: TouchBlocker?

    // MARK: touch blocker methods
    class func setupTouchBlocker() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        touchBlocker = TouchBlocker(frame: CGRect.zero)
        touchBlocker?.translatesAutoresizingMaskIntoConstraints = false
        appDelegate?.window?.addSubview(touchBlocker!)
        appDelegate?.window?.addConstraint(NSLayoutConstraint(item: touchBlocker!, attribute: .top, relatedBy: .equal, toItem: appDelegate?.window, attribute: .top, multiplier: 1, constant: 0))
        appDelegate?.window?.addConstraint(NSLayoutConstraint(item: touchBlocker!, attribute: .left, relatedBy: .equal, toItem: appDelegate?.window, attribute: .left, multiplier: 1, constant: 0))
        appDelegate?.window?.addConstraint(NSLayoutConstraint(item: touchBlocker!, attribute: .right, relatedBy: .equal, toItem: appDelegate?.window, attribute: .right, multiplier: 1, constant: 0))
        appDelegate?.window?.addConstraint(NSLayoutConstraint(item: touchBlocker!, attribute: .bottom, relatedBy: .equal, toItem: appDelegate?.window, attribute: .bottom, multiplier: 1, constant: 0))
    }

    class func showLoading() {
        guard touchBlocker != nil else {
            setupTouchBlocker()
            showLoading()
            return
        }
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.bringSubview(toFront: self.touchBlocker!)
        }
        touchBlocker!.showLoading()
    }

    class func hideLoading() {
        touchBlocker?.hideLoading()
    }

    // MARK: show alert methods
    class func showConfirmationAlert(showCancelButton: Bool, title: String, message: String, completionHandler: @escaping ((Bool) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // show cancel button if showCancelButton is explicitly passed
        if showCancelButton {
            alert.addAction(UIAlertAction(title: AppManager.ESLocalized(key: "Cancel"), style: .cancel, handler: { (_) in
                completionHandler(false)
            }))
        }

        // add OK button on alert dialog
        var positiveReply = AppManager.ESLocalized(key: "OK")
        if showCancelButton {
            positiveReply = AppManager.ESLocalized(key: "Yes")
        }
        alert.addAction(UIAlertAction(title: positiveReply, style: .default, handler: { _ in
            completionHandler(true)
        }))
        DispatchQueue.main.async {
            if let topViewController = topViewController() {
                topViewController.present(alert, animated: false, completion: nil)
            }
        }
    }

    class func ESLocalized(key: String) -> String {
        let stringValue =  NSLocalizedString(key, tableName: nil, bundle: Bundle(for: self.classForCoder()), value: "", comment: "")
        return stringValue
    }

    // MARK: helpers
    private static func topViewController() -> UIViewController? {
        if var topVC = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topVC.presentedViewController {
                topVC = presentedViewController
            }
            if let navigationController = (topVC as? UINavigationController) {
                topVC = navigationController.visibleViewController!
            }
            if let tabBarController = topVC as? UITabBarController {
                topVC = tabBarController.selectedViewController!
            }
            return topVC
        }
        return nil
    }
}
