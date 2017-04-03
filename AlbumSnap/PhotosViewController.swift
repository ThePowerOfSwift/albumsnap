//
//  PhotosViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import Apollo

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    var photos: [PhotoDetails] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        apollo
            .fetchPhotos()
            .bindTo(collectionView.rx.items(cellIdentifier: PhotoThumbnailCell.identifier,
                                            cellType: PhotoThumbnailCell.self))
            { row, data, cell in
                cell.configure(photo: data)
            }
            .addDisposableTo(disposeBag)

        collectionView.rx.setDelegate(self).addDisposableTo(disposeBag)

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

class PhotoThumbnailCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!

    func configure(photo: PhotoDetails) {
        if let url = try? photo.file?.url.asURL() {
            thumbnailImageView.kf.setImage(with: url)
        }
    }
}

