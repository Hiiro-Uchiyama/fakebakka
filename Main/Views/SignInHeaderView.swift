//
//  SignInHeaderView.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

import UIKit

class SignInHeaderView: UIView {
    // Image placement.
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Fakebakka_v2"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
    // Initialisation of frames
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(imageView)
    }
    // initialization method
    required init?(coder: NSCoder) {
        fatalError()
    }
    // UITextField
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = width/4
        imageView.frame = CGRect(x: (width-size)/2, y: 45.5, width: size, height: size)
    }
}
