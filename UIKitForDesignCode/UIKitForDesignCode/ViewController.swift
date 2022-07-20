//
//  ViewController.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/18.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var handbookCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handbookCollectionView.delegate = self
        handbookCollectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCell", for: indexPath) as! HandbookCollectionViewCell
        cell.titleLabel.text = "SwiftUI Handbook"
        cell.subtitleLabel.text = "20 HOURS - 30 SECTIONS"
        cell.descriptionLabel.text = "Learn about all the basics of SwiftUI"
        cell.gradient.colors = [UIColor.red.cgColor, UIColor.systemPink.cgColor]
        cell.logo.image = UIImage(named: "Logo React")
        cell.banner.image = UIImage(named: "Illustration 2")
        
        return cell
    }
    
    
}

