//
//  SignInViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

// How do I address this issue?

import UIKit

class SignInViewController: UITabBarController {
    // Header View
    private let headerView = SignInHeaderView()
    // UIAlertController
    var alertController: UIAlertController!
    // alert function
    func alert(title:String, message:String) {
            alertController = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
            present(alertController, animated: true)
        }
    // UI Label
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16.5, weight: .regular)
        label.textColor = UIColor.black
        label.text = "ここに信頼できる情報はありません"
        return label
    }()
    // Email field
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "メールアドレス"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        field.layer.borderWidth = 1.0
        return field
    }()
    // Password field
    private let passwordField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "パスワード"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        field.layer.borderWidth = 1.0
        return field
    }()
    // Sign In button
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("ログイン", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    // Create Account
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("アカウント登録", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    // password reset
    private let passwardResetButton: UIButton = {
        let button = UIButton()
        button.setTitle("パスワードをお忘れですか?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    // Implementation of a login button.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(headerView)
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
        view.addSubview(passwardResetButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        passwardResetButton.addTarget(self, action: #selector(didTapPasswardReset), for: .touchUpInside)
        // Background transparency
        UITabBar.appearance().backgroundImage = UIImage()
        // Boundary transparency
        UITabBar.appearance().shadowImage = UIImage()
        // Change color
        UITabBar.appearance().barTintColor = UIColor.white
    }
    // positional coordinate
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/5)
        label.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
        emailField.frame = CGRect(x: 20, y: label.bottom+20, width: view.width-40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 50)
        signInButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 50)
        passwardResetButton.frame = CGRect(x: 20, y: signInButton.bottom+20, width: view.width-40, height: 50)
        createAccountButton.frame = CGRect(x: 20, y: passwardResetButton.bottom+20, width: view.width-40, height: 50)
    }
    // Action after pressing the sign-in button.
    @objc func didTapSignIn() {
        animateView(signInButton)
        guard let email = emailField.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty else {
            alert(title: "エラー", message: "メールアドレスもしくはパスワードが入力されていません")
            return
        }
        // I wish there was error handling.
        // { error in }
        // https://tech.playground.style/swift/error-handling/
        HapticsManager.shared.vibrateForSelection()
        AuthManager.shared.signIn(email: email, password: password) { [weak self] success in
            guard success else {
                return
            }
            // Update subscription status for newly signed in user
            IAPManager.shared.getSubscriptionStatus(completion: nil)
            DispatchQueue.main.async {
                UserDefaults.standard.set(email, forKey: "email")
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }
    // Action after pressing the account registration button.
    @objc func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.title = "アカウント登録"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    // PasswardResetViewController
    @objc func didTapPasswardReset() {
        let vc = PasswardResetViewController()
        vc.title = "パスワードリセット"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    func animateView(_ viewToAnimate:UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                viewToAnimate.transform = .identity
            }, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
