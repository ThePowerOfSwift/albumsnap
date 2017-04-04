//
//  Engine+Photos.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/3/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import RxSwift
import Apollo

extension Engine {

    func fetchPhotos(last: Int? = nil) -> Observable<[PhotoDetails]> {
        let query = AllPhotosQuery(last: last)
        return Observable.create { o in
            let operation = self.apollo.fetch(query: query,
                                         cachePolicy: .returnCacheDataElseFetch)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
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
            let operation = engine.apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
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
            let operation = engine.apollo.perform(mutation: mutation)
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

}
