//
//  OtherProfileViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/04/21.
//

// You will be puzzled as to where the forms appear.
// As a padding element, there is no function, so a pseudo-element must be created.
// We could provide blank text labels or something to create an invisible space.

import UIKit
import SafariServices
import Foundation

class OtherProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
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
    // Load screen.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/2.0))
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
        let baseString = "WebサイトのリンクとTwitterのリンク"
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: "WebLink",
                                      range: NSString(string: baseString).range(of: "Webサイトのリンク"))
        attributedString.addAttribute(.link,
                                      value: "TwitterLink",
                                      range: NSString(string: baseString).range(of: "Twitterのリンク"))
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
        }
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
