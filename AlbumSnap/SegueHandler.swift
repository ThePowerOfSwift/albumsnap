//
//  SegueHandler.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/20/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit

protocol SegueHandler {

    associatedtype SegueIdentifier: RawRepresentable
    func performSegue(with identifier: SegueIdentifier, sender: Any?)
    func segueIdentifer(for segue: UIStoryboardSegue) -> SegueIdentifier

}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {

    func performSegue(with identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }

    func segueIdentifer(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifer \(segue.identifier)")
        }
        return segueIdentifier
    }

}
