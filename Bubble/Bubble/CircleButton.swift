//
//  CircleButton.swift
//  Bubble
//
//  Created by Eric Kunz on 10/9/16.
//  Copyright © 2016 Eric Kunz. All rights reserved.
//

import Foundation
import UIKit

class CircleButton: UIButton {
    
    var borderColor: UIColor? {
        get {
            if let c = layer.borderColor {
                return UIColor(cgColor: c)
            }
            else { return nil }
        }
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.masksToBounds = true
        layer.borderWidth = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
    
}
