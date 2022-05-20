//
//  PlaceHolderTextView.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

import UIKit

@IBDesignable class PlaceHolderTextView: UITextView {
    // @IBInspectable
    @IBInspectable private var placeHolder: String = "" {
        willSet {
            self.placeHolderLabel.text = newValue
            self.placeHolderLabel.sizeToFit()
        }
    }
    // Setting up a pseudo placeholder body.
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)) // 任意の値を入れる
        label.lineBreakMode = .byWordWrapping // 折り返しの種類
        label.numberOfLines = 0
        label.font = self.font
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        label.backgroundColor = .clear
        self.addSubview(label)
        return label
    }()
    // deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        changeVisiblePlaceHolder()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }
    // Changing the string.
    private func changeVisiblePlaceHolder() {
        self.placeHolderLabel.alpha = (self.placeHolder.isEmpty || !self.text.isEmpty) ? 0.0 : 1.0
    }
    // Behaviour when changing strings.
    @objc private func textChanged(notification: NSNotification?) {
        changeVisiblePlaceHolder()
    }

}
