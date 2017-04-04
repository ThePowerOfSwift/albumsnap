//
//  Identifiable.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/20/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {

    enum Storyboard: String {
        case albums         = "Albums"
        case camera         = "Camera"
        case main           = "Main"
        case photos         = "Photos"
        case photoLibrary   = "PhotoLibrary"
    }

    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }

    func instantiateViewController<T: UIViewController>() -> T where T: Identifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.identifier)")
        }
        return viewController
    }
}

extension UITableView {

    func registerCell<T: UITableViewCell>(_: T.Type) where T: Identifiable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.identifier)
    }

    func dequeueCell<T: UITableViewCell>() -> T where T: Identifiable {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }

    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Identifiable {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }

    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type) where T: Identifiable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.identifier, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: T.identifier)
    }

    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>() -> T where T: Identifiable {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }
}

extension UICollectionView {

    func registerCell<T: UICollectionViewCell>(_: T.Type) where T: Identifiable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }

    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Identifiable {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueHeaderView<T: UICollectionReusableView>(for indexPath: IndexPath) -> T where T: Identifiable {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueFooterView<T: UICollectionReusableView>(for indexPath: IndexPath) -> T where T: Identifiable {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}

extension UIViewController: Identifiable {}
extension UITableViewCell: Identifiable {}
//extension UICollectionViewCell: Identifiable {}
extension UITableViewHeaderFooterView: Identifiable {}
extension UICollectionReusableView: Identifiable {}
