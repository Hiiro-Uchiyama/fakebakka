//
//  PasswardResetView.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/24.
//

// View to reset password
// It may be necessary to catch the error somehow.
// Ensure that the user side is aware of errors, etc.
// What about notifications via swift's alert method or something like that?

import UIKit

class PasswardResetViewController: UITabBarController {
    // Header View
    private let headerView = SignInHeaderView()
    // UI Label
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16.5, weight: .regular)
        label.textColor = UIColor.black
        label.text = "パスワードをリセットするためにあなたのメールアドレスを入力してください"
        return label
    }()
    // Email field
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "メールアドレス"
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        field.layer.borderWidth = 1.0
        return field
    }()
    // Sign In button
    private let sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("メールを受け取る", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    // Loading View.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "パスワードリセット"
        view.backgroundColor = UIColor.white
        view.addSubview(headerView)
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        // Background transparency
        UITabBar.appearance().backgroundImage = UIImage()
        // Boundary transparency
        UITabBar.appearance().shadowImage = UIImage()
        // Change color
        UITabBar.appearance().barTintColor = UIColor.white
    }
    // Set View details.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/5)
        label.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
        emailField.frame = CGRect(x: 20, y: label.bottom+20, width: view.width-40, height: 50)
        sendButton.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 50)
    }
    // Process after pressing sign-up.
    @objc func didTapSendButton() {
        animateView(sendButton)
        guard let email = emailField.text, !email.isEmpty else {
            return
        }
        HapticsManager.shared.vibrateForSelection()
        // Create User
        AuthManager.shared.passwordResetting(email: email)
    }
    // animate
    func animateView(_ viewToAnimate:UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                viewToAnimate.transform = .identity
            }, completion: nil)
        }
    }
}
