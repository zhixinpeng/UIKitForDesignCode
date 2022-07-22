//
//  NotificationsViewController.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/22.
//

import UIKit
import Combine
import FirebaseFirestore

class NotificationsViewController: UIViewController {
    @IBOutlet var cardView: CustomView!
    @IBOutlet var notificationTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    private var tokens: Set<AnyCancellable> = []
    
    private var dataSource: UITableViewDiffableDataSource<TBSection, NotificationModel>! = nil
    private var currentSnapshot: NSDiffableDataSourceSnapshot<TBSection, NotificationModel>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationTableView.delegate = self
        notificationTableView.publisher(for: \.contentSize)
            .sink { contentSize in
                self.tableViewHeight.constant = contentSize.height
            }
            .store(in: &tokens)
        
        self.dataSource = UITableViewDiffableDataSource<TBSection,NotificationModel>(tableView: notificationTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationTableViewCell else {
                fatalError("Can't create a new cell")
            }
            
            cell.titleLabel.text = itemIdentifier.title
            cell.subtitleLabel.text = itemIdentifier.subtitle
            cell.descriptionLabel.text = itemIdentifier.message
            cell.courseLogo.image = UIImage(named: itemIdentifier.image)
            
            return cell
        })
        
        self.dataSource.defaultRowAnimation = .fade
        
        Task {
            do {
                try await loadData()
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func loadData() async throws {
        currentSnapshot = NSDiffableDataSourceSnapshot<TBSection, NotificationModel>()
        currentSnapshot.appendSections([.main])
        
        let docs = try await Firestore.firestore().collection("notifications")
            .order(by: "sentAt", descending: true)
            .getDocuments()
        var notifications = [NotificationModel]()
        
        for snapshot in docs.documents {
            let data = try snapshot.data(as: NotificationModel.self)
            notifications.append(data)
        }
        
        currentSnapshot.appendItems(notifications, toSection: .main)
        await self.dataSource.apply(currentSnapshot, animatingDifferences: true)
        
        DispatchQueue.main.async {
            self.cardView.alpha = 1
        }
    }
}

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
