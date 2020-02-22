//
//  ViewController.swift
//  SwiftEmptyStateView
//
//  Created by 杨志远 on 2019/11/15.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupEmpty()
    }
    
    func setupEmpty() {
        emptyView.emptyDataSource = self
        emptyView.emptyDelegate = self
        emptyView.reloadState(.loading)
    }
    
    @IBAction func stateChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            emptyView.reloadState(.loading)
        case 1:
            emptyView.reloadState(.emptyData)
        case 2:
            emptyView.reloadState(.error(.networkUnReachable))
        case 3:
            emptyView.reloadState(.error(.timeout))
        case 4:
            emptyView.reloadState(.error(.failed(nil)))
        case 5:
            emptyView.reloadState(.success)
        default:
            break
        }
    }
    

}

extension ViewController : EmptyStateDatasource {}


extension ViewController : EmptyStateDelegate {
    func emptyButtonClicked(for state: EmptyState) {
        print("request")
        emptyView.reloadState(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("success")
            self.emptyView.reloadState(.success)
        }
    }
}
