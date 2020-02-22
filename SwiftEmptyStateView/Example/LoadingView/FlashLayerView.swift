//
//  FlashLayerView.swift
//  SwiftEmptyStateView
//
//  Created by 杨志远 on 2020/2/21.
//  Copyright © 2020 BaQiWL. All rights reserved.
//

import UIKit

class FlashLayerView: UIView {
    private(set) var logo : String
    private(set) var font : UIFont?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "logo name"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.text = "logo name"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.isHidden = true
        return label
    }()
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    init(with logo : String,font : UIFont? = UIFont.boldSystemFont(ofSize: 40)) {
        self.logo = logo
        self.font = font
        super.init(frame: .zero)
        configue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configue() {
        label.text = logo
        label.font = font
        
        sizeLabel.text = logo
        sizeLabel.font = font
        
        addAnimation()
        
        addSubview(sizeLabel)
        sizeLabel.edges(to: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = layer.bounds
    }
    
    private func addAnimation() {
        
        let gradientLayer = self.layer as! CAGradientLayer
        let colors = [
           UIColor.lightGray.cgColor,
           UIColor.gray.cgColor,
           UIColor.gray.cgColor,
           UIColor.lightGray.cgColor
        ]
        gradientLayer.colors = colors

        let locations: [NSNumber] = [
            -0.4,
            -0.39,
            -0.24,
            -0.23
        ]
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.6)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.4)
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [-0.8,-0.79,-0.64,-0.63]
        gradientAnimation.toValue = [1.5,1.51,1.76,1.77]
        gradientAnimation.duration = 2.0
        gradientAnimation.repeatCount = MAXFLOAT
        gradientLayer.add(gradientAnimation, forKey: nil)
        
        gradientLayer.mask = label.layer
    }
}

extension UIView {
    fileprivate func layoutEdges(to view: UIView,insets : UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
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
}
