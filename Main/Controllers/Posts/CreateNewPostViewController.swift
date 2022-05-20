//
//  CreateNewPostViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

// Maybe there should be an alert feature after posting or something.

import UIKit

class CreateNewPostViewController: UITabBarController {
    // titleLabel
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "見出し"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 13.5)
        return label
    }()
    // Title field
    private let titleField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "例) [悲報] 〇〇を襲った悲劇とは?"
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        field.layer.borderWidth = 1.0
        return field
    }()
    // Image Header
    // Image Create and insert an image.
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "photo"))
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    // textLabel
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "本文"
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
    // authorLabel
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "著者名"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 13.5)
        return label
    }()
    // Title field
    private let authorField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "例) フェイク・バッカ"
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        field.layer.borderWidth = 1.0
        return field
    }()
    // author_descriptionLabel
    private let author_descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "著者の紹介"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 13.5)
        return label
    }()
    
    // TextView for post
    private let author_descriptionView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.white
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 15.5)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        textView.layer.borderWidth = 1.0
        return textView
    }()
    // publisherLabel
    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.text = "出版社名"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 13.5)
        return label
    }()
    // Title field
    private let publisherField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "例) フェイク出版"
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        field.layer.borderWidth = 1.0
        return field
    }()
    // publisher_descriptionLabel
    private let publisher_descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "出版社の紹介"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 13.5)
        return label
    }()
    // TextView for post
    private let publisher_descriptionView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.white
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 15.5)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        textView.layer.borderWidth = 1.0
        return textView
    }()
    private let scrollView = UIScrollView()
    // Image.
    private var selectedHeaderImage: UIImage?
    // Loading of views.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        scrollView.addSubview(headerImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(titleField)
        scrollView.addSubview(textLabel)
        scrollView.addSubview(textView)
        scrollView.addSubview(authorLabel)
        scrollView.addSubview(authorField)
        scrollView.addSubview(author_descriptionLabel)
        scrollView.addSubview(author_descriptionView)
        scrollView.addSubview(publisherLabel)
        scrollView.addSubview(publisherField)
        scrollView.addSubview(publisher_descriptionLabel)
        scrollView.addSubview(publisher_descriptionView)
        // We want to set up a scrolling view so that more information can be posted.
        view.addSubview(scrollView)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
        configureButtons()
        scrollView.contentSize = CGSize(width: view.width, height: view.height+550)
        scrollView.frame.size = CGSize(width: view.width, height: view.height+550)
        // scrollView.flashScrollIndicators()
    }
    // Loading of views.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerImageView.frame = CGRect(x: 18.5, y: scrollView.safeAreaInsets.top, width:  view.width-35.5, height: 250)
        titleLabel.frame = CGRect(x: 18.5, y: headerImageView.bottom+10, width: view.width-35.5, height: 50)
        titleField.frame = CGRect(x: 18.5, y: titleLabel.bottom-10, width: view.width-35.5, height: 50)
        textLabel.frame = CGRect(x: 18.5, y: titleField.bottom-5, width: view.width-35.5, height: 50)
        textView.frame = CGRect(x: 18.5, y: textLabel.bottom-10, width: view.width-35.5, height: 280)
        // Additional information content.
        authorLabel.frame = CGRect(x: 18.5, y: textView.bottom-5, width: view.width-35.5, height: 50)
        authorField.frame = CGRect(x: 18.5, y: authorLabel.bottom-10, width: view.width-35.5, height: 50)
        author_descriptionLabel.frame = CGRect(x: 18.5, y: authorField.bottom-5, width: view.width-35.5, height: 50)
        author_descriptionView.frame = CGRect(x: 18.5, y: author_descriptionLabel.bottom-10, width: view.width-35.5, height: 150)
        publisherLabel.frame = CGRect(x: 18.5, y: author_descriptionView.bottom-5, width: view.width-35.5, height: 50)
        publisherField.frame = CGRect(x: 18.5, y: publisherLabel.bottom-10, width: view.width-35.5, height: 50)
        publisher_descriptionLabel.frame = CGRect(x: 18.5, y: publisherField.bottom-5, width: view.width-35.5, height: 50)
        publisher_descriptionView.frame = CGRect(x: 18.5, y: publisher_descriptionLabel.bottom-10, width: view.width-35.5, height: 150)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    // Configure the behaviour when the header is tapped.
    @objc private func didTapHeader() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
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
            title: "投稿",
            style: .done,
            target: self,
            action: #selector(didTapPost)
        )
    }
    // Behaviour when pressing Cancel.
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    // Behaviour when the submit button is pressed
    @objc private func didTapPost() {
        // Check data and post
        guard let title = titleField.text,
              let body = textView.text,
              let headerImage = selectedHeaderImage,
              let author = authorField.text,
              let author_description = author_descriptionView.text,
              let publisher = publisherField.text,
              let publisher_description = publisher_descriptionView.text,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            let alert = UIAlertController(title: "投稿の詳細を入力してください",
                                          message: "タイトル、本文、著者、著者の紹介、出版社、出版社の紹介を入力し画像、を選択して投稿を完了してください。",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        print("投稿をしています")
        let newPostId = UUID().uuidString
        // Upload header Image
        StorageManager.shared.uploadBlogHeaderImage(
            email: email,
            image: headerImage,
            postId: newPostId
        ) { success in
            guard success else {
                return
            }
            print("投稿が進行中です")
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: newPostId) { url in
                guard let headerUrl = url else {
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    return
                }
                // Insert of post into DB
                let date = Date() // May 4, 2020, 11:16 AM
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let strDate = formatter.string(from: date)
                print(strDate)
                let post = BlogPost(
                    identifier: newPostId,
                    email: email,
                    title: title,
                    timestamp: strDate,
                    headerImageUrl: headerUrl,
                    text: body,
                    author: author,
                    author_description: author_description,
                    publisher: publisher,
                    publisher_description: publisher_description,
                    watch_count: 0,
                    like_count: 0,
                    dislike_count: 0,
                    comment_count: 0
                )
                print("投稿完了間近です")
                DatabaseManager.shared.insert(blogPost: post, email: email) { [weak self] posted in
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
                print("投稿が完了しました")
            }
        }
    }
}
// Post button controller.
extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Configure the image settings for the post button.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    // setup
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        let selectedImage = image.resized(withPercentage: 0.1)
        selectedHeaderImage = selectedImage
        headerImageView.image = selectedImage
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
