//
//  Eye.swift
//  Bubble
//
//  Created by Eric Kunz on 10/9/16.
//  Copyright © 2016 Eric Kunz. All rights reserved.
//

import Foundation
import UIKit

class EyeView: UIView {
    
    let maskLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        maskLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        maskLayer.path = UIBezierPath(ovalIn: bounds).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func close() {
        let circleMaskPathInitial = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        let circleMaskPathFinal = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: bounds.width, height: 1))
        
        let close = CABasicAnimation(keyPath: "path")
        close.fromValue = circleMaskPathInitial.cgPath
        close.toValue = circleMaskPathFinal.cgPath
        close.duration = 1
        close.autoreverses = true
        close.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        maskLayer.add(close, forKey: "path")
    }
    
}
