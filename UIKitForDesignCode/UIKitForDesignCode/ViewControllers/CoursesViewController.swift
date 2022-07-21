//
//  CoursesViewController.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/20.
//

import UIKit
import Combine

class CoursesViewController: UIViewController {
    var course: Course?
    private var tokens: Set<AnyCancellable> = []

    @IBOutlet var sectionTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var bannerImage: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var iconImageView: CustomImageView!
    @IBOutlet var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionTableView.delegate = self
        sectionTableView.dataSource = self

        sectionTableView.publisher(for: \.contentSize)
            .sink { contentSize in
                self.tableViewHeight.constant = contentSize.height
            }
            .store(in: &tokens)
        
        self.iconImageView.image = course?.courseIcon
        self.bannerImage.image = course?.courseBanner
        self.backgroundImage.image = course?.courseBackground
        self.titleLabel.text = course?.courseTitle
        self.subtitleLabel.text = course?.courseSubtitle
        self.descriptionLabel.text = course?.courseDescription
        self.authorLabel.text = "Taught by \(course?.courseAuthor?.formatted(.list(type: .and, width: .standard)) ?? "Angus")"
        
        let menu = UIMenu(title: "Course Options", options: .displayInline, children: [
            UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), handler: { _ in
                
            }),
            UIAction(title: "Take Test", image: UIImage(systemName: "highlighter"), handler: { _ in
                
            }),
            UIAction(title: "Download", image: UIImage(systemName: "square.and.arrow.down"), handler: { _ in
                
            }),
            UIAction(title: "Forums", image: UIImage(systemName: "chevron.left.forwardslash.chevron.right"), handler: { _ in
                
            })
        ])
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.menu = menu
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.course?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionTableViewCell
        if let selectedCourse = course {
            let selectedSection = selectedCourse.sections![indexPath.row]
            cell.titleLabel.text = selectedSection.sectionTitle
            cell.subtitleLabel.text = selectedSection.sectionSubtitle
            cell.descriptionLabel.text = selectedSection.sectionDescription
            cell.courseLogo.image = selectedSection.sectionIcon
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
