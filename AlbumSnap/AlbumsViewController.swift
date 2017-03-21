//
//  AlbumsViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 2/26/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit
import Apollo
import RxSwift
import RxCocoa

class AlbumsViewController: UIViewController {

    var fromStoryboard: AlbumsViewController {
        return UIStoryboard(.albums).instantiateViewController()
    }

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var photos: [Photo] = []
    var albums: [Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getAlbums()
        getPhotos()
    }

    func getPhotos() {
        fetchPhotos()
            .subscribe(onNext: { photos in
                for photo in photos {
                    print("photo id: \(photo.id)")
                }
                self.photos = photos
            })
            .addDisposableTo(disposeBag)
    }

    func getAlbums() {
        fetchAlbums()
            .subscribe(onNext: { albums in
                for album in albums {
                    print("Album name: \(album.name)")
                    for photo in album.photos! {
                        let caption = photo.caption ?? "no caption"
                        print("\tPhoto caption: \(caption)")
                    }
                }
                self.albums = albums
            })
            .addDisposableTo(disposeBag)
    }

    @IBAction func tapGesture(_ sender: Any) {
        //createAlbum()
        //uploadPhoto()

        //add(photos: photos, to: albums.first!)
        //add(photo: photos.first!, album: albums.first!)
        //add(photo: photos.last!, album: albums.first!)
        remove(photos: photos, from: albums.first!)
    }

    func add(photos: [Photo], to album: Album) {
        var addOperations: [Observable<(String, String)>] = []
        photos.forEach { photo in
            addOperations += [add(photo: photo, to: album)]
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

    func remove(photos: [Photo], from album: Album) {
        var removeOperations: [Observable<(String, String)>] = []
        photos.forEach { photo in
            removeOperations += [remove(photo: photo, from: album)]
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

    func uploadPhoto() {
        let image = UIImage(named: "backgroundImage")!
        let uploadObservable = RxNetworkService.upload(image: image, with: "YO.jpg")
        let createPhotoObservable = createPhoto(in: self.albums.first!)
        Observable
            .zip(uploadObservable, createPhotoObservable) { return ($0, $1) }
            .flatMap { fileData, photoId -> Observable<(String, String)> in
                return self.set(photoId: photoId, fileId: fileData.id)
            }
            .subscribe(onNext: { photoId, fileId in
                print("photoId: \(photoId) set to fileID \(fileId)")
            }, onError: { error in
                print(error.localizedDescription)
            })
            .addDisposableTo(disposeBag)
    }

    func createAlbum() {
        UIAlertController.textAlert("New Album", "Enter Album Name") { albumName in
            guard let albumName = albumName else { return }
            self.createAlbum(with: albumName)
                .subscribe(onNext: { albumId in
                    print("New album created with id: \(albumId)")
                    self.getAlbums()
                })
                .addDisposableTo(self.disposeBag)
        }
    }

    func deleteAlbum(album: Album) {
        delete(album: album)
            .subscribe(onNext: { albumId in
                print("albumId: \(albumId) has been deleted")
            }, onError: { error in
                print(error.localizedDescription)
            })
            .addDisposableTo(disposeBag)
    }
}

class ThumbnailCell: UITableViewCell {
    typealias Photo = AllAlbumsQuery.Data.Album.Photo

    @IBOutlet weak var thumbnail: UIImageView!

    func configure(model: Photo) {

    }
}

