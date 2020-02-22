//
//  EmptyStateDefault.swift
//  CCDINews
//
//  Created by 杨志远 on 2019/10/18.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    static var themeColor : UIColor {
        return UIColor(red: 42 / 255.0, green: 207 / 255.0, blue: 195 / 255.0,alpha: 1.0)
    }
    
    static var themeLightColor : UIColor {
        return UIColor(red: 194 / 255.0, green: 242 / 255.0, blue: 240 / 255.0,alpha: 1.0)
    }
}

extension EmptyStateDatasource {
    public func emptyTitle(for state: EmptyState) -> String? {
        switch state {
        case .error(let e) :
            switch e {
            case .networkUnReachable:
                return "当前网络不可用,请检查网络设置"
            case .timeout:
                return "请求超时"
            case .failed:
                return "加载失败"
            }
        case .emptyData:
            return "暂无数据"
        case .custom,.loading,.success:
            return nil
        }
    }
    
    public func emptyTitleColor(for state : EmptyState) -> UIColor? {
        return UIColor.themeColor
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
        switch state {
        case .error(let e) :
            return errorEmptyImage(e: e)
        case .emptyData:
            return #imageLiteral(resourceName: "empty_data")
        case .custom,.loading,.success:
            return nil
        }
    }
    
    public func errorEmptyImage(e : EmptyError) -> UIImage {
        switch e {
        case .networkUnReachable:
            return #imageLiteral(resourceName: "empty_network_unreachable")
        case .timeout:
            return #imageLiteral(resourceName: "empty_network_timeout")
        case .failed:
            return #imageLiteral(resourceName: "empty_failed")
        }
    }
    
    public func emptyButtonTitle(for state: EmptyState) -> String? {
        switch state {
        case .error(_) :
            return "点击重试"
        case .emptyData,.custom,.loading,.success:
            return nil
        }
    }
    
    public func emptyButtonTitleColor(for state: EmptyState) -> UIColor? {
        return UIColor.themeColor
    }
    
    public func emptyButtonTitleFont(for state: EmptyState) -> UIFont? {
        return nil
    }
    
    public func emptyButtonImage(for state: EmptyState) -> UIImage? {
        return nil
    }
    
    public func emptyButtonBorderColor(for state: EmptyState) -> UIColor? {
        return UIColor.themeLightColor
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
        return nil
    }
    
    public func emptyAlignment(for state: EmptyState) -> UIStackView.Alignment? {
        return nil
    }
    
    public func emptyDistribution(for state: EmptyState) -> UIStackView.Distribution? {
        return nil
    }
    
    public func emptyViewShouldFadeOut(for state: EmptyState) -> Bool? {
        return false
    }
    
    public func emptyViewLayout(stackView : UIStackView,containerView : UIView, for state: EmptyState) -> EmptyStateLayout? {
        return .top(offset: 100)
    }
    
    public func emptyViewLayoutEdgeInsets(for state: EmptyState) -> UIEdgeInsets? {
        return .zero
    }
    
    public func emptyViewLayout(in superView : UIView, for state: EmptyState) -> EmptyStateLayout? {
        return .fullSafeArea(edges: .zero)
    }

}

