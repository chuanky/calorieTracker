//
//  customCell.swift
//  imagepicker
//
//  Created by Miao Gao on 2018/11/24.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation
import UIKit

class customCell: UITableViewCell {
    
    var message: String?
    var mainImage: UIImage?
    
    var messageView: UITextView = {
        var textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // initialization function
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mainImageView)
        self.addSubview(messageView)
        
        // 排版
        
//        // 左右版
//        //1. image
//        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        mainImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        mainImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        //2. message
//        messageView.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor).isActive = true
//        messageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        messageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
       
        //上下版
        //1. image
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.messageView.topAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        //2. message
        messageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        messageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let message = message {
            messageView.text = message
        }
        if let image = mainImage {
            mainImageView.image = image
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
