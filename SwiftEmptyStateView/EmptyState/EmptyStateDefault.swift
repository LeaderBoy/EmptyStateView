//
//  EmptyStateDefault.swift
//  CCDINews
//
//  Created by 杨志远 on 2019/10/18.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import Foundation
import UIKit

extension EmptyStateDatasource {
    public func emptyTitle(for state: EmptyState) -> String? {
        return nil
    }
    
    public func emptyTitleColor(for state : EmptyState) -> UIColor? {
        return nil
    }
    
    public func emptyAttributeTitle(for state : EmptyState) -> NSAttributedString? {
        return nil
    }
    
    public func emptyTitleFont(for state : EmptyState) -> UIFont? {
        return UIFont.systemFont(ofSize: 17)
    }
    
    public func emptyTitleAlpha(for state : EmptyState) -> CGFloat? {
        return 1
    }
    
    public func emptyImage(for state: EmptyState) -> UIImage? {
        return nil
    }
    
    public func emptyButtonTitle(for state: EmptyState) -> String? {
        return nil
    }
    
    public func emptyButtonTitleColor(for state: EmptyState) -> UIColor? {
        return nil
    }
    
    public func emptyButtonTitleFont(for state: EmptyState) -> UIFont? {
        return nil
    }
    
    public func emptyButtonImage(for state: EmptyState) -> UIImage? {
        return nil
    }
    
    public func emptyButtonBackgroundImage(for state: EmptyState) -> UIImage? {
        return nil
    }
    
    public func emptyButtonBorderColor(for state: EmptyState) -> UIColor? {
        return nil
    }
    
    public func emptyButtonBorderWidth(for state: EmptyState) -> CGFloat? {
        return nil
    }
    
    public func emptyButtonCornerRadius(for state: EmptyState) -> CGFloat? {
        return nil
    }
    
    public func emptyViewBackgroundColor(for state: EmptyState) -> UIColor? {
        return nil
    }
    
    public func emptyCustomView(for state: EmptyState) -> UIView? {
        if state == .loading {
            let view = UIView()
            let indicator = UIActivityIndicatorView()
            if #available(iOS 13.0, *) {
                indicator.style = .medium
            } else {
                indicator.style = .gray
            }
            indicator.hidesWhenStopped = true
            indicator.startAnimating()
            view.addSubview(indicator)
            indicator.center(to: view)
            return view
        }
        return nil
    }
    
    public func emptySpacing(for state: EmptyState) -> CGFloat? {
        return 20
    }
    
    public func emptyAxis(for state: EmptyState) -> NSLayoutConstraint.Axis? {
        return .vertical
    }
    
    public func emptyAlignment(for state: EmptyState) -> UIStackView.Alignment? {
        return nil
    }
    
    public func emptyDistribution(for state: EmptyState) -> UIStackView.Distribution? {
        return nil
    }
    
    public func emptyViewShouldFadeOut(for state: EmptyState) -> Bool {
        return false
    }
    
    public func emptyLayout(in customView : UIView, for state: EmptyState) -> EmptyStateLayout? {
        return .center(offset: .zero)
    }
    public func emptyLayout(for stackView : UIStackView,in containerView : UIView, for state: EmptyState) -> EmptyStateLayout? {
        return .center(offset: .zero)
    }

}

