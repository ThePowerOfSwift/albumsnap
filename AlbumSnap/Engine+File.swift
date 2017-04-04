//
//  Engine+File.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/3/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import Kingfisher
import Files
import RxSwift
import Alamofire

extension Engine { // File Upload

    func uploadPhoto(image: UIImage, to album: AlbumDetails) {
        let filename = UUID().uuidString
        let uploadObservable = upload(image: image, with: "\(filename).jpg")
        let createPhotoObservable = createPhoto(with: album.id)
        Observable
            .zip(uploadObservable, createPhotoObservable) { return ($0, $1) }
            .flatMap { fileData, photoId -> Observable<URL> in
                return self.setPhotoFile(photoId: photoId, fileId: fileData.id)
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

    func upload(image: UIImage, with filename: String) -> Observable<FileData> {
        return upload(data: image.data!, with: filename)
    }

    func upload(data: Data, with filename: String) -> Observable<FileData> {
        let url = tempDir.appendingPathComponent(filename)
        do {
            try data.write(to: url)
        } catch let error {
            return Observable<FileData>.create { o in
                o.onError(error)
                return Disposables.create {}
            }
        }
        return upload(with: url)
    }

    func upload(with url: URL) -> Observable<FileData> {
        return Observable<FileData>.create { o in
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(url, withName: "data")
            }, to: fileEndpointURL) { result in
                switch result {
                case let .success(upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                        guard let dict = response.value as? Dictionary<String, Any>,
                            let fileData = FileData(dict: dict)
                            else { o.on(.error(EngineError.parsingError)); return }
                        o.on(.next(fileData))
                        o.on(.completed)
                    }
                case let .failure(encodingError):
                    o.on(.error(encodingError))
                }
            }
            return Disposables.create {}
        }
    }
}
