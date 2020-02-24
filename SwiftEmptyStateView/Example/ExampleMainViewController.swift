//
//  ExampleMainViewController.swift
//  SwiftEmptyStateView
//
//  Created by 杨志远 on 2020/2/21.
//  Copyright © 2020 BaQiWL. All rights reserved.
//

import UIKit

struct Example {
    let state : EmptyState
    let title : String
}

class ExampleMainViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var dataSource : [Example] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyConfigue()
        loadSuccess()
    }
    
    func emptyConfigue() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        // 1.become emptyDatasource
        tableView.emptyDataSource = self
    }
    
    func loadSuccess() {
        // 2.start loading
        tableView.reloadState(.loading)
        // 3.simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dataSource += [Example(state: .error(.failed(nil)), title: "Simulate load failed"),
                Example(state: .error(.timeout), title: "Simulate request timeout"),
                Example(state: .error(.networkUnReachable), title: "Simulate network unreachable"),
                Example(state: .emptyData, title: "Simulate empty datasource"),
                Example(state: .custom, title: "Custom loading")

            ]
            /// 4.loading success
            self.tableView.reloadState(.success)
            self.tableView.reloadData()
        }
    }
}

extension ExampleMainViewController : ExampleDefault {
    func emptyViewShouldFadeOut(for state: EmptyState) -> Bool {
        return true
    }
}

extension ExampleMainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = dataSource[indexPath.row].state
        
        if case .custom = state {
            let controller = ExampleCustomLoadingViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = ExampleStateViewController()
            controller.state = state
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}

extension ExampleMainViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "id")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "id")
        }
        cell!.textLabel?.text = dataSource[indexPath.row].title
        return cell!
    }
}
