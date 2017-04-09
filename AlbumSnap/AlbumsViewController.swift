//
//  AlbumsViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 2/26/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit
import RxSwift

protocol Reloadable {
    func reload()
}

class AlbumsViewController: UIViewController {

    let disposeBag = DisposeBag()
    var albumsCVC: AlbumsCollectionViewController!
    var albumsTVC: AlbumsTableViewController!
    var visibleVC: Reloadable!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func reload() {
        albumsTVC.reload()
    }

    func add(photos: [PhotoDetails], to album: AlbumDetails) {
        var addOperations: [Observable<(String, String)>] = []
        photos.forEach { photo in
            addOperations += [engine.addPhoto(with: photo.id, to: album.id)]
        }
        Observable
            .concat(addOperations)
            .subscribe(onNext: { photoId, albumId in
                print("photoId: \(photoId) added to albumId: \(albumId)")
            }, onError: { (error) in
                print(error.localizedDescription)
            })
            .addDisposableTo(disposeBag)
    }

    func remove(photos: [PhotoDetails], from album: AlbumDetails) {
        var removeOperations: [Observable<(String, String)>] = []
        photos.forEach { photo in
            removeOperations += [engine.removePhoto(with: photo.id, from: album.id)]
        }
        Observable
            .concat(removeOperations)
            .subscribe(onNext: { photoId, albumId in
                print("photoId: \(photoId) removed from albumId: \(albumId)")
            }, onError: { (error) in
                print(error.localizedDescription)
            })
            .addDisposableTo(disposeBag)
    }

    func createAlbum() {
        UIAlertController.textAlert("New Album", "Enter Album Name") { albumName in
            guard let albumName = albumName else { return }
            engine
                .createAlbum(with: albumName)
                .subscribe(onNext: { albumId in
                    print("New album created with id: \(albumId)")
                    //self.getAlbums()
                    engine.fetchUser {
                        self.reload()
                    }
                })
                .addDisposableTo(self.disposeBag)
        }
    }

    func deleteAlbum(album: AlbumDetails) {
        engine
            .deleteAlbum(with: album.id)
            .subscribe(onNext: { albumId in
                print("albumId: \(albumId) has been deleted")
            }, onError: { error in
                print(error.localizedDescription)
            })
            .addDisposableTo(disposeBag)
    }
}

extension AlbumsViewController: SegueHandler {
    
    enum SegueIdentifier: String {
        case collection = "CollectionView"
        case table      = "TableView"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifer(for: segue) {
        case .collection: albumsCVC = segue.destination as! AlbumsCollectionViewController
        case .table: albumsTVC = segue.destination as! AlbumsTableViewController
        }
    }
}

class PhotoThumbnailCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!

    func configure(photo: PhotoDetails) {
        if let url = try? photo.file?.url.asURL() {
            thumbnailImageView.kf.setImage(with: url)
        }
    }
}

class AlbumHeaderView: UICollectionReusableView {

    @IBOutlet weak var albumLabel: UILabel!
    
    func configure(album: AlbumDetails) {
        albumLabel.text = album.name
    }
}

