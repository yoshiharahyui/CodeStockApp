//
//  PlaceTextView.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/05/19.
//

import Foundation
import UIKit

class HintTextView: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged), name: UITextView.textDidChangeNotification, object: nil)
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
                        placeHolderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 7),
                        placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                        placeHolderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5)
        ])
    }
    
    var placeHolder: String = "" {
            willSet {
                self.placeHolderLabel.text = newValue
                self.placeHolderLabel.sizeToFit()
            }
        }

        private lazy var placeHolderLabel: UILabel = {
            let label = UILabel()
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.font = self.font
            label.textColor = .gray
            label.backgroundColor = .clear
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            return label
        }()
    
    @objc private func textDidChanged() {
            let shouldHidden = self.placeHolder.isEmpty || !self.text.isEmpty
            self.placeHolderLabel.alpha = shouldHidden ? 0 : 1
        }

}
