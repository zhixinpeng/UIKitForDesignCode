//
//  CoursesTableViewCell.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/20.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(named: "Shadow")!.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}