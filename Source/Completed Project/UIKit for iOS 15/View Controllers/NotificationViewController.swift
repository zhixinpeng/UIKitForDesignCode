//
//  NotificationViewController.swift
//  UIKit for iOS 15
//
//  Created by Sai Kambampati on 1/9/22.
//

import UIKit
import Combine
import FirebaseFirestore

class NotificationViewController: UIViewController {
    
    @IBOutlet var cardView: CustomView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!

    var dataSource: UITableViewDiffableDataSource<TBSection, NotificationModel>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<TBSection, NotificationModel>! = nil
    private var tokens: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
                
        // Configure Data Source
        self.dataSource = UITableViewDiffableDataSource<TBSection, NotificationModel>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, item: NotificationModel) -> NotificationTableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell else {
                fatalError("Can't create new cell")
            }
            
            cell.titleLabel.text = item.title
            cell.messageLabel.text = item.message
            cell.subtitleLabel.text = item.subtitle.uppercased()
            cell.notificationImageView.image = UIImage(named: item.image)
            
            return cell
            
        }
        self.dataSource.defaultRowAnimation = .fade

        // Load Firestore Data
        Task {
            do {
                try await self.loadData()
                self.cardView.alpha = 1
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        // Subscribe to table view changes
        tableView
            .publisher(for: \.contentSize)
            .sink { contentSize in
            self.tableViewHeight.constant = contentSize.height + 10
        }
        .store(in: &tokens)
    }
    
    func loadData() async throws {
        currentSnapshot = NSDiffableDataSourceSnapshot<TBSection, NotificationModel>()
        currentSnapshot.appendSections([.main])

        let docs = try await Firestore.firestore()
            .collection("notifications")
            .order(by: "sentAt", descending: false)
            .getDocuments()
        var notifications = [NotificationModel]()

        for docSnapshot in docs.documents {
            let data = try docSnapshot.data(as: NotificationModel.self)
            notifications.append(data!)
        }

        self.currentSnapshot.appendItems(notifications, toSection: .main)
        await self.dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
