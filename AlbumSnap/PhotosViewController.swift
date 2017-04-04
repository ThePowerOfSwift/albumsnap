//
//  PhotosViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit
import RxSwift

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        engine
            .fetchPhotos()
            .bindTo(collectionView.rx.items(cellIdentifier: PhotoThumbnailCell.identifier,
                                            cellType: PhotoThumbnailCell.self))
            { row, data, cell in
                cell.configure(photo: data)
            }
            .addDisposableTo(disposeBag)

        collectionView
            .rx
            .setDelegate(self)
            .addDisposableTo(disposeBag)

        collectionView
            .rx
            .modelSelected(PhotoDetails.self)
            .subscribe(onNext: { (photo) in
                print("url: \(photo.file!.url)")
            })
            .addDisposableTo(disposeBag)
    }

}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.bounds.width
        let cellWidth = (width - 4) / 3 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

