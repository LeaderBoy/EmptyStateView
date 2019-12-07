
//
//  EmptyState.swift
//  CCDINews
//
//  Created by 杨志远 on 2019/9/26.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import Foundation
import UIKit

enum EmptyError {
    case networkUnReachable
    case timeout
    case failed
}

enum EmptyState : Equatable {
    case loading
    case error(_ error : EmptyError)
    case success
    case emptyData
    case custom
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading)       : return true
        case (.success, .success)       : return true
        case (.emptyData, .emptyData)   : return true
        case (.error(let l), .error(let r)) where l == r: return true
        case (.custom,.custom):return true
            case _: return false
        }
    }
}

protocol EmptyStateDelegate : class {
    func emptyButtonClicked(for state: EmptyState)
}
extension EmptyStateDelegate {
    func emptyButtonClicked(for state: EmptyState){}
}

protocol EmptyStateDatasource : class {
    
    func emptyImage(for state : EmptyState) -> UIImage?

    
    func emptyTitle(for state : EmptyState) -> String?
    func emptyAttributeTitle(for state : EmptyState) -> NSAttributedString?
    func emptyTitleColor(for state : EmptyState) -> UIColor?
    func emptyTitleFont(for state : EmptyState) -> UIFont?
    func emptyTitleAlpha(for state : EmptyState) -> CGFloat?
    
    
    func emptyButtonTitle(for state: EmptyState) -> String?
    func emptyButtonTitleColor(for state: EmptyState) -> UIColor?
    func emptyButtonTitleFont(for state: EmptyState) -> UIFont?
    func emptyButtonImage(for state: EmptyState) -> UIImage?
    func emptyButtonBorderColor(for state: EmptyState) -> UIColor?
    func emptyButtonBorderWidth(for state: EmptyState) -> CGFloat?

    
    func emptyCustomView(for state: EmptyState) -> UIView?
    func emptyVerticalSpacing(for state: EmptyState) -> CGFloat?
    func emptyAxis(for state: EmptyState) -> NSLayoutConstraint.Axis?
    func emptyAlignment(for state: EmptyState) -> UIStackView.Alignment?
    func emptyDistribution(for state: EmptyState) -> UIStackView.Distribution?
    func emptyShouldFadeOut(for state: EmptyState) -> Bool?
    func emptyViewBackgroundColor(for state: EmptyState) -> UIColor?
    func emptyViewLayout(stackView : UIStackView,containerView : UIView, for state: EmptyState) -> EmptyStateLayout?
    func emptyViewLayoutEdgeInsets(for state: EmptyState) -> UIEdgeInsets?
}


private var EmptyDataSourceKey = 0
private var EmptyStateViewKey = 0
private var EmptyStateDelegateKey = 0


extension UIView {
    
