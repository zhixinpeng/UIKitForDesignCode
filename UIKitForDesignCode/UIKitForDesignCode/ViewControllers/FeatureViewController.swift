//
//  ViewController.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/18.
//

import UIKit
import Combine

class FeatureViewController: UIViewController {
    @IBOutlet var handbookCollectionView: UICollectionView!
    @IBOutlet var coursesTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var featuredTitleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var previewLabel: UILabel!
    @IBOutlet var handbooksLabel: UILabel!
    @IBOutlet var coursesLabel: UILabel!
    
    private var tokens: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handbookCollectionView.delegate = self
        handbookCollectionView.dataSource = self
        handbookCollectionView.layer.masksToBounds = false
        
        coursesTableView.delegate = self
        coursesTableView.dataSource = self
        coursesTableView.layer.masksToBounds = false
        
        coursesTableView.publisher(for: \.contentSize)
            .sink { contentSize in
                self.tableViewHeight.constant = contentSize.height
            }
            .store(in: &tokens)
        
        scrollView.delegate = self
        
        // Accessibility
        featuredTitleLabel.maximumContentSizeCategory = .accessibilityExtraLarge
        featuredTitleLabel.font = UIFont.preferredFont(for: .title1, weight: .bold)
        featuredTitleLabel.adjustsFontForContentSizeCategory = true
        
        infoLabel.maximumContentSizeCategory = .accessibilityMedium
        infoLabel.font = UIFont.preferredFont(for: .footnote, weight: .bold)
        infoLabel.adjustsFontForContentSizeCategory = true
        
        previewLabel.maximumContentSizeCategory = .accessibilityMedium
        previewLabel.font = UIFont.preferredFont(for: .footnote, weight: .regular)
        previewLabel.adjustsFontForContentSizeCategory = true
        
        handbooksLabel.maximumContentSizeCategory = .accessibilityMedium
        handbooksLabel.font = UIFont.preferredFont(for: .footnote, weight: .semibold)
        handbooksLabel.adjustsFontForContentSizeCategory = true
        
        coursesLabel.maximumContentSizeCategory = .accessibilityMedium
        coursesLabel.font = UIFont.preferredFont(for: .footnote, weight: .semibold)
        coursesLabel.adjustsFontForContentSizeCategory = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let presentViewController = segue.destination as? CoursesViewController, let course = sender as? Course {
            presentViewController.course = course
        }
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

extension FeatureViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoursesTableCell", for: indexPath) as! CoursesTableViewCell
        let course = courses[indexPath.section]
        
        cell.titleLabel.text = course.courseTitle
        cell.subtitleLabel.text = course.courseSubtitle
        cell.descriptionLabel.text = course.courseDescription
        cell.courseBackground.image = course.courseBackground
        cell.courseBanner.image = course.courseBanner
        cell.courseLogo.image = course.courseIcon
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCourse = courses[indexPath.section]
        performSegue(withIdentifier: "presentCourse", sender: selectedCourse)
    }
}

extension FeatureViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalScrollHeight = scrollView.contentSize.height
        let lastScrollYPosition = scrollView.contentOffset.y
        let percentage = lastScrollYPosition / totalScrollHeight
        
        if percentage <= 0.15 {
            self.title = "Featured"
        } else if percentage <= 0.32 {
            self.title = "Handbooks"
        } else {
            self.title = "Courses"
        }
    }
}
