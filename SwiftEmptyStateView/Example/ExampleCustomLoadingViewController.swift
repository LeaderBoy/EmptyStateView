//
//  ExampleCustomLoadingViewController.swift
//  SwiftEmptyStateView
//
//  Created by 杨志远 on 2020/2/21.
//  Copyright © 2020 BaQiWL. All rights reserved.
//

import UIKit

class ExampleCustomLoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
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
            self.view.reloadState(.error(.networkUnReachable))
        }
    }
}

extension ExampleCustomLoadingViewController : LogoLoading {}

extension ExampleCustomLoadingViewController : EmptyStateDelegate {
    func emptyButtonClicked(for state: EmptyState) {
        load()
    }
}

protocol LogoLoading : EmptyStateDatasource {}

extension LogoLoading {
    func emptyCustomView(for state: EmptyState) -> UIView? {
        if state == .loading {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .lightText
            let flashView = FlashLayerView(with: "Logo Name")
            flashView.sizeToFit()
            backgroundView.addSubview(flashView)
            flashView.centerlayout(to: backgroundView, offset: .zero)
            return backgroundView
        }
        return nil
    }
}
