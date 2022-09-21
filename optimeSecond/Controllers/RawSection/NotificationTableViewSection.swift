//
//  NotificationTableViewCell.swift
//  optimeSecond
//
//  Created by Nyazik Byashimova on 17.09.2022.
//

import UIKit

class NotificationTableViewSection: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var readView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 8.0
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}


