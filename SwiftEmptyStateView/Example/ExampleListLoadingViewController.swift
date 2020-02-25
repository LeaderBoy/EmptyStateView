//
//  ExampleListLoadingViewController.swift
//  SwiftEmptyStateView
//
//  Created by 杨志远 on 2020/2/24.
//  Copyright © 2020 BaQiWL. All rights reserved.
//

import UIKit

class ExampleListLoadingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.emptyDataSource = self
        tableView.emptyDelegate = self
        tableView.tableFooterView = UIView()
        load()
    }
    
    func load() {
        // 2.start loading
        tableView.reloadState(.loading)

        // 3.simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            /// 4.reload state
            self.tableView.reloadState(.error(.networkUnReachable))
        }
    }

}

protocol ListLoading {}

extension ExampleDefault where Self : ListLoading {
    func emptyCustomView(for state: EmptyState) -> UIView? {
        if state == .loading {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "list_loading"))
            return imageView
        }
        return nil
    }
    
    func emptyLayout(in customView: UIView, for state: EmptyState) -> EmptyStateLayout? {
        return .fullSafeArea(edges: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: -15))
    }
    
    func emptyViewBackgroundColor(for state: EmptyState) -> UIColor? {
        return .white
    }
}

extension ExampleListLoadingViewController : ExampleDefault {}
extension ExampleListLoadingViewController : ListLoading {}

extension ExampleListLoadingViewController : EmptyStateDelegate {
    func emptyButtonClicked(for state: EmptyState) {
        load()
    }
}

extension ExampleListLoadingViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "id")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "id")
        }
        
        return cell!
    }
}
