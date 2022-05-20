//
//  SignUpViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

// The alert function is used to present errors to the user side.
// Need to implement the feeling when the button is pressed and the notification when the operation is completed.
// Delegates represent a very important role in URLs.

import UIKit
import SafariServices
import Foundation

class SignUpViewController: UITabBarController, UITextViewDelegate {
    // Header View
    private let headerView = SignInHeaderView()
    private var checked = false
    private let radioButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 20,
                                            height: 20))
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        button.addTarget(self, action: #selector(didTapRadioButton), for: .touchUpInside)
        return button
    }()
    // UI Label
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16.5, weight: .regular)
        label.textColor = UIColor.black
        label.text = "フェイクニュースを共有しよう"
        return label
    }()
    // UI Label
    private let rulesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16.5, weight: .regular)
        label.textColor = UIColor.black
        label.text = "利用規約とプライバシーポリシー"
        return label
    }()
    private let rulesTextView: UITextView = {
        let textView = UITextView()
        // I can't seem to get by without a blank space.
        let baseString = "利用規約とプライバシーポリシー          "
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: "Terms_of_Use",
                                      range: NSString(string: baseString).range(of: "利用規約"))
        attributedString.addAttribute(.link,
                                      value: "Privacy_Policy",
                                      range: NSString(string: baseString).range(of: "プライバシーポリシー"))
        textView.attributedText = attributedString
        textView.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
        textView.isSelectable = true
        textView.isEditable = false
        // Cannot assign value of type '(SignUpViewController) -> () -> SignUpViewController' to type 'UITextViewDelegate?'
        // textView.delegate = self
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Charter-Roman", size: 13.5)
        return textView
    }()
    // Name field
    private let nameField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "ユーザー名"
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        field.layer.borderWidth = 1.0
        return field
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
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("アカウント登録", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    // Loading View.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "アカウント登録"
        view.backgroundColor = UIColor.white
        view.addSubview(headerView)
        view.addSubview(label)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(radioButton)
        view.addSubview(rulesTextView)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        rulesTextView.delegate = self
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
        nameField.frame = CGRect(x: 20, y: label.bottom+20, width: view.width-40, height: 50)
        emailField.frame = CGRect(x: 20, y: nameField.bottom+10, width: view.width-40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 50)
        radioButton.frame = CGRect(x:20, y:passwordField.bottom+15, width: 20, height: 20)
        rulesTextView.frame = CGRect(x:radioButton.right+10, y:passwordField.bottom+10, width: view.width-40, height: 25)
        signUpButton.frame = CGRect(x: 20, y: radioButton.bottom+15, width: view.width-40, height: 50)
    }
    @objc private func didTapRadioButton(){
            switch checked {
            case false:
                radioButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                checked = true
            case true:
                radioButton.setImage(nil, for: .normal)
                checked = false
            }
        }
    // Process after pressing sign-up.
    @objc func didTapSignUp() {
        animateView(signUpButton)
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty else {
            return
        }
        HapticsManager.shared.vibrateForSelection()
        // If the radio button is not checked, the account cannot be registered.
        // Create User
        if checked {
            AuthManager.shared.signUp(email: email, password: password) { [weak self] success in
                if success {
                    // Update database
                    let newUser = User(name: name, email: email, profilePictureRef: nil, description: nil, author_name: nil, web_link: nil, twitter_link: nil)
                    DatabaseManager.shared.insert(user: newUser) { inserted in
                        guard inserted else {
                            return
                        }
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(name, forKey: "name")
                        DispatchQueue.main.async {
                            let vc = TabBarViewController()
                            vc.modalPresentationStyle = .fullScreen
                            self?.present(vc, animated: true)
                        }
                    }
                } else {
                    print("アカウントの登録に失敗しました")
                }
            }
        }
        else {
            print("チェックボタンが押されていません")
        }
    }
    // error-handling mandatory
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            let urlString = URL.absoluteString
            if urlString == "Terms_of_Use" {
                let Terms_of_Use = "https://landlim.com"
                let url = NSURL(string: Terms_of_Use)
                // Conditional branch if url is nil
                if UIApplication.shared.canOpenURL(url! as URL){
                    UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                }
            }
            if urlString == "Privacy_Policy" {
                let Privacy_Policy = "https://landlim.com"
                let url = NSURL(string: Privacy_Policy)
                // Conditional branch if url is nil
                if UIApplication.shared.canOpenURL(url! as URL){
                    UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                }
            }
        return false
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
