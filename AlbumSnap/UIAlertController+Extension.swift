//
//  UIAlertController+Extension.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/18/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit

extension UIWindow {
    var topViewController: UIViewController? {
        var topVC = rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
}

extension UIAlertController {

    func show() {
        UIApplication.shared.keyWindow?.topViewController?.present(self, animated: true, completion: nil)
    }

    static func okAlert(_ title: String?, _ message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.show()
    }

    static func continueAlert(_ title: String?, _ message: String?, _ continueText: String? = nil, block: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let continueAction = UIAlertAction(title: NSLocalizedString(continueText ?? "Continue", comment: ""), style: .default) { action in
            block()
        }
        alert.addAction(cancelAction)
        alert.addAction(continueAction)
        alert.show()
    }

    static func textAlert(_ title: String, _ message: String, completion: @escaping (String?) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardAppearance = .dark
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            completion(alert.textFields?.first?.text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.show()
    }

    static func actionsAlert(_ title: String?, _ message: String?, _ actions: [String: () -> ()]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        for (title, block) in actions {
            let action = UIAlertAction(title: title, style: .default) { action in
                block()
            }
            alert.addAction(action)
        }
        alert.show()
    }

    static func actionSheet(_ actions: [String: () -> ()], _ title: String? = nil, _ message: String? = nil,
                            sender: UIView? = nil, arrows: UIPopoverArrowDirection? = nil) -> UIAlertController
    {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (title, block) in actions {
            let action = UIAlertAction(title: title, style: .default) { action in
                block()
            }
            actionSheet.addAction(action)
        }
        if let sender = sender {
            actionSheet.popoverPresentationController?.sourceRect = sender.bounds
            actionSheet.popoverPresentationController?.sourceView = sender
        }
        if let arrows = arrows {
            actionSheet.popoverPresentationController?.permittedArrowDirections = arrows
        }
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        return actionSheet
    }
}
