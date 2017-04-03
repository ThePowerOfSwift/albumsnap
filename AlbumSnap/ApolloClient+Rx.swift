//
//  RxApollo.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/2/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import RxSwift
import Apollo

let graphlQLEndpointURL = "https://api.graph.cool/simple/v1/cizd4qias0hjj0140lmteq6n8"
let fileEndpointURL = "https://api.graph.cool/file/v1/cizd4qias0hjj0140lmteq6n8"
let apollo = ApolloClient(url: URL(string: graphlQLEndpointURL)!)

extension ApolloClient {

    // MARK: - Photos

    func fetchPhotos() -> Observable<[PhotoDetails]> {
        let query = AllPhotosQuery()
        return Observable.create { o in
            let operation = apollo.fetch(query: query,
                                         cachePolicy: .returnCacheDataElseFetch)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                o.on(.next(result!.data!.photos.map { $0.fragments.photoDetails }))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func createPhoto(with albumID: String) -> Observable<String> {
        let mutation = CreatePhotoMutation(albumId: albumID)
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

    func setPhotoFile(photoId: String, fileId: String) -> Observable<URL> {
        let mutation = SetPhotoFileMutation(fileId: fileId, photoId: photoId)
        return Observable.create { o in
            let operation = apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
                let url = URL(string: result!.data!.payload!.file!.url)!
                o.on(.next(url))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func add(photoID: String, to albumID: String) -> Observable<(String, String)> {
        let mutation = AddPhotoToAlbumMutation(photoId: photoID, albumId: albumID)
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

    func remove(photoID: String, from albumID: String) -> Observable<(String, String)> {
        let mutation = RemovePhotoFromAlbumMutation(photoId: photoID, albumId: albumID)
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

    // MARK: - Albums

    func fetchAlbums() -> Observable<[AlbumDetails]> {
        let query = AllAlbumsQuery()
        return Observable.create { o in
            let operation = apollo.fetch(query: query,
                                         cachePolicy: .fetchIgnoringCacheData)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                o.on(.next(result!.data!.albums.map { $0.fragments.albumDetails }))
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

    func deleteAlbum(with albumID: String) -> Observable<String> {
        let mutation = DeleteAlbumMutation(id: albumID)
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

}
