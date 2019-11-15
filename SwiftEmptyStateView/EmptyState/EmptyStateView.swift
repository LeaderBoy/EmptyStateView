//
//  EmptyStateView.swift
//  CCDINews
//
//  Created by 杨志远 on 2019/9/26.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import UIKit


enum EmptyStateLayout {
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
    
    var layout : EmptyStateLayout = .full {
        didSet {
            stackView.removeFromSuperview()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            
            var layouts : [NSLayoutConstraint]
            
            switch layout {
            case .bottom(let offset):
                layouts = bottomlayout(offset: offset)
            case .top(let offset):
                layouts = toplayout(offset: offset)
            case .center(let offset):
                layouts = centerlayout(offset: offset)
            case .full:
                layouts = fulllayout()
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
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
    }
    
    @IBAction func clicked(_ sender: UIButton) {
        delegate?.emptyButtonClicked(for: state)
    }
    
    /// align top
    /// - Parameter offset: offset y from top
    func toplayout(offset : CGFloat) ->[NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [stackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                    stackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
                    stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: offset)]
        } else {
            return [stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor,constant: offset)]
        }
    }
    
    /// align bottom
    /// - Parameter offset: offset y from bottom
    func bottomlayout(offset : CGFloat) ->[NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [stackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                    stackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: offset)]
        } else {
            // Fallback on earlier versions
            return [stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: offset)]
        }
    }
    
    /// align center
    /// - Parameter offset: offset y from center
    func centerlayout(offset : CGFloat) ->[NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [stackView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                    stackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)]
        } else {
            // Fallback on earlier versions
            return [stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)]
        }
    }
    
    /// fill in superview.safeAreaLayoutGuide
    func fulllayout() ->[NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [stackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                    stackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                    stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)]
        } else {
            // Fallback on earlier versions
            return [stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor)]
        }
    }
}

