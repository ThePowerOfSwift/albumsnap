//
//  Engine.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/3/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import RxSwift
import Apollo
import KeychainSwift
import SwiftyUserDefaults
import PKHUD

let graphlQLEndpointURL = "https://api.graph.cool/simple/v1/cizd4qias0hjj0140lmteq6n8"
let fileEndpointURL = "https://api.graph.cool/file/v1/cizd4qias0hjj0140lmteq6n8"

let engine = Engine()

class Engine {

    var disposeBag = DisposeBag()
    var apollo: ApolloClient = ApolloClient(url: URL(string: graphlQLEndpointURL)!)
    var user: UserDetails?
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
        apollo.cacheKeyForObject = { $0["id"] }
    }

    func newAuth(user: UserDetails, token: String) {
        self.user = user
        Defaults[.currentUserID] = user.id
        KeychainSwift().set(token, forKey: "token")
        setupApollo()
    }

    func logout() {
        user = nil
        Defaults[.currentUserID] = nil
        KeychainSwift().delete("token")
        apollo = ApolloClient(url: URL(string: graphlQLEndpointURL)!)
    }

    func fetchUser(completion: @escaping () -> ()) {
        guard let userID = currentUserID else { return }
        HUD.show(.progress)
        fetchUser(for: userID)
            .subscribe(onNext: { userDetails in
                HUD.hide(animated: true)
                self.user = userDetails
                completion()
            }, onError: { error in
                print(error.localizedDescription)
                HUD.show(.labeledError(title: "Error", subtitle: error.localizedDescription))
            })
            .addDisposableTo(disposeBag)
    }

}

extension DefaultsKeys {
    static let currentUserID = DefaultsKey<String?>("currentUserID")
}

enum EngineError: Error {
    case parsingError
    case invalidData
}
