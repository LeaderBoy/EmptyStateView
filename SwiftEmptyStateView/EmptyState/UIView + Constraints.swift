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
    func edges(to view: UIView,edges: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        let leading     = leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: edges.left)
        let trailing    = trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: edges.right)
        let top         = topAnchor.constraint(equalTo: view.topAnchor,constant: edges.top)
        let bottom      = bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: edges.bottom)
        
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
    func toplayout(to view :UIView, offset : CGFloat = 0) ->[NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var layouts : [NSLayoutConstraint] = []
        if #available(iOS 11.0, *) {
            layouts = [leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                    rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                    topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: offset)]
        } else {
            layouts = [leftAnchor.constraint(equalTo: view.leftAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor),
            topAnchor.constraint(equalTo: view.topAnchor,constant: offset)]
        }
        
        NSLayoutConstraint.activate(layouts)
        return layouts
    }
    
    /// align bottom
    /// - Parameter offset: offset y from bottom
    @discardableResult
    func bottomlayout(to view :UIView, offset : CGFloat = 0) ->[NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var layouts : [NSLayoutConstraint] = []
        if #available(iOS 11.0, *) {
            layouts = [leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                    rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                    bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: offset)]
        } else {
            // Fallback on earlier versions
            layouts = [leftAnchor.constraint(equalTo: view.leftAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: offset)]
        }
        NSLayoutConstraint.activate(layouts)
        return layouts
    }
    
    /// align center
    /// - Parameter offset: offset y from center
    @discardableResult
    func centerlayout(to view :UIView, offset : CGPoint = .zero) ->[NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var layouts : [NSLayoutConstraint] = []
        if #available(iOS 11.0, *) {
            layouts = [centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor,constant: offset.x),
                       centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,constant: offset.y)]
        } else {
            // Fallback on earlier versions
            layouts = [centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: offset.x),
                       centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: offset.y)]
        }
        NSLayoutConstraint.activate(layouts)
        return layouts
    }
    
    /// fill in superview.safeAreaLayoutGuide
    @discardableResult
    func edgesSafeArea(to view :UIView,edges : UIEdgeInsets = .zero) ->[NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var layouts : [NSLayoutConstraint] = []
        if #available(iOS 11.0, *) {
            layouts = [leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: edges.left),
                       rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: edges.right),
                       bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: edges.bottom),
                       topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: edges.top)]
        } else {
            // Fallback on earlier versions
            layouts = [leftAnchor.constraint(equalTo: view.leftAnchor,constant: edges.left),
                       rightAnchor.constraint(equalTo: view.rightAnchor,constant: edges.left),
                       bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: edges.bottom),
                       topAnchor.constraint(equalTo: view.topAnchor,constant: edges.top)]
        }
        NSLayoutConstraint.activate(layouts)
        return layouts
    }
    
}
