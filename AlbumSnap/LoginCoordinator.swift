//
//  LoginCoordinator.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 4/3/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import ILLoginKit
import RxSwift
import PKHUD
import ChameleonFramework

class LoginCoordinator: ILLoginKit.LoginCoordinator {

    var disposeBag = DisposeBag()
    var finished: (() -> ())?

    override func start() {
        super.start()
        configureAppearance()
    }

    override func finish() {
        finished?()
        super.finish()
    }

    func configureAppearance() {
        backgroundImage = Image.backgroundImage.value
        tintColor = .flatPowderBlue

        loginButtonText = "Sign In"
        signupButtonText = "Create Account"
        facebookButtonText = "Login with Facebook"
        forgotPasswordButtonText = "Forgot password?"
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Name"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Password!"
        repeatPasswordPlaceholder = "Confirm password!"
    }

    // MARK: - Completion Callbacks

    // Handle login via your API
    override func login(email: String, password: String) {
        print("Login with: email = \(email) password = \(password)")
        HUD.show(.progress)
        engine
            .signIn(email: email, password: password)
            .subscribe(onNext: { token, user in
                HUD.flash(.success)
                print("User: \(user.id): \(user.name) signed in with token: \(token)")
                engine.newAuth(user: user, token: token)
                self.finish()
            }, onError: { (error) in
                print(error.localizedDescription)
                HUD.show(.labeledError(title: "Error", subtitle: error.localizedDescription))
            })
            .addDisposableTo(disposeBag)
    }

    // Handle signup via your API
    override func signup(name: String, email: String, password: String) {
        print("Signup with: name = \(name) email = \(email) password = \(password)")
        HUD.show(.progress)
        engine
            .createUser(name: name, email: email, password: password)
            .flatMap { (user) -> Observable<(String, UserDetails)> in
                print("User \(user.id): \(user.name) signed up")
                return engine.signIn(email: email, password: password)
            }.subscribe(onNext: { (token, user) in
                HUD.flash(.success)
                print("User: \(user.id): \(user.name) signed in with token: \(token)")
                engine.newAuth(user: user, token: token)
                self.finish()
            }, onError: { error in
                print(error.localizedDescription)
                HUD.show(.labeledError(title: "Error", subtitle: error.localizedDescription))
            })
            .addDisposableTo(disposeBag)
    }

    // Handle Facebook login/signup via your API
    override func enterWithFacebook(profile: FacebookProfile) {
        print("Login/Signup via Facebook with: FB profile =\(profile)")
    }

    // Handle password recovery via your API
    override func recoverPassword(email: String) {
        print("Recover password with: email =\(email)")
    }
}


