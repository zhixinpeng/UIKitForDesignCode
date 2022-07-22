//
//  LibraryViewController.swift
//  UIKit for iOS 15
//
//  Created by Sai Kambampati on 1/8/22.
//

import UIKit
import Combine
import SwiftUI

class LibraryViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var certificatesLabel: UILabel!
    @IBOutlet var sectionsCollectionView: UICollectionView!
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!

    private var tokens: Set<AnyCancellable> = []
    private var lastScrollYPosition: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collection View
        self.sectionsCollectionView.delegate = self
        self.sectionsCollectionView.dataSource = self
        self.sectionsCollectionView.layer.masksToBounds = false

        // Table View
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuTableView.layer.masksToBounds = true
        
        // Subscribe to table view changes
        menuTableView
            .publisher(for: \.contentSize)
            .sink { contentSize in
            self.tableViewHeight.constant = contentSize.height + 10
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
    
    @IBSegueAction func createCertificatesView(_ coder: NSCoder) -> UIViewController? {
        let v = UIHostingController(coder: coder, rootView: CertificateView())
        v!.view.backgroundColor = .clear
        return v
    }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionCollectionViewCell
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
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! TopicTableViewCell
        let item = menu[indexPath.row]
        
        cell.topicLabel.text = item.topicName
        cell.topicLogo.image = UIImage(systemName: item.topicSymbol)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
