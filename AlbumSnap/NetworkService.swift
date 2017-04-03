//
//  NetworkService.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/18/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import Alamofire
import RxSwift

// not currently used

class RxNetworkService {

    static func downloadImage(with url: String) -> Observable<UIImage> {
        return download(with: url).map { data -> UIImage in
            return UIImage(data: data)!
        }
    }

    static func download(with url: String) -> Observable<Data> {
        return Observable.create { o in
            let request = Alamofire.download(url).responseJSON { response in
                guard response.error == nil else { o.on(.error(response.error!)); return }
                guard let data = response.result.value as? Data else { o.on(.error(EngineError.invalidData)); return }
                o.on(.next(data))
                o.on(.completed)
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

class NetworkService {

    static func upload(image: UIImage, filename: String, completion: @escaping (FileData?) -> ()) {
        upload(data: image.data!, filename: filename) { dict in
            completion(FileData(dict: dict))
        }
    }

    static func upload(data: Data, filename: String, completion: @escaping (Dictionary<String, Any>?) -> ()) {
        let url = docDir.appendingPathComponent(filename)
        do {
            try data.write(to: url)
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
            return
        }

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(url, withName: "data")
        }, to: fileEndpointURL) { result in
            switch result {
            case let .success(upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    guard let dict = response.value as? Dictionary<String, Any> else {
                        completion(nil)
                        return
                    }
                    completion(dict)
                }
            case let .failure(encodingError):
                print(encodingError)
                completion(nil)
            }
        }
    }

    static func download(for secret: String, completion: @escaping (UIImage?) -> ()) {
        download(secret: secret) { data in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }

    static func download(secret: String, completion: @escaping (Data?) -> ()) {
        Alamofire.download("\(fileEndpointURL)/\(secret)").responseJSON { response in
            guard let data = response.result.value as? Data else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
}

