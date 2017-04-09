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

//        dataSource.configureCell = { ds, tableView, indexPath, item in
//            let cell: AlbumTableCell = tableView.dequeueCell(for: indexPath)
//            let album = ds.sectionModels[indexPath.section].model
//            cell.configure(album: album)
//            return cell
//        }
//
//        dataSource.titleForHeaderInSection = { ds, section in
//            let album = ds.sectionModels[section].model
//            return album.name
//        }
//
//        let sections: [AlbumSection] = albumDetails.map { album in
//            //let album = album.fragments.albumDetails
//            let photos: [PhotoDetails] = album.photos!.map { photo in
//                return photo.fragments.photoDetails
//            }
//            return AlbumSection(model: album, items: photos)
//        }
//
//        Observable.just(sections)
//            .bindTo(tableView.rx.items(dataSource: dataSource))
//            .addDisposableTo(disposeBag)


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

    @IBOutlet weak var collectionView: UICollectionView!
    typealias AlbumSection = SectionModel<AlbumDetails, PhotoDetails>
    private let dataSource = RxCollectionViewSectionedReloadDataSource<AlbumSection>()
    let disposeBag = DisposeBag()

    func configure(album: AlbumDetails) {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        collectionView.reloadData()

        let albums = [album]
//        guard let photos = album.photos else { print("missing photos"); return }
//        let photoDetails = photos.map { $0.fragments.photoDetails }

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
            //let album = album.fragments.albumDetails
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
//        Observable<[PhotoDetails]>.just(photoDetails)
//            .bindTo(collectionView.rx.items(cellIdentifier: PhotoThumbnailCell.identifier, cellType: PhotoThumbnailCell.self))
//            { row, photo, cell in
//                cell.configure(photo: photo)
//            }
//            .addDisposableTo(disposeBag)
//
//        collectionView
//            .rx
//            .setDelegate(self)
//            .addDisposableTo(disposeBag)
    }
}

extension AlbumTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //let width = collectionView.bounds.width
        //let cellWidth = (width - 4) / 3 // compute your cell width
        let cellWidth = 350
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

