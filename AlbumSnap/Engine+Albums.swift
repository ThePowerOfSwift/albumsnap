//
//  Engine+Albums.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/3/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import RxSwift
import Apollo

extension Engine {

    func fetchAlbums() -> Observable<[AlbumDetails]> {
        let query = AllAlbumsQuery()
        return Observable.create { o in
            let operation = self.apollo.fetch(query: query,
                                                cachePolicy: .fetchIgnoringCacheData)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
                o.on(.next(result!.data!.albums.map { $0.fragments.albumDetails }))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func createAlbum(with name: String) -> Observable<String> {
        let mutation = CreateAlbumMutation(name: name, usersIds: [currentUserID!])
        return Observable.create { o in
            let operation = self.apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
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
            let operation = self.apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
                o.on(.next(result!.data!.album!.id))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func addPhoto(with photoID: String, to albumID: String) -> Observable<(String, String)> {
        let mutation = AddPhotoToAlbumMutation(photoId: photoID, albumId: albumID)
        return Observable.create { o in
            let operation = engine.apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
                let payload = result!.data!.payload!
                o.on(.next(payload.photo!.id, payload.album!.id))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func removePhoto(with photoID: String, from albumID: String) -> Observable<(String, String)> {
        let mutation = RemovePhotoFromAlbumMutation(photoId: photoID, albumId: albumID)
        return Observable.create { o in
            let operation = engine.apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
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
