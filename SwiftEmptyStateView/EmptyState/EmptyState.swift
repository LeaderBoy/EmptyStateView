
//
//  EmptyState.swift
//  CCDINews
//
//  Created by 杨志远 on 2019/9/26.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import UIKit

public enum EmptyError  {
    case networkUnReachable
    case timeout
    case failed(_ err: Error?)
    public static func failed(err : Error) -> Self {
        return .failed(err)
    }
}

extension EmptyError : Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.networkUnReachable, .networkUnReachable)       : return true
        case (.timeout, .timeout)       : return true
        case (.failed(let l as NSError), .failed(let r as NSError)) where l.code == r.code  : return true
        case _: return false
        }
    }
}

public enum EmptyState : Equatable {
    case loading
    case error(_ error : EmptyError)
    case success
    case emptyData
    case custom
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
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

public protocol EmptyStateDelegate : class {
    func emptyButtonClicked(for state: EmptyState)
}

public protocol EmptyStateDatasource : class {
    
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
    func emptyButtonCornerRadius(for state: EmptyState) -> CGFloat?

    
    func emptyCustomView(for state: EmptyState) -> UIView?
    
    func emptySpacing(for state: EmptyState) -> CGFloat?
    func emptyAxis(for state: EmptyState) -> NSLayoutConstraint.Axis?
    func emptyAlignment(for state: EmptyState) -> UIStackView.Alignment?
    func emptyDistribution(for state: EmptyState) -> UIStackView.Distribution?
    func emptyViewShouldFadeOut(for state: EmptyState) -> Bool?
    func emptyViewBackgroundColor(for state: EmptyState) -> UIColor?
    
    
    func emptyViewLayout(in superView : UIView, for state: EmptyState) -> EmptyStateLayout?

    func emptyViewLayout(stackView : UIStackView,containerView : UIView, for state: EmptyState) -> EmptyStateLayout?
    func emptyViewLayoutEdgeInsets(for state: EmptyState) -> UIEdgeInsets?
}


private var EmptyDataSourceKey = 0
private var EmptyStateViewKey = 0
private var EmptyStateDelegateKey = 0


fileprivate struct WeakBox {
    weak var obj : AnyObject?
    init(weak obj: AnyObject) {
        self.obj = obj
    }
}

extension UIView {
    
