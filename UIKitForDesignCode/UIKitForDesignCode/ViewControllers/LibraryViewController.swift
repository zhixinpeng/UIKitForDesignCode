//
//  LibraryViewController.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/22.
//

import UIKit
import Combine
import SwiftUI

class LibraryViewController: UIViewController {
    @IBOutlet var sessionsCollectionView: UICollectionView!
    @IBOutlet var topicTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var certificatesLabel: UILabel!
    
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
        
        // Accessibility
        titleLabel.maximumContentSizeCategory = .accessibilityExtraLarge
        titleLabel.font = UIFont.preferredFont(for: .title2, weight: .bold)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        certificatesLabel.maximumContentSizeCategory = .accessibilityMedium
        certificatesLabel.font = UIFont.preferredFont(for: .footnote, weight: .semibold)
        certificatesLabel.adjustsFontForContentSizeCategory = true
    }
    
    @IBSegueAction func createCertificateView(_ coder: NSCoder) -> UIViewController? {
        let vc = UIHostingController(coder: coder, rootView: CertificateView())
        vc?.view.backgroundColor = .clear
        return vc
    }
    
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionsCollectionViewCell
        let section = sections[indexPath.item]
        
        cell.titleLabel.text = section.sectionTitle
        cell.subtitleLabel.text = section.sectionSubtitle
        cell.logo.image = section.sectionIcon
        cell.banner.image = section.sectionBanner
        
        return cell
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as! TopicTableViewCell
        let setting = librarySettings[indexPath.row]
        
        cell.topicLogo.image = UIImage(systemName: setting.topicSymbol)
        cell.topicLabel.text = setting.topicName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
