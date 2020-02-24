//
//  EmptyStateView.swift
//  CCDINews
//
//  Created by 杨志远 on 2019/9/26.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import UIKit

/// Layout plan for your view
public enum EmptyStateLayout {
    /// Align top and offset xxx
    case top(offset    : CGFloat)
    /// Align center and offset xxx
    case center(offset : CGPoint)
    /// Align bottom and offset xxx
    case bottom(offset : CGFloat)
    /// fill in superView with edges xxx
    case full(edges : UIEdgeInsets)
    /// fill in superView with safeArea and edges
    case fullSafeArea(edges : UIEdgeInsets)
    /// custom layout
    case custom(layout : [NSLayoutConstraint])
}

class EmptyStateView: UIView {
    
    typealias ClickEvent = (EmptyState) -> Void
    /// click callback
    var event : ClickEvent?
    
    var state : EmptyState!
    
    @IBOutlet weak var customView   : UIView!
    @IBOutlet weak var imageView    : UIImageView!
    @IBOutlet weak var label        : UILabel!
    @IBOutlet weak var button       : UIButton!
    @IBOutlet weak var stackView    : UIStackView!
        
    var axis: NSLayoutConstraint.Axis = .vertical {
        didSet {
            stackView.axis = axis
        }
    }
    
    var distribution: UIStackView.Distribution = .fillProportionally {
        didSet {
            stackView.distribution = distribution
        }
    }
    
    var alignment: UIStackView.Alignment = .center {
        didSet {
            stackView.alignment = alignment
        }
    }
    
    var layout : EmptyStateLayout = .fullSafeArea(edges: .zero) {
        didSet {
            stackView.removeFromSuperview()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            
            switch layout {
            case .bottom(let offset):
                stackView.bottomlayout(to: self, offset: offset)
            case .top(let offset):
                stackView.toplayout(to: self, offset: offset)
            case .center(let offset):
                stackView.centerlayout(to: self, offset: offset)
            case .full(let edges):
                stackView.edges(to: self, edges: edges)
            case .fullSafeArea(let edges):
                stackView.edgesSafeArea(to: self, edges: edges)
            case .custom(let customLayouts):
                NSLayoutConstraint.activate(customLayouts)
            
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        fromNib()
        setUpButton()
    }
    
    func setUpButton() {
        button.layer.cornerRadius   = 14
        button.layer.borderWidth    = 1
        button.layer.masksToBounds  = true
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    @IBAction func clicked(_ sender: UIButton) {
        event?(state)
    }
}

