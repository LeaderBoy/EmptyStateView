//
//  ExampleDefault.swift
//  SwiftEmptyStateView
//
//  Created by 杨志远 on 2020/2/24.
//  Copyright © 2020 BaQiWL. All rights reserved.
//

import Foundation
import UIKit

/// A default protocol you need to define
/// Then your application has the default configuration now
/// if you want to override any method in EmptyStateDatasource
/// just confirm to this protocol and custom you own imp
/// you will have ExampleDefault/EmptyStateDatasource and you own imp work together perfectly
protocol ExampleDefault : EmptyStateDatasource {}

extension ExampleDefault {
    func emptyTitle(for state: EmptyState) -> String? {
        switch state {
        case .error(let e) :
            switch e {
            case .networkUnReachable:
                return "No network connection, please check the network connection status and try again later"
            case .timeout:
                return "Request time out,please try again"
            case .failed:
                return "Request failed"
            }
        case .emptyData:
            return "Empty data now"
        case .custom,.loading,.success:
            return nil
        }
    }
    
    func emptyTitleColor(for state : EmptyState) -> UIColor? {
        return UIColor.themeColor
    }
    
    func emptyImage(for state: EmptyState) -> UIImage? {
        switch state {
        case .error(let e) :
            return errorEmptyImage(e: e)
        case .emptyData:
            return #imageLiteral(resourceName: "empty_data")
        case .custom,.loading,.success:
            return nil
        }
    }
    
    func errorEmptyImage(e : EmptyError) -> UIImage {
        switch e {
        case .networkUnReachable:
            return #imageLiteral(resourceName: "empty_network_unreachable")
        case .timeout:
            return #imageLiteral(resourceName: "empty_network_timeout")
        case .failed:
            return #imageLiteral(resourceName: "empty_failed")
        }
    }
    
    func emptyButtonTitle(for state: EmptyState) -> String? {
        switch state {
        case .error(_) :
            return "Retry"
        case .emptyData,.custom,.loading,.success:
            return nil
        }
    }
    
    func emptyButtonTitleColor(for state: EmptyState) -> UIColor? {
        return UIColor.themeColor
    }
    
    func emptyButtonBorderColor(for state: EmptyState) -> UIColor? {
        return UIColor.themeLightColor
    }
    
    func emptyViewLayout(stackView : UIStackView,containerView : UIView, for state: EmptyState) -> EmptyStateLayout? {
        return .top(offset: 100)
    }
}


extension UIColor {
    static var themeColor : UIColor {
        return UIColor(red: 42 / 255.0, green: 207 / 255.0, blue: 195 / 255.0,alpha: 1.0)
    }
    
    static var themeLightColor : UIColor {
        return UIColor(red: 194 / 255.0, green: 242 / 255.0, blue: 240 / 255.0,alpha: 1.0)
    }
}
