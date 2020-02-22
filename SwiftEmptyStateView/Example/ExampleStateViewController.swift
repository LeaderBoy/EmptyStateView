//
//  ExampleStateViewController.swift
//  SwiftEmptyStateView
//
//  Created by 杨志远 on 2020/2/21.
//  Copyright © 2020 BaQiWL. All rights reserved.
//

import UIKit

class ExampleStateViewController: UIViewController {
    var state : EmptyState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 1.
        view.emptyDataSource = self
        view.emptyDelegate = self
        load()
    }
    
    func load() {
        // 2.start loading
        view.reloadState(.loading)
        // 3.simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            /// 4.reload state
            self.view.reloadState(self.state)
        }
    }
}

extension ExampleStateViewController : EmptyStateDatasource {}


extension ExampleStateViewController : EmptyStateDelegate {
    func emptyButtonClicked(for state: EmptyState) {
        if case .error(_) = state {
            load()
        }
    }
}
