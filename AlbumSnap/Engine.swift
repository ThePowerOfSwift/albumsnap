//
//  Engine.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/3/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import RxSwift
import Apollo
import Alamofire
import KeychainSwift
import SwiftyUserDefaults

let graphlQLEndpointURL = "https://api.graph.cool/simple/v1/cizd4qias0hjj0140lmteq6n8"
let fileEndpointURL = "https://api.graph.cool/file/v1/cizd4qias0hjj0140lmteq6n8"

let engine = Engine()

class Engine {

    var apollo: ApolloClient = ApolloClient(url: URL(string: graphlQLEndpointURL)!)
    var currentUserID: String? {
        return Defaults[.currentUserID]
    }
    var token: String? {
        return KeychainSwift().get("token")
    }

    init() {
        setupApollo()
    }

    func setupApollo() {
        guard let token = token else { print("token not in keychain"); return }

        let configuration: URLSessionConfiguration = .default
        // Add additional headers as needed
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer <\(token)>"]

        guard let url = try? graphlQLEndpointURL.asURL() else { return }
        apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }

    func newAuth(user: UserDetails, token: String) {
        Defaults[.currentUserID] = user.id
        KeychainSwift().set(token, forKey: "token")
        setupApollo()
    }

    func logout() {
        Defaults[.currentUserID] = nil
        KeychainSwift().delete("token")
        apollo = ApolloClient(url: URL(string: graphlQLEndpointURL)!)
    }

}

extension DefaultsKeys {
    static let currentUserID = DefaultsKey<String?>("currentUserID")
}

extension Engine { // File Upload

    static func upload(image: UIImage, with filename: String) -> Observable<FileData> {
        return upload(data: image.data!, with: filename)
    }

    static func upload(data: Data, with filename: String) -> Observable<FileData> {
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

    static func upload(with url: URL) -> Observable<FileData> {
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

enum EngineError: Error {
    case parsingError
    case invalidData
}
