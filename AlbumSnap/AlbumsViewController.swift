//
//  AlbumsViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 2/26/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import Files
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources
import UIKit

class AlbumsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    typealias AlbumSection = SectionModel<AlbumDetails, PhotoDetails>
    private let dataSource = RxCollectionViewSectionedReloadDataSource<AlbumSection>()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func setup() {
        guard let albums = engine.user?.albums else { print("no albums"); return }

        dataSource.configureCell = { datasource, collectionView, indexPath, item in
            let cell: PhotoThumbnailCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(photo: item)
            return cell
        }
        dataSource.supplementaryViewFactory = { dataSource, collectionView, kind, indexPath in
            let header: AlbumHeaderView = collectionView.dequeueHeaderView(for: indexPath)
            let album = dataSource.sectionModels[indexPath.section].model
            header.configure(album: album)
            return header
        }

        let sections: [AlbumSection] = albums.map { album in
            let album = album.fragments.albumDetails
            let photos: [PhotoDetails] = album.photos!.map { photo in
                return photo.fragments.photoDetails
            }
            return AlbumSection(model: album, items: photos)
        }

        Observable.just(sections)
            .bindTo(collectionView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)

        collectionView
            .rx
            .setDelegate(self)
            .addDisposableTo(disposeBag)

        collectionView
            .rx
            .modelSelected(PhotoDetails.self)
            .subscribe(onNext: { photo in
                print("photo: \(photo.id) selected")
            }, onError: { error in
                print(error.localizedDescription)
            })
            .addDisposableTo(disposeBag)
    }

    func reload() {
        setup()
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

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.bounds.width
        let cellWidth = (width - 4) / 3 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth)
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

