//
//  NotificationTableViewCell.swift
//  UIKit for iOS 15
//
//  Created by Sai Kambampati on 1/10/22.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var notificationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Accessibility
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.maximumContentSizeCategory = .extraExtraLarge
        titleLabel.font = UIFont.preferredFont(for: .headline, weight: .bold)
        
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.maximumContentSizeCategory = .extraLarge
        subtitleLabel.font = UIFont.preferredFont(for: .caption1, weight: .semibold)
        
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.maximumContentSizeCategory = .extraLarge
        messageLabel.font = UIFont.preferredFont(for: .caption1, weight: .regular)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
