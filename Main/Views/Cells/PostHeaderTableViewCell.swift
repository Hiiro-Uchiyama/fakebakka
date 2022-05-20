//
//  PostHeaderTableViewCell.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

import UIKit

class PostHeaderTableViewCellViewModel {
    // insertable data
    let imageUrl: URL?
    var imageData: Data?
    // Initialisation with regard to image data.
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
}
// Configuration of elements
class PostHeaderTableViewCell: UITableViewCell {
    static let identifier = "PostHeaderTableViewCell"
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    // Override initialisation methods.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
    }
    // initialization method
    required init?(coder: NSCoder) {
        fatalError()
    }
    // Set layout details.
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = CGRect(
            x: 16.5,
            y: 0,
            width: contentView.width-34.5,
            height: contentView.height
        )
    }
    // Prepare for display.
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    // Display.
    func configure(with viewModel: PostHeaderTableViewCellViewModel) {
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
