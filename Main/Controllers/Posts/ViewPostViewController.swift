//
//  ViewPostViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

// I want to change the position of the title or something.
// detailTextLavel.text?
// It would be better to be able to see other contributions.
// Should I crack it open or something?
// Data loading may need to be reviewed.
// I thought it would be a good idea to add Google account verification or something.
// For the life of me, I can't figure it out, so let's allow for bugs.
// Have the code in place and be well prepared for the production environment.
// Establish branding to make it more scarce.
// Create a reporting function.
// Fake news is not going away.
// It would be a good idea to make them list their posts in the same way as their profile.
// HeaderView is not large enough.
// Posting of advertising models on footer
// Improved data acquisition performance
// It would be good to improve performance.
// Delegate.
// Adding elements to the footer and changing the logo
// Color of the form's border
// pop-up
// Road Related

import UIKit
import FirebaseAuth

class ViewPostViewController: UITabBarController, UITableViewDataSource, UITableViewDelegate {
    // Data acquisition.
    private let post: BlogPost
    private let isOwnedByCurrentUser: Bool
    private let user = Auth.auth().currentUser
    private let isPushLike = false
    private let isPushDisLike = false
    private let postImage = UIImageView()
    // initialisation
    init(post: BlogPost, isOwnedByCurrentUser: Bool = false) {
        self.post = post
        self.isOwnedByCurrentUser = isOwnedByCurrentUser
        super.init(nibName: nil, bundle: nil)
    }
    // initialisation
    required init?(coder: NSCoder) {
        fatalError()
    }
    var goodBarButtonItem: UIBarButtonItem!
    var notgoodBarButtonItem: UIBarButtonItem!
    // Table view settings
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        table.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        return table
    }()
    // Loading of views.
    // There is a problem with object overlap.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if !isOwnedByCurrentUser {
            IAPManager.shared.logPostViewed()
        }
        goodBarButtonItem = UIBarButtonItem(title: "GoodFake", style: .done, target: self, action: #selector(tapGoodButton(_:)))
        notgoodBarButtonItem = UIBarButtonItem(title: "BadFake", style: .done, target: self, action: #selector(tapNotGoodButton(_:)))
        self.navigationItem.rightBarButtonItems = [goodBarButtonItem,notgoodBarButtonItem]
        view.addSubview(tableView)
        // view.sendSubviewToBack(view)
        // view.bringSubviewToFront(view)
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableHeader()
        fetchAllPosts()
        getImage(pass: post.headerImageUrl, postImage: postImage)
        self.extendedLayoutIncludesOpaqueBars = true
    }
    // Load screen.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    // Retrieve and return an image
    func getImage(pass: URL?, postImage: UIImageView) {
            var result = UIImage()
            if let url = pass {
                let request = URLRequest(url: url)
                let session = URLSession.shared
                let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                    DispatchQueue.main.async() {
                        if let data = data, let image = UIImage(data: data) {
                            result = image
                            self.postImage.image = result
                        }
                    }
                }
                task.resume()
            }
        }
    // Settings relating to the display area in the centre of the screen.
    private func setUpTableHeader() {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        // Profile picture
        postImage.layer.masksToBounds = true
        postImage.clipsToBounds = true
        postImage.contentMode = .scaleAspectFill
        postImage.frame = CGRect(
            x: 20,
            y: 10,
            width: view.width-40,
            height: 250
        )
        headerView.addSubview(postImage)
        // Author_name
        let titleLabel = UILabel(frame: CGRect(x: 20, y: postImage.bottom+20, width: view.width-40, height: 20.5))
        titleLabel.text = post.title
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Charter-Roman", size: 18.5)
        headerView.addSubview(titleLabel)
        // Text
        let textLabel = UILabel(frame: CGRect(x: 20, y: titleLabel.bottom+20, width: view.width-40, height: 16.5))
        textLabel.text = post.text
        textLabel.textColor = .black
        textLabel.numberOfLines = 0
        textLabel.sizeToFit()
        textLabel.font = UIFont(name: "Charter-Roman", size: 15.5)
        headerView.addSubview(textLabel)
        // author_name
        let author_nameLabel = UILabel(frame: CGRect(x: 20, y: textLabel.bottom+20, width: view.width-40, height: 16.5))
        author_nameLabel.text = "著者名: " + post.author
        author_nameLabel.textColor = .black
        author_nameLabel.numberOfLines = 0
        author_nameLabel.sizeToFit()
        author_nameLabel.font = UIFont(name: "Charter-Roman", size: 15.5)
        headerView.addSubview(author_nameLabel)
        // author_description
        let author_descriptionLabel = UILabel(frame: CGRect(x: 20, y: author_nameLabel.bottom+20, width: view.width-40, height: 16.5))
        author_descriptionLabel.text = "著者詳細" + post.author_description
        author_descriptionLabel.textColor = .black
        author_descriptionLabel.numberOfLines = 0
        author_descriptionLabel.sizeToFit()
        author_descriptionLabel.font = UIFont(name: "Charter-Roman", size: 12.5)
        headerView.addSubview(author_descriptionLabel)
        // publisher
        let publisherLabel = UILabel(frame: CGRect(x: 20, y: author_descriptionLabel.bottom+20, width: view.width-40, height: 16.5))
        publisherLabel.text = "出版社名: " + post.publisher
        publisherLabel.textColor = .black
        publisherLabel.numberOfLines = 0
        publisherLabel.sizeToFit()
        publisherLabel.font = UIFont(name: "Charter-Roman", size: 15.5)
        headerView.addSubview(publisherLabel)
        // publisher_description
        let publisher_descriptionLabel = UILabel(frame: CGRect(x: 20, y: publisherLabel.bottom+20, width: view.width-40, height: 16.5))
        publisher_descriptionLabel.text = "出版社詳細: " + post.publisher_description
        publisher_descriptionLabel.textColor = .black
        publisher_descriptionLabel.numberOfLines = 0
        publisher_descriptionLabel.sizeToFit()
        publisher_descriptionLabel.font = UIFont(name: "Charter-Roman", size: 12.5)
        headerView.addSubview(publisher_descriptionLabel)
        // GoodFake or BadFake
        let good_badLabel = UILabel(frame: CGRect(x: 20, y: publisher_descriptionLabel.bottom+20, width: view.width-40, height: 16.5))
        good_badLabel.text = "GoodFake: " + String(post.like_count) + " BadFake: " + String(post.dislike_count)
        good_badLabel.textColor = .black
        good_badLabel.numberOfLines = 0
        good_badLabel.sizeToFit()
        good_badLabel.font = UIFont(name: "Charter-Roman", size: 12.5)
        headerView.addSubview(good_badLabel)
        // User
        let UserLink = UIButton(frame: CGRect(x: 20, y: good_badLabel.bottom+20, width: view.width-40, height: 16.5))
        UserLink.setTitle("編集者", for: .normal)
        UserLink.setTitleColor(UIColor.systemBlue, for: .normal)
        UserLink.titleLabel?.font = UIFont(name: "Charter-Roman", size: 15.5)
        UserLink.contentHorizontalAlignment = .left
        UserLink.addTarget(self, action: #selector(didTapUserLink), for: .touchUpInside)
        headerView.addSubview(UserLink)
        // Share
        let ShareLink = UIButton(frame: CGRect(x: 20, y: UserLink.bottom+20, width: view.width-40, height: 16.5))
        ShareLink.setTitle("シェアリンク", for: .normal)
        ShareLink.setTitleColor(UIColor.systemBlue, for: .normal)
        ShareLink.titleLabel?.font = UIFont(name: "Charter-Roman", size: 15.5)
        ShareLink.contentHorizontalAlignment = .left
        ShareLink.addTarget(self, action: #selector(pushShareButton), for: .touchUpInside)
        headerView.addSubview(ShareLink)
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height+(textLabel.height+author_descriptionLabel.height+publisher_descriptionLabel.height)-250)
    }
    @IBAction func pushShareButton(sender: AnyObject) {
        let text = "sample text"
        let sampleUrl = NSURL(string: "http://www.apple.com/")!
        let image = UIImage(named: "photo")!
        let items = [text, sampleUrl, image] as [Any]
        // UIActivityViewController
        let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // UIActivityViewController
        self.present(activityVc, animated: true, completion: nil)
    }
    // Page to create a contribution.
    @objc private func didTapUserLink() {
        let vc = OtherProfileViewController(currentEmail: post.email)
        vc.title = "編集者のプロフィール"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    // Do first.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Retrieve the post.
    private var posts: [BlogPost] = []
    // Fetching contributions.
    private func fetchAllPosts() {
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    // Create a TableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    // Create a TableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl, author: post.author, created: post.timestamp, like_count: post.like_count, dislike_count: post.dislike_count))
        return cell
    }
    // Set heightForRowAt.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    // Set didSelectRowAt.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        guard IAPManager.shared.canViewPost else {
            let vc = PayWallViewController()
            present(vc, animated: true, completion: nil)
            return
        }
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "このコンテンツは信頼できません"
        navigationController?.pushViewController(vc, animated: true)
    }
    // Button for sharing on Twitter.
    func shareOnTwitter() {
        // Create text to share.
        let text = post.title
        let hashTag = "#Fakebakka"
        let completedText = text + "\n" + hashTag
        // Encode the created text.
        let encodedText = completedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        // Connect the encoded text to a URL and open the URL to display the tweet screen.
        if let encodedText = encodedText,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url)
        }
    }
    // Method called when a UIButton is pressed.
    // There are certain rules for calling in.
    @objc func tapGoodButton(_ sender:UIButton) {
        let alert: UIAlertController = UIAlertController(title: "GoodFake", message: "このフェイクニュースに、あなたからGoodFakeを送ります", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            let user = Auth.auth().currentUser
            if let user = user {
                let currentEmail = user.email
                DatabaseManager.shared.insertBlogLike(
                    blogPost: self.post,
                    email: currentEmail!,
                    completion: { (error) in return })
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    // Method called when a UIButton is pressed.
    @objc func tapNotGoodButton(_ sender:UIButton) {
        let alert: UIAlertController = UIAlertController(title: "BadFake", message: "このフェイクニュースに、あなたからBadFakeを送ります", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            let user = Auth.auth().currentUser
            if let user = user {
                let currentEmail = user.email
                DatabaseManager.shared.insertBlogDisLike(
                    blogPost: self.post,
                    email: currentEmail!,
                    completion: { (error) in return })
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
