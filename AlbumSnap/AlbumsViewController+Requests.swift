//
//  AlbumsViewController+Requests.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/20/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import RxSwift

extension AlbumsViewController {

    typealias Photo = AllPhotosQuery.Data.Photo
    typealias Album = AllAlbumsQuery.Data.Album

    func fetchPhotos() -> Observable<[Photo]> {
        let query = AllPhotosQuery()
        return Observable.create { o in
            let operation = apollo.fetch(query: query,
                                         cachePolicy: .returnCacheDataElseFetch)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                o.on(.next(result!.data!.photos))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func createPhoto(in album: Album) -> Observable<String> {
        let mutation = CreatePhotoMutation(albumId: album.id)
        return Observable.create { o in
            let operation = apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                o.on(.next(result!.data!.photo!.id))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func set(photoId: String, fileId: String) -> Observable<(String, String)> {
        let mutation = SetPhotoFileMutation(fileId: fileId, photoId: photoId)
        return Observable.create { o in
            let operation = apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                let payload = result!.data!.payload!
                o.on(.next(payload.photo!.id, payload.file!.id))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func fetchAlbums() -> Observable<[Album]> {
        let query = AllAlbumsQuery()
        return Observable.create { o in
            let operation = apollo.fetch(query: query,
                                         cachePolicy: .fetchIgnoringCacheData)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                o.on(.next(result!.data!.albums))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func createAlbum(with name: String) -> Observable<String> {
        let mutation = CreateAlbumMutation(name: name)
        return Observable.create { o in
            let operation = apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                o.on(.next(result!.data!.album!.id))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func delete(album: Album) -> Observable<String> {
        let mutation = DeleteAlbumMutation(id: album.id)
        return Observable.create { o in
            let operation = apollo.perform(mutation: mutation) { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                o.on(.next(result!.data!.album!.id))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func add(photo: Photo, to album: Album) -> Observable<(String, String)> {
        let mutation = AddPhotoToAlbumMutation(photoId: photo.id, albumId: album.id)
        return Observable.create { o in
            let operation = apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                let payload = result!.data!.payload!
                o.on(.next(payload.photo!.id, payload.album!.id))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func remove(photo: Photo, from album: Album) -> Observable<(String, String)> {
        let mutation = RemovePhotoFromAlbumMutation(photoId: photo.id, albumId: album.id)
        return Observable.create { o in
            let operation = apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                let payload = result!.data!.payload!
                o.on(.next(payload.photo!.id, payload.album!.id))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }
}


