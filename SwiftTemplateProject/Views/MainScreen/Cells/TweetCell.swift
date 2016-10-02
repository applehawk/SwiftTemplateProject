//
//  MainScreenMainCell.swift
//  SwiftTemplateProject
//
//  Created by Hawk on 29/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var minimalHeightRow: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureForModel(indexPath: IndexPath, tweet: Tweet ) {
        if(indexPath.row % 2 == 0) {
            backgroundColor = UIColor.gray
            titleLabel.textColor = UIColor.white
        } else {
            backgroundColor = UIColor.white
            titleLabel.textColor = UIColor.black
        }
        self.titleLabel.text = tweet.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.width
    }
}
