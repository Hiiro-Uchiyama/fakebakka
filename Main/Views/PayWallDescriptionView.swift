//
//  PayWallDescriptionView.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

import UIKit

class PayWallDescriptionView: UIView {
    // Add description Label.
    private let descriptorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.numberOfLines = 0
        label.text = "Join Thoughts Premium to read unlimited articles and browse thousands of posts."
        return label
    }()
    // Set the price Label.
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 1
        label.text = "$4.99 / month"
        return label
    }()
    // initialization method
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(priceLabel)
        addSubview(descriptorLabel)
    }
    // Initialisation method.
    required init?(coder: NSCoder) {
        fatalError()
    }
    // Display layout.
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptorLabel.frame = CGRect(x: 20, y: 0, width: width-40, height: height/2)
        priceLabel.frame = CGRect(x: 20, y: height/2, width: width-40, height: height/2)
    }
}
