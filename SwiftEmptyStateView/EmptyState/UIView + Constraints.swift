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
    
    
    
    func edgesToSafearea(to view: UIView,in controller: UIViewController) {
        translatesAutoresizingMaskIntoConstraints = false
        let leading     = leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing    = trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom      = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        var top : NSLayoutConstraint
        if #available(iOS 11.0, *) {
            top = topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        } else {
            top = topAnchor.constraint(equalTo: controller.topLayoutGuide.bottomAnchor)
        }
        NSLayoutConstraint.activate([top,leading,bottom,trailing])
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
}