    /// delegate for view
    var emptyDelegate: EmptyStateDelegate? {
        get {
            return objc_getAssociatedObject(self, &EmptyStateDelegateKey) as? EmptyStateDelegate
        }
        set {
            objc_setAssociatedObject(self, &EmptyStateDelegateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// datasource for view
    var emptyDataSource: EmptyStateDatasource? {
        get {
            return objc_getAssociatedObject(self, &EmptyDataSourceKey) as? EmptyStateDatasource
        }
        set {
            objc_setAssociatedObject(self, &EmptyDataSourceKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
        
    private var emptyStateView : EmptyStateView? {
        get {
            return objc_getAssociatedObject(self, &EmptyStateViewKey) as? EmptyStateView
        }
        set {
            objc_setAssociatedObject(self, &EmptyStateViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func emptyTitle(for state: EmptyState) -> String? {
        return emptyDataSource?.emptyTitle(for: state)
    }
    
    func emptyAttributeTitle(for state : EmptyState) -> NSAttributedString? {
        return emptyDataSource?.emptyAttributeTitle(for: state)
    }
    
    func emptyTitleColor(for state : EmptyState) -> UIColor? {
        return emptyDataSource?.emptyTitleColor(for: state)
    }
    
    func emptyTitleFont(for state : EmptyState) -> UIFont? {
        return emptyDataSource?.emptyTitleFont(for: state)
    }
    
    func emptyTitleAlpha(for state : EmptyState) -> CGFloat? {
        return emptyDataSource?.emptyTitleAlpha(for: state)
    }
    
    func emptyImage(for state: EmptyState) -> UIImage? {
        return emptyDataSource?.emptyImage(for: state)
    }
    
    func emptyButtonTitle(for state: EmptyState) -> String? {
        return emptyDataSource?.emptyButtonTitle(for: state)
    }
    
    func emptyButtonTitleColor(for state: EmptyState) -> UIColor? {
        return emptyDataSource?.emptyButtonTitleColor(for: state)
    }
    
    func emptyButtonTitleFont(for state: EmptyState) -> UIFont? {
        return emptyDataSource?.emptyButtonTitleFont(for: state)
    }
    
    func emptyButtonImage(for state: EmptyState) -> UIImage? {
        return emptyDataSource?.emptyButtonImage(for: state)
    }
    
    func emptyButtonBorderColor(for state: EmptyState) -> UIColor? {
        return emptyDataSource?.emptyButtonBorderColor(for: state)
    }
    
    func emptyButtonBorderWidth(for state: EmptyState) -> CGFloat? {
        return emptyDataSource?.emptyButtonBorderWidth(for: state)
    }
    
    func emptyButtonClicked(for state: EmptyState) {
        emptyDelegate?.emptyButtonClicked(for: state)
    }
    
    func emptyCustomView(for state: EmptyState) -> UIView? {
        return emptyDataSource?.emptyCustomView(for: state)
    }
    
    func emptyVerticalVSpacing(for state: EmptyState) -> CGFloat? {
        return emptyDataSource?.emptyVerticalSpacing(for: state)
    }
    
    func emptyAxis(for state: EmptyState) -> NSLayoutConstraint.Axis? {
        return emptyDataSource?.emptyAxis(for: state)
    }
    
    func emptyAlignment(for state: EmptyState) -> UIStackView.Alignment? {
        return emptyDataSource?.emptyAlignment(for: state)
    }
    
    func emptyDistribution(for state: EmptyState) -> UIStackView.Distribution? {
        return emptyDataSource?.emptyDistribution(for: state)
    }
    
    func emptyShouldFadeOut(for state: EmptyState) -> Bool? {
        return emptyDataSource?.emptyShouldFadeOut(for: state)
    }
    
    func emptyViewBackgroundColor(for state: EmptyState) -> UIColor?  {
        return emptyDataSource?.emptyViewBackgroundColor(for: state)
    }
    
    func emptyViewLayout(stackView : UIStackView,containerView : UIView, for state: EmptyState) -> EmptyStateLayout? {
        return emptyDataSource?.emptyViewLayout(stackView: stackView, containerView: containerView, for: state)
    }
    
    func emptyViewLayoutEdgeInsets(for state: EmptyState) -> UIEdgeInsets? {
        return emptyDataSource?.emptyViewLayoutEdgeInsets(for: state)
    }
        
}


extension UIView : EmptyStateDatasource {
    /// refresh with current state
    /// - Parameter state: current state
    func reloadState(_ state: EmptyState = .success) {
        // prevent main thread checker error
        DispatchQueue.main.async {
            if self.emptyDataSource != nil {
                if state == .success || (self.isScrollView() && self.items() != 0) {
                    self.remove(for: state)
                }else {
                    self.emptyLayout(for: state)
                }
            }else {
                fatalError("\(self) emptyDataSource must not be nil")
            }
        }
    }
    
    // convenience method for reloadState(.error)
    func errorReload( _ error : Error) {
        if error.isNotConnectedToInternet() {
            reloadState(.error(.networkUnReachable))
        }else if error.isTimeout() {
            reloadState(.error(.timeout))
        }else {
            reloadState(.error(.failed))
        }
    }
    
    /// 是否为列表视图
    private func isScrollView() -> Bool {
        return self is UITableView || self is UICollectionView
    }
    
    private func items() -> NSInteger {
        var itemsCount = 0
        if self is UITableView {
            let tableView = self as! UITableView
            
            if let dataSource = tableView.dataSource {
                if let sections = dataSource.numberOfSections?(in: tableView) {
                    for section in 0..<sections {
                        let rows = dataSource.tableView(tableView, numberOfRowsInSection: section)
                        itemsCount += rows
                    }
                }else {
                    for section in 0..<1 {
                        let rows = dataSource.tableView(tableView, numberOfRowsInSection: section)
                        itemsCount += rows
                    }
                }
                
            }
        }else if self is UICollectionView {
            let collectionView = self as! UICollectionView
            if let dataSource = collectionView.dataSource {
                if let sections = dataSource.numberOfSections?(in: collectionView) {
                    for section in 0..<sections {
                        let rows = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
                        itemsCount += rows
                    }
                }else {
                    for section in 0..<1 {
                        let rows = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
                        itemsCount += rows
                    }
                }
            }
        }
        return itemsCount
    }
    
    private func remove(for state : EmptyState) {
        if let stateView = emptyStateView {
            if let fade = self.emptyShouldFadeOut(for: state),fade {
                stateView.alpha = 1.0
                UIView.animate(withDuration: 0.25, animations: {
                    stateView.alpha = 0.0
                }) { _ in
                    stateView.removeFromSuperview()
                }
            }else {
                stateView.removeFromSuperview()
            }
        }
    }
    
    private func emptyLayout(for state : EmptyState) {
        if emptyStateView == nil {
            let emptyStateView = EmptyStateView()
            self.emptyStateView = emptyStateView
        }
        
        let view = emptyStateView!
        
        if let backgroundColor = emptyViewBackgroundColor(for: state) {
            view.backgroundColor = backgroundColor
        }
                
        if let axis = emptyAxis(for: state) {
            view.axis = axis
        }
        
        if let alignment = emptyAlignment(for: state) {
            view.alignment = alignment
        }
        
        if let distribution = emptyDistribution(for: state) {
            view.distribution = distribution
        }
        
        view.state = state
                
        if let customView = emptyCustomView(for: state) {
            view.stackView.isHidden = true
            view.customView.isHidden = false
            _ = view.customView.subviews.map{$0.removeFromSuperview()}
            view.customView.addSubview(customView)
            customView.translatesAutoresizingMaskIntoConstraints = false
            
            if let insets = emptyViewLayoutEdgeInsets(for: state) {
                customView.edges(to: view, insets: insets)
            }else {
                customView.edges(to: view)
            }
        }else {
            view.delegate = self.emptyDelegate
            
            view.stackView.isHidden = false
            view.customView.isHidden = true
            
            if let layout = emptyViewLayout(stackView: view.stackView, containerView: view, for: state) {
                view.layout = layout
            }else {
                view.layout = .full
            }
            
            if let space = emptyVerticalVSpacing(for: state) {
                view.stackView.spacing = space
            }
            
            if let image = emptyImage(for: state) {
                view.imageView.isHidden = false
                view.imageView.image = image
            }else {
                view.imageView.isHidden = true
            }
            
            if let attributeTitle = emptyAttributeTitle(for: state) {
                view.label.isHidden = false
                view.label.attributedText = attributeTitle
            }else if let title = emptyTitle(for: state) {
                view.label.isHidden = false
                view.label.text = title
            }else {
                view.label.isHidden = true
            }
                        
            if let titleColor = emptyTitleColor(for: state) {
                view.label.textColor = titleColor
            }
            
            if let titleFont = emptyTitleFont(for: state) {
                view.label.font = titleFont
            }
            
            if let titleAlpha = emptyTitleAlpha(for: state) {
                view.label.alpha = titleAlpha
            }
            
            if let title = emptyButtonTitle(for: state) {
                view.button.setTitle(title, for: .normal)
            }
            
            if let color = emptyButtonTitleColor(for: state) {
                view.button.setTitleColor(color, for: .normal)
            }
            
            if let image = emptyButtonImage(for: state) {
                view.button.setImage(image, for: .normal)
            }
            
            if let color = emptyButtonBorderColor(for: state) {
                view.button.layer.borderColor = color.cgColor
            }
            
            if let width = emptyButtonBorderWidth(for: state) {
                view.button.layer.borderWidth = width
            }
            
            if view.button.titleLabel?.text == nil && view.button.imageView?.image == nil {
                view.button.isHidden = true
            }else {
                view.button.isHidden = false
            }
            
        }
        
        var superView = UIView()
        
        if isScrollView() && self.superview != nil {
            superView = self.superview!
        } else if isScrollView() && self.superview == nil {
            fatalError("tableview's superview or collectionView's superview could not be nil")
        }else {
            superView = self
        }
        
        view.removeFromSuperview()
        superView.addSubview(view)
        superView.bringSubviewToFront(view)
        
        view.edges(to: self)
    }
}
