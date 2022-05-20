//
//  PostPreviewTableViewCell.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/18.
//

import UIKit

// VIEW to see contributions
class PostPreviewTableViewCellViewModel {
    let title: String
    let imageUrl: URL?
    var imageData: Data?
    let author: String
    let created: String
    let like_count: Int
    let dislike_count: Int
    // initialization method
    init(title: String, imageUrl: URL?, author: String, created: String, like_count: Int, dislike_count: Int) {
        self.title = title
        self.imageUrl = imageUrl
        self.author = author
        self.created = created
        self.like_count = like_count
        self.dislike_count = dislike_count
    }
}
// element (e.g. in array)
class PostPreviewTableViewCell: UITableViewCell {
    static let identifier = "PostPreviewTableViewCell"
    // Functions for image display
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    // title label
    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 16.5)
        return label
    }()
    // author label
    private let postAuthorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 12.5)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    // created label
    private let postCreatedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 12.5)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    // like_count label
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 12.5)
        return label
    }()
    // dislike_count label
    private let dislikeCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Charter-Roman", size: 12.5)
        return label
    }()
    // initialization method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
        contentView.addSubview(postTitleLabel)
        contentView.addSubview(postAuthorLabel)
        contentView.addSubview(postCreatedLabel)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(dislikeCountLabel)
    }
    // Colour designation
    required init?(coder: NSCoder) {
        fatalError()
    }
    // Set the position and other settings.
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = CGRect(
            x: separatorInset.left,
            y: 5,
            width: contentView.height-10,
            height: contentView.height-10
        )
        postTitleLabel.frame = CGRect(
            x: postImageView.right+8.5,
            y: 0,
            width: contentView.width-5-separatorInset.left-postImageView.width-10,
            height: contentView.height-50
        )
        postAuthorLabel.frame = CGRect(
            x: postImageView.right+8.5,
            y: contentView.bottom-35,
            width: contentView.width-5-separatorInset.left-postImageView.width-10,
            height: 13.5
        )
        postCreatedLabel.frame = CGRect(
            x: postImageView.right+8.5,
            y: contentView.bottom-20,
            width: contentView.width-5-separatorInset.left-postImageView.width-10,
            height: 13.5
        )
        likeCountLabel.frame = CGRect(
            x: postImageView.right+8.5,
            y: contentView.bottom-35,
            width: contentView.width-5-separatorInset.left-postImageView.width-10,
            height: 13.5
        )
        dislikeCountLabel.frame = CGRect(
            x: postImageView.right+8.5,
            y: contentView.bottom-20,
            width: contentView.width-5-separatorInset.left-postImageView.width-10,
            height: 13.5
        )
    }
    // Insert title and image.
    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
        postAuthorLabel.text = nil
        postCreatedLabel.text = nil
    }
    // Data transfer.
    func configure(with viewModel: PostPreviewTableViewCellViewModel) {
        postTitleLabel.text = viewModel.title
        postAuthorLabel.text = viewModel.author
        postCreatedLabel.text = viewModel.created
        likeCountLabel.text = "GoodFake: " + String(viewModel.like_count)
        dislikeCountLabel.text = "BadFake: " + String(viewModel.dislike_count)
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageUrl {
            // Fetch image & cache
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
