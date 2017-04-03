//
//  HomeViewController.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit
import ILLoginKit
import ChameleonFramework
import RxSwift
import PKHUD

class HomeViewController: UIViewController {

    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoginCoordinator()
    }

    func showLoginCoordinator() {
        if engine.currentUserID != nil && engine.token != nil { return }

        loginCoordinator.start()

        loginCoordinator.signup = { name, email, password in
            self.signup(name, email, password)
        }
        loginCoordinator.login = { email, password in
            self.login(email, password)
        }
    }

    func signup(_ name: String, _ email: String, _ password: String) {
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
                self.loginCoordinator.finish()
            }, onError: { error in
                print(error.localizedDescription)
                HUD.show(.labeledError(title: "Error", subtitle: error.localizedDescription))
            })
            .addDisposableTo(disposeBag)
    }

    func login(_ email: String, _ password: String) {
        engine
            .signIn(email: email, password: password)
            .subscribe(onNext: { token, user in
                print("User: \(user.id): \(user.name) signed in with token: \(token)")
                engine.newAuth(user: user, token: token)
                self.loginCoordinator.finish()
            }, onError: { (error) in
                print(error.localizedDescription)
                HUD.show(.labeledError(title: "Error", subtitle: error.localizedDescription))
            })
            .addDisposableTo(disposeBag)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class LoginCoordinator: ILLoginKit.LoginCoordinator {

    var login: ((String, String) -> ())?
    var signup: ((String, String, String) -> ())?

    override func start() {
        super.start()
        configureAppearance()
    }

    override func finish() {
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
        login?(email, password)
    }

    // Handle signup via your API
    override func signup(name: String, email: String, password: String) {
        print("Signup with: name = \(name) email = \(email) password = \(password)")
        signup?(name, email, password)
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


