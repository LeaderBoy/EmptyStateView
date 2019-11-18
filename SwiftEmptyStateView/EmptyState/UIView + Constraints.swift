//
//  UIView + Constraints.swift
//  SwiftEmptyStateView
//
//  Created by 杨志远 on 2019/11/15.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        addSubview(contentView)
        contentView.backgroundColor = UIColor.clear
        contentView.edges(to: self)
        return contentView
    }
}

extension UIView {
    @discardableResult
    func edges(to view: UIView,insets : UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        let leading     = leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: insets.left)
        let trailing    = trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: insets.right)
        let top         = topAnchor.constraint(equalTo: view.topAnchor,constant: insets.top)
        let bottom      = bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: insets.bottom)
        
        NSLayoutConstraint.activate([
            leading,trailing,top,bottom
        ])
        return [top,leading,bottom,trailing]
    }
    
    @discardableResult
    func center(to view: UIView) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let x = centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let y = centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        NSLayoutConstraint.activate([
            x,y
        ])
        return [x,y]
    }
    
    
    /// align top
    /// - Parameter offset: offset y from top
    @discardableResult
    func toplayout(to view :UIView, offset : CGFloat) ->[NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                    rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                    topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: offset)]
        } else {
            return [leftAnchor.constraint(equalTo: view.leftAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor),
            topAnchor.constraint(equalTo: view.topAnchor,constant: offset)]
        }
    }
    
    /// align bottom
    /// - Parameter offset: offset y from bottom
    @discardableResult
    func bottomlayout(to view :UIView, offset : CGFloat) ->[NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                    rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                    bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: offset)]
        } else {
            // Fallback on earlier versions
            return [leftAnchor.constraint(equalTo: view.leftAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: offset)]
        }
    }
    
    /// align center
    /// - Parameter offset: offset y from center
    @discardableResult
    func centerlayout(to view :UIView, offset : CGFloat) ->[NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                    centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)]
        } else {
            // Fallback on earlier versions
            return [centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        }
    }
    
    /// fill in superview.safeAreaLayoutGuide
    @discardableResult
    func fulllayout(to view :UIView) ->[NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                    rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                    bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)]
        } else {
            // Fallback on earlier versions
            return [leftAnchor.constraint(equalTo: view.leftAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topAnchor.constraint(equalTo: view.topAnchor)]
        }
    }
    
}
