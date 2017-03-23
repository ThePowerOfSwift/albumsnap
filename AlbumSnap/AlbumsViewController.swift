//
//  AlbumsViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 2/26/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import Apollo
import Files
import Kingfisher
import RxSwift
import RxCocoa
import UIKit

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
        uploadPhoto()

        //add(photos: photos, to: albums.first!)
        //remove(photos: photos, from: albums.first!)
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

    func uploadPhoto(image: UIImage = UIImage(named: "backgroundImage")!) {
        let filename = UUID().uuidString
        let uploadObservable = RxNetworkService.upload(image: image, with: "\(filename).jpg")
        let createPhotoObservable = createPhoto(in: self.albums.first!)
        Observable
            .zip(uploadObservable, createPhotoObservable) { return ($0, $1) }
            .flatMap { fileData, photoId -> Observable<URL> in
                return self.set(photoId: photoId, fileId: fileData.id)
            }
            .subscribe(onNext: { url in
                print("file url: \(url)")
                self.moveToCache(filename, url)
            }, onError: { error in
                print(error.localizedDescription)
            })
            .addDisposableTo(disposeBag)
    }

    func moveToCache(_ filename: String, _ url: URL) {
        let localURL = tempDir.appendingPathComponent("\(filename).jpg")
        do {
            try File(path: localURL.path).delete()
        } catch let error {
            print(error.localizedDescription)
        }
        ImagePrefetcher(urls: [url]) { _, _, completedResources in
            print("These resources are prefetched: \(completedResources)")
        }.start()
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

