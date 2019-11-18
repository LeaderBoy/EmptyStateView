//
//  EmptyStateView.swift
//  CCDINews
//
//  Created by 杨志远 on 2019/9/26.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import UIKit


public enum EmptyStateLayout {
    case top(offset    : CGFloat)
    case center(offset : CGFloat)
    case bottom(offset : CGFloat)
    case full
    case custom(layout : [NSLayoutConstraint])
}

class EmptyStateView: UIView {
    
    weak var delegate : EmptyStateDelegate?

    var state : EmptyState!
    
    @IBOutlet weak var customView   : UIView!
    @IBOutlet weak var imageView    : UIImageView!
    @IBOutlet weak var label        : UILabel!
    @IBOutlet weak var button       : UIButton! {
        didSet {
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
    }
    
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
    
    var layout : EmptyStateLayout = .full {
        didSet {
            stackView.removeFromSuperview()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            
            var layouts : [NSLayoutConstraint]
            
            switch layout {
            case .bottom(let offset):
                layouts = stackView.bottomlayout(to: self, offset: offset)
            case .top(let offset):
                layouts = stackView.toplayout(to: self, offset: offset)
            case .center(let offset):
                layouts = stackView.centerlayout(to: self, offset: offset)
            case .full:
                layouts = stackView.fulllayout(to: self)
            case .custom(let customLayouts):
                layouts = customLayouts
            }
            NSLayoutConstraint.activate(layouts)
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
    }
    
    @IBAction func clicked(_ sender: UIButton) {
        delegate?.emptyButtonClicked(for: state)
    }
}

