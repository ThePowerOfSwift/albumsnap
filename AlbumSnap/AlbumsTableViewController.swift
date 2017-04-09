//
//  AlbumsTableViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/9/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Apollo

class AlbumsTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    typealias AlbumSection = SectionModel<AlbumDetails, PhotoDetails>
    let dataSource = RxTableViewSectionedReloadDataSource<AlbumSection>()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func setup() {
        guard let albums = engine.user?.albums else { print("no albums"); return }
        let albumDetails = albums.map { $0.fragments.albumDetails }

        Observable.just(albumDetails)
            .bindTo(tableView.rx.items(cellIdentifier: AlbumTableCell.identifier, cellType: AlbumTableCell.self))
            { row, album, cell in
                cell.configure(album: album)
            }
            .addDisposableTo(disposeBag)
    }

}

extension AlbumsTableViewController: Reloadable {
    func reload() {
        setup()
    }
}

class AlbumTableCell: UITableViewCell {

    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()

    func configure(album: AlbumDetails) {
        guard let photos = album.photos else { print("missing photos"); return }
        let photoDetails = photos.map { $0.fragments.photoDetails }
        albumLabel.text = album.name

        Observable<[PhotoDetails]>.just(photoDetails)
            .bindTo(collectionView.rx.items(cellIdentifier: PhotoThumbnailCell.identifier, cellType: PhotoThumbnailCell.self))
            { row, photo, cell in
                cell.configure(photo: photo)
            }
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
}

extension AlbumTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

