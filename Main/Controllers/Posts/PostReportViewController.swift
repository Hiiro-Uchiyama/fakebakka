//
//  PostReportViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/04/16.
//

// Dynamic change

import UIKit

class PostReportViewController: UITabBarController {
    // titleLabel
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "件名"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 13.5)
        return label
    }()
    // titleField
    private let titleField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "例) 〇〇という投稿に関して"
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        field.layer.borderWidth = 1.0
        return field
    }()
    // textLabel
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "報告内容"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 13.5)
        return label
    }()
    // TextView for post
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.white
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 15.5)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        textView.layer.borderWidth = 1.0
        return textView
    }()
    // Loading of views.
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(titleField)
        view.addSubview(textLabel)
        view.addSubview(textView)
        configureButtons()
    }
    // Loading of views.
    // It would be good to have the place fitting here.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.frame = CGRect(x: 18.5, y: 100, width: view.width-35.5, height: 50)
        titleField.frame = CGRect(x: 18.5, y: titleLabel.bottom-10, width: view.width-35.5, height: 50)
        textLabel.frame = CGRect(x: 18.5, y: titleField.bottom-5, width: view.width-35.5, height: 50)
        textView.frame = CGRect(x: 18.5, y: textLabel.bottom-10, width: view.width-35.5, height: 280)
    }
    // Navigation and other settings.
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "キャンセル",
            style: .done,
            target: self,
            action: #selector(didTapCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "送信",
            style: .done,
            target: self,
            action: #selector(didTapReport)
        )
    }
    // Behaviour when pressing Cancel.
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    // Behaviour when the submit button is pressed
    @objc private func didTapReport() {
        // Check data and post
        guard let title = titleField.text,
              let body = textView.text,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            let alert = UIAlertController(title: "報告の詳細を入力してください",
                                          message: "件名、本文を入力してください。",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        let newReportId = UUID().uuidString
        // Insert of post into DB
        let date = Date() // May 4, 2020, 11:16 AM
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = formatter.string(from: date)
        print(strDate)
        let report = Report(
            identifier: newReportId,
            email: email,
            title: title,
            timestamp: strDate,
            text: body
        )
        DatabaseManager.shared.insert(Report: report, email: email) { [weak self] posted in
            guard posted else {
                DispatchQueue.main.async {
                    HapticsManager.shared.vibrate(for: .error)
                }
                return
            }
            DispatchQueue.main.async {
                HapticsManager.shared.vibrate(for: .success)
                self?.didTapCancel()
            }
        }
    }
}
