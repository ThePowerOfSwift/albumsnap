//
//  AlbumsCollectionViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/9/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class AlbumsCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var albums: [AlbumDetails]?
    typealias AlbumSection = SectionModel<AlbumDetails, PhotoDetails>
    private let dataSource = RxCollectionViewSectionedReloadDataSource<AlbumSection>()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func setup() {
        //guard let albums = engine.user?.albums else { print("no albums"); return }
        guard let albums = albums else { print("no albums"); return }

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
    }
    
}

extension AlbumsCollectionViewController: Reloadable {
    func reload() {
        setup()
    }
}

extension AlbumsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.bounds.width
        let cellWidth = (width - 4) / 3 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth)
    }


}
