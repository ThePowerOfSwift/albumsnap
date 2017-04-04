//
//  Engine+User.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/3/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import RxSwift
import Apollo

extension Engine {

    func createUser(name: String, email: String, password: String) -> Observable<UserDetails> {
        let mutation = CreateUserMutation(name: name, email: email, password: password)
        return Observable.create { o in
            let operation = self.apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
                o.on(.next(result!.data!.createUser!.fragments.userDetails))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func signIn(email: String, password: String) -> Observable<(String, UserDetails)> {
        let mutation = SignInUserMutation(email: email, password: password)
        return Observable.create { o in
            let operation = self.apollo.perform(mutation: mutation)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
                let data = result!.data!.signinUser
                let token = data.token!
                let user = data.user!.fragments.userDetails
                o.on(.next(token, user))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

    func fetchUser(for id: String? = nil, for email: String? = nil) -> Observable<UserDetails> {
        let query = UserQuery(id: id, email: email)
        return Observable.create { o in
            let operation = self.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData)
            { result, error in
                guard error == nil else { o.on(.error(error!)); return }
                guard result?.errors == nil else { o.on(.error(result!.errors!.first!)); return }
                o.on(.next(result!.data!.user!.fragments.userDetails))
                o.on(.completed)
            }
            return Disposables.create {
                operation.cancel()
            }
        }
    }

}