    /// delegate for view
    public var emptyDelegate: EmptyStateDelegate? {
        get {
            let box = objc_getAssociatedObject(self, &EmptyStateDelegateKey) as? WeakBox
            return box?.obj as? EmptyStateDelegate
        }
        set {
            let weakObj = WeakBox(weak: newValue as AnyObject)
            objc_setAssociatedObject(self, &EmptyStateDelegateKey, weakObj, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// datasource for view
    public var emptyDataSource: EmptyStateDatasource? {
        get {
            let box = objc_getAssociatedObject(self, &EmptyDataSourceKey) as? WeakBox
            return box?.obj as? EmptyStateDatasource
        }
        set {
            let weakObj = WeakBox(weak: newValue as AnyObject)
            objc_setAssociatedObject(self, &EmptyDataSourceKey, weakObj, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
}


extension UIView : EmptyStateDatasource {
    /// refresh with current state
    /// - Parameter state: current state
    public func reloadState(_ state: EmptyState = .success) {
        let reload = {
            if self.emptyDataSource != nil {
                if state == .success || (self.isScrollView() && self.items() != 0) {
                    self.remove(for: state)
                }else {
                    self.emptyLayout(for: state)
                }
            }else {
                assertionFailure("\(self) emptyDataSource must not be nil")
            }
        }
        
        // prevent main thread checker error
        if Thread.isMainThread {
            reload()
        } else {
            DispatchQueue.main.async {
                reload()
            }
        }
    }
    
    // convenience method for reloadState(.error)
    public func errorReload( _ error : Error) {
        if error.isNotConnectedToInternet() {
            reloadState(.error(.networkUnReachable))
        }else if error.isTimeout() {
            reloadState(.error(.timeout))
        }else {
            reloadState(.error(.failed(nil)))
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
            if let fade = emptyDataSource?.emptyViewShouldFadeOut(for: state),fade {
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
        let dataSource = emptyDataSource!
                
        if let backgroundColor = dataSource.emptyViewBackgroundColor(for: state) {
            view.backgroundColor = backgroundColor
        }
                
        if let axis = dataSource.emptyAxis(for: state) {
            view.axis = axis
        }
        
        if let alignment = dataSource.emptyAlignment(for: state) {
            view.alignment = alignment
        }
        
        if let distribution = dataSource.emptyDistribution(for: state) {
            view.distribution = distribution
        }
        
        view.state = state
                
        if let subView = dataSource.emptyCustomView(for: state) {
            let supView = view.customView!
            view.stackView.isHidden = true
            supView.isHidden = false
            _ = supView.subviews.map{$0.removeFromSuperview()}
            supView.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
            
            let insets = dataSource.emptyViewLayoutEdgeInsets(for: state)
            
            if let layout = dataSource.emptyViewLayout(in: view.customView, for: state) {
                switch layout {
                case .full:
                    subView.edges(to: supView,edges: insets ?? .zero)
                case .top(let offset):
                    subView.toplayout(to: supView, offset: offset)
                case .center(let offset):
                    subView.centerlayout(to: supView,offset: offset)
                case .bottom(let offset):
                    subView.bottomlayout(to: supView, offset: offset)
                case .custom(let layouts):
                    NSLayoutConstraint.activate(layouts)
                case .fullSafeArea:
                    subView.edgesSafeArea(to: supView)
                }
            }else {
                subView.edgesSafeArea(to: supView)
            }
        }else {
            view.delegate = self.emptyDelegate
            
            view.stackView.isHidden = false
            view.customView.isHidden = true
            // layout for stackView
            if let layout = dataSource.emptyViewLayout(stackView: view.stackView, containerView: view, for: state) {
                view.layout = layout
            }else {
                view.layout = .fullSafeArea(edges: .zero)
            }
            /// stack spacing
            if let space = dataSource.emptySpacing(for: state) {
                view.stackView.spacing = space
            }
            /// layout for image
            if let image = dataSource.emptyImage(for: state) {
                view.imageView.isHidden = false
                view.imageView.image = image
            }else {
                view.imageView.isHidden = true
            }
            /// layout for label
            if let attributeTitle = dataSource.emptyAttributeTitle(for: state) {
                view.label.isHidden = false
                view.label.attributedText = attributeTitle
            }else if let title = dataSource.emptyTitle(for: state) {
                view.label.isHidden = false
                view.label.text = title
            }else {
                view.label.isHidden = true
            }
                        
            if let titleColor = dataSource.emptyTitleColor(for: state) {
                view.label.textColor = titleColor
            }
            
            if let titleFont = dataSource.emptyTitleFont(for: state) {
                view.label.font = titleFont
            }
            
            if let titleAlpha = dataSource.emptyTitleAlpha(for: state) {
                view.label.alpha = titleAlpha
            }
            
            /// layout for button
            var hideButton = true
            
            if let title = dataSource.emptyButtonTitle(for: state) {
                hideButton = false
                view.button.setTitle(title, for: .normal)
            }
            
            if let color = dataSource.emptyButtonTitleColor(for: state) {
                view.button.setTitleColor(color, for: .normal)
            }
            
            if let image = dataSource.emptyButtonImage(for: state) {
                hideButton = false
                view.button.setImage(image, for: .normal)
            }
            
            if let color = dataSource.emptyButtonBorderColor(for: state) {
                view.button.layer.borderColor = color.cgColor
            }
            
            if let width = dataSource.emptyButtonBorderWidth(for: state) {
                view.button.layer.borderWidth = width
            }
            
            if let cornerRadius = dataSource.emptyButtonCornerRadius(for: state) {
                view.button.layer.cornerRadius = cornerRadius
            }
            
            view.button.isHidden = hideButton
        }
        
        var superView = UIView()
        /// when using tableView
        /// put subView in tableView's superView rather than tableView
        if isScrollView() && self.superview != nil {
            superView = self.superview!
        } else if isScrollView() && self.superview == nil {
            assertionFailure("tableview's superview or collectionView's superview could not be nil")
        }else {
            superView = self
        }
        
        view.removeFromSuperview()
        superView.addSubview(view)
        superView.bringSubviewToFront(view)
        view.edges(to: superView)
    }
}
