//
//  ViewController.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/18.
//

import UIKit

class FeatureViewController: UIViewController {
    @IBOutlet var handbookCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handbookCollectionView.delegate = self
        handbookCollectionView.dataSource = self
        handbookCollectionView.layer.masksToBounds = false
    }
}

extension FeatureViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return handbooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCell", for: indexPath) as! HandbookCollectionViewCell
        let handbook = handbooks[indexPath.item]
        cell.titleLabel.text = handbook.courseTitle
        cell.subtitleLabel.text = handbook.courseSubtitle
        cell.descriptionLabel.text = handbook.courseDescription
        cell.gradient.colors = handbook.courseGradient
        cell.logo.image = handbook.courseIcon
        cell.banner.image = handbook.courseBanner
        
        return cell
    }
    
    
}

