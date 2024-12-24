//
//  GradientView.swift
//  ImageFeed
//
//  Created by Артем Табенский on 24.12.2024.
//

import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient() {
        self.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.colors = [UIColor.startGradient.cgColor, UIColor.endGradient.cgColor]
    }
}
