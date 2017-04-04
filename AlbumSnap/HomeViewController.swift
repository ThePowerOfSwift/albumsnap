//
//  HomeViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit
import ILLoginKit
import PKHUD
import RxSwift

class HomeViewController: UIViewController {

    var albumsVC: AlbumsViewController!
    
    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoginCoordinator()
    }

    func showLoginCoordinator() {
        if engine.currentUserID != nil && engine.token != nil { fetchUser(); return }

        loginCoordinator.start()
        loginCoordinator.finished = {
            self.albumsVC.reload()
        }
    }

    func fetchUser() {
        engine.fetchUser {
            print(engine.user!)
            self.albumsVC.reload()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension HomeViewController: SegueHandler {
    
    enum SegueIdentifier: String {
        case albums = "Albums"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifer(for: segue) {
        case .albums: albumsVC = segue.destination as! AlbumsViewController
        }
    }
}

