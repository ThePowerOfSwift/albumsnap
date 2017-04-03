//
//  HomeTableViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var cameraVC: CameraViewController!
    var photosVC: PhotosViewController!
    var photoLibraryVC: PhotoLibraryViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//        checkPermissions()
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(checkPermissions),
//                                               name: .UIApplicationDidBecomeActive,
//                                               object: nil)
    }

//    deinit {
//        NotificationCenter.default.removeObserver(self,
//                                                  name: .UIApplicationDidBecomeActive,
//                                                  object: nil)
//    }

//    func checkPermissions() {
//        if !Permission.allPermissionsEnabled {
//            performSegue(with: .showPermissions, sender: nil)
//        }
//    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.frame.height
        return height
        //        switch Cell(rawValue: indexPath.row) {
        //        case .camera:
        //        case .captured:
        //        case .photoLibrary:
        //        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else { return }
        let point = CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y)
        if let indexPath = tableView.indexPathForRow(at: point) {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

enum Cell: Int {
    case camera
    case captured
    case photoLibrary
}

class CameraCell: UITableViewCell {}
class CapturedCell: UITableViewCell {}
class PhotoLibraryCell: UITableViewCell {}

extension HomeTableViewController: SegueHandler {

    enum SegueIdentifier: String {
        case camera = "Camera"
        case photos = "Photos"
        case photoLibrary = "PhotoLibrary"
        case showPermissions = "ShowPermissions"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        switch segueIdentifer(for: segue) {
        case .camera: cameraVC = destination as! CameraViewController
        case .photos: photosVC = destination as! PhotosViewController
        case .photoLibrary: photoLibraryVC  = destination as! PhotoLibraryViewController
        case .showPermissions: break
        }
    }
}


