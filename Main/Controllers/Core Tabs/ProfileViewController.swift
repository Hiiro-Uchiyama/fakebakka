//
//  ProfileViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

// User information right-aligned would still look good.
// What else do I need to know.
// It would be nice to be able to slide through posts and edit or delete them.
// I'd like to see people's pages, though.
// You want to know who wrote it.
// May cause some problems with the width of contributions.
// Variable text display area, limiting the maximum number of characters.
// The size should be variable with regard to the input of details.
// It would be good if the number of posts to be displayed was random or reduced in advance.
// Be particular about the size of the text.
// It would be nice to see the number of likes and such.
// Automatic Layout
// Labels and Text View
// The size is reduced by the sizeToFit method.
// Open blanks

import UIKit
import SafariServices
import Foundation

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    // Profile Photo
    // Full Name
    // Email
    // List of posts
    private var user: User?
    // Configuration of UI table view.
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        return tableView
    }()
    // currentEmail
    let currentEmail: String
    // email initialization method
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    // initialization method
    required init?(coder: NSCoder) {
        fatalError()
    }
    let sectionArry: [String] = [
        "Fake News",
    ]
    // Specify section title.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArry[section]
    }
    // Load screen.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSignOutButton()
        setUpTable()
        title = "Profile"
        fetchPosts()
    }
    // Load screen.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    // Do first.
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      tableView.reloadData()
    }
    // Setting up the table
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableHeader()
        fetchProfileData()
    }
    // Settings relating to the display area in the centre of the screen.
    private func setUpTableHeader(
        profilePhotoRef: String? = nil,
        name: String? = nil,
        author_name: String? = nil,
        description: String? = nil,
        web_link: String? = nil,
        twitter_link: String? = nil
    ) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/2.5))
        headerView.backgroundColor = UIColor.white
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        // Profile picture
        let profilePhoto = UIImageView(image: UIImage(systemName: "figure.wave.circle.fill"))
        profilePhoto.tintColor = .black
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.frame = CGRect(
            x: (view.width-(view.width/4))/2,
            y: (headerView.height-(view.width/4))/4,
            width: view.width/4,
            height: view.width/4
        )
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.width/2
        profilePhoto.isUserInteractionEnabled = true
        headerView.addSubview(profilePhoto)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)
        // Author_name
        let author_nameLabel = UILabel(frame: CGRect(x: 20, y: profilePhoto.bottom+20, width: view.width-40, height: 22.5))
        author_nameLabel.text = author_name
        author_nameLabel.textColor = .black
        author_nameLabel.numberOfLines = 0
        author_nameLabel.sizeToFit()
        author_nameLabel.font = UIFont(name: "Charter-Roman", size: 15.5)
        author_nameLabel.textAlignment = NSTextAlignment.right
        headerView.addSubview(author_nameLabel)
        // Description
        let descriptionLabel = UILabel(frame: CGRect(x: 20, y: author_nameLabel.bottom+20, width: view.width-40, height: 42.5))
        descriptionLabel.text = description
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionLabel.font = UIFont(name: "Charter-Roman", size: 15.5)
        headerView.addSubview(descriptionLabel)
        // textView
        let web_link_textView = UITextView()
        headerView.addSubview(web_link_textView)
        // I can't seem to get by without a blank space.
        // How to generate pseudo blanks
        let baseString = "WebとTwitterのリンク          "
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: "WebLink",
                                      range: NSString(string: baseString).range(of: "Web"))
        attributedString.addAttribute(.link,
                                      value: "TwitterLink",
                                      range: NSString(string: baseString).range(of: "Twitter"))
        web_link_textView.attributedText = attributedString
        web_link_textView.frame = CGRect(x: 20, y: descriptionLabel.bottom+20, width: view.width-40, height: 22.5)
        web_link_textView.sizeToFit()
        web_link_textView.isSelectable = true
        web_link_textView.isEditable = false
        web_link_textView.delegate = self
        web_link_textView.isScrollEnabled = false
        web_link_textView.font = UIFont(name: "Charter-Roman", size: 15.5)
        if let name = name {
            title = name
        }
        if let ref = profilePhotoRef {
            // Fetch image
            StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
    }
    // Function when tapping the profile picture.
    @objc private func didTapProfilePhoto() {
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail else {
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    // Fetching profile data
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user
            DispatchQueue.main.async {
                self?.setUpTableHeader(
                    profilePhotoRef: user.profilePictureRef,
                    name: user.name,
                    author_name: user.author_name,
                    description: user.description,
                    web_link: user.web_link,
                    twitter_link: user.twitter_link
                )
            }
            print(user)
        }
    }
    // Installation of a sign-out button.
    private func setUpSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "ログアウト",
            style: .done,
            target: self,
            action: #selector(didTapSignOut)
        )
    }
    // Sign Out
    @objc private func didTapSignOut() {
        let sheet = UIAlertController(title: "ログアウト", message: "有意義なフェイクニュースを流すことはできましたか?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "ログアウト", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        UserDefaults.standard.set(false, forKey: "premium")
                        let vc = FinalPageViewController()
                        vc.title = "Logout"
                        vc.navigationController?.navigationBar.prefersLargeTitles = true
                        vc.navigationItem.largeTitleDisplayMode = .always
                        // It is possible to hide the bottombar of the transition transition destination.
                        let nav = UINavigationController(rootViewController: vc)
                        nav.navigationBar.prefersLargeTitles = true
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(sheet, animated: true)
    }
    // TableView
    private var posts: [BlogPost] = []
    // Matching contributions.
    private func fetchPosts() {
        print("Fetching posts...")
        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            print("Found \(posts.count) posts")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    // Check back on the number of posts to display.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    // View a list of posts.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl, author: post.author, created: post.timestamp, like_count: post.like_count, dislike_count: post.dislike_count))
        return cell
    }
    // return 100
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    // email
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        var isOwnedByCurrentUser = false
        if let email = UserDefaults.standard.string(forKey: "email") {
            isOwnedByCurrentUser = email == currentEmail
        }
        // PayWall
        if !isOwnedByCurrentUser {
            if IAPManager.shared.canViewPost {
                let vc = ViewPostViewController(
                    post: posts[indexPath.row],
                    isOwnedByCurrentUser: isOwnedByCurrentUser
                )
                vc.navigationItem.largeTitleDisplayMode = .never
                vc.title = "このコンテンツは信頼できません"
                navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = PayWallViewController()
                present(vc, animated: true)
            }
        }
        else {
            // Our post
            let vc = ViewPostViewController(
                post: posts[indexPath.row],
                isOwnedByCurrentUser: isOwnedByCurrentUser
            )
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "このコンテンツは信頼できません"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    // error-handling mandatory
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            let urlString = URL.absoluteString
            DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
                guard let user = user else {
                    return
                }
                self?.user = user
                if urlString == "WebLink" {
                    let web_link_url: String = (user.web_link ?? "") as String
                    let url = NSURL(string: web_link_url)
                    if url == nil {
                        return
                    }
                    else {
                        // Conditional branch if url is nil
                        if UIApplication.shared.canOpenURL(url! as URL){
                            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                        }
                    }
                }
                if urlString == "TwitterLink" {
                    let twitter_link_url: String = (user.twitter_link ?? "") as String
                    let url = NSURL(string: twitter_link_url)
                    if url == nil {
                        return
                    }
                    else {
                        // Conditional branch if url is nil
                        if UIApplication.shared.canOpenURL(url! as URL){
                            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
            return false
        }
}
// Set up a Profile View.
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Functions for retrieving images.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    // Functions for retrieving images.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        StorageManager.shared.uploadUserProfilePicture(
            email: currentEmail,
            image: image.resized(withPercentage: 0.1)
        ) { [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                // Update database
                DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { updated in
                    guard updated else {
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                }
            }
        }
    }
}

// .resized(withPercentage: 0.1)
