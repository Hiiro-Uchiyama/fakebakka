//
//  HomeViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

// I want to increase the number of pages and make them in order of liking or surprise.
// It's too real, man. I want a button that says 'Good Fake' or a button that says 'Good Fake'.
// And, safely, I want a comment function.
// In the meantime, I would like to improve the functional aspects of the design, well, a little later.
// Let's make it up before Ayaka's development is finished.
// A user information change page would be considered acceptable.
// It would be better to include an image resizing process.
// I want to be able to go to people's pages.
// Variable element size.
// I want to create links to Twitter and so on.
// For some reason, articles are slow to load on the home page.
// If any problems arise, try to indicate them on the screen.
// A little more usability regarding reloading and fetching.
// I feel like it's a different form.
// The position of the like button and other buttons is obtrusive.
// Images are a little slow to load and display.
// If there is no self-introduction, a text should be provided instead.
// Connect with people's information
// Prevent users from logging out without permission.
// Unable to reload information
// Increase the number of items
// Add section titles to improve appearance.

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Drawing of buttons
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.tintColor = .white
        button.setImage(UIImage(systemName: "pencil",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 28.5, weight: .regular)),
                        for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5.5
        return button
    }()
    // Table view settings.
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        return tableView
    }()
    let sectionArry: [String] = [
        "Fake News",
    ]
    // Loading of views.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        setUpReportButton()
        fetchAllPosts()
    }
    // Set up a button to create a post
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composeButton.frame = CGRect(
            x: view.frame.width - 88,
            y: view.frame.height - 88 - view.safeAreaInsets.bottom,
            width: 60,
            height: 60
        )
        tableView.frame = CGRect(origin: .zero, size: view.bounds.size)
    }
    // Do first.
    // Maybe we could try not to call them every time.
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      tableView.reloadData()
    }
    // Installation of a sign-out button.
    private func setUpReportButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "報告",
            style: .done,
            target: self,
            action: #selector(didTapReportButton)
        )
    }
    // Page to create a contribution.
    @objc private func didTapReportButton() {
        // Building a reporting model
        let vc = PostReportViewController()
        vc.title = "報告"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    // Page to create a contribution.
    @objc private func didTapCreate() {
        animateView(composeButton)
        let vc = CreateNewPostViewController()
        vc.title = "フェイクを流す"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    // Retrieve the post.
    private var posts: [BlogPost] = []
    // Fetching contributions.
    private func fetchAllPosts() {
        print("Fetching home feed...")
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
    // Specify section title.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArry[section]
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
        // guard IAPManager.shared.canViewPost else {
        //     let vc = PayWallViewController()
        //     present(vc, animated: true, completion: nil)
        //     return
        // }
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "このコンテンツは信頼できません"
        navigationController?.pushViewController(vc, animated: true)
    }
    // reporting function
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
