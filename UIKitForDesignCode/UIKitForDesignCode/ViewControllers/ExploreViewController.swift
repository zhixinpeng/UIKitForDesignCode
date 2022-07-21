//
//  ExploreViewController.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/21.
//

import UIKit
import Combine

class ExploreViewController: UIViewController {
    @IBOutlet var sessionsCollectionView: UICollectionView!
    @IBOutlet var topicTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var popularCollectionView: UICollectionView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var topicsLabel: UILabel!
    @IBOutlet var popularLabel: UILabel!
    
    private var tokens: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionsCollectionView.delegate = self
        sessionsCollectionView.dataSource = self
        sessionsCollectionView.layer.masksToBounds = false
        
        topicTableView.delegate = self
        topicTableView.dataSource = self
        topicTableView.layer.masksToBounds = false
        
        topicTableView.publisher(for: \.contentSize)
            .sink { contentSize in
                self.tableViewHeight.constant = contentSize.height
            }
            .store(in: &tokens)
        
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.layer.masksToBounds = false
        
        // Accessibility
        titleLabel.maximumContentSizeCategory = .accessibilityExtraLarge
        titleLabel.font = UIFont.preferredFont(for: .title2, weight: .bold)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        topicsLabel.maximumContentSizeCategory = .accessibilityMedium
        topicsLabel.font = UIFont.preferredFont(for: .footnote, weight: .semibold)
        topicsLabel.adjustsFontForContentSizeCategory = true
        
        popularLabel.maximumContentSizeCategory = .accessibilityMedium
        popularLabel.font = UIFont.preferredFont(for: .footnote, weight: .semibold)
        popularLabel.adjustsFontForContentSizeCategory = true
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == sessionsCollectionView ? sections.count : handbooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sessionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionsCollectionViewCell
            let section = sections[indexPath.item]
            
            cell.titleLabel.text = section.sectionTitle
            cell.subtitleLabel.text = section.sectionSubtitle
            cell.logo.image = section.sectionIcon
            cell.banner.image = section.sectionBanner
            
            return cell
        } else {
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
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as! TopicTableViewCell
        let topic = topics[indexPath.row]
        
        cell.topicLogo.image = UIImage(systemName: topic.topicSymbol)
        cell.topicLabel.text = topic.topicName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
