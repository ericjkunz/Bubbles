//
//  Bubble.swift
//  Bubble
//
//  Created by Eric Kunz on 9/27/16.
//  Copyright © 2016 Eric Kunz. All rights reserved.
//

import Foundation
import UIKit

protocol BubbleDelegate {
    func touchesBegan(on bubble: Bubble)
    func bubblePopped(bubble: Bubble)
    func tappedLabel(with text: String)
}

class Bubble: UIView {
    
    var delegate: BubbleDelegate?
    let label = UILabel()
    
    var popped = false {
        didSet {
            setNeedsDisplay()
            if popped == true {
                delegate?.bubblePopped(bubble: self)
                label.isHidden = false
                tapGesture?.isEnabled = true
            }
            else {
                label.isHidden = true
                tapGesture?.isEnabled = false
            }
        }
    }
    
    var tapGesture: UITapGestureRecognizer?
    
    func commonInit() {
        backgroundColor = .clear
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPop))
        addGestureRecognizer(tapGesture!)
        
        addSubview(label)
        label.autoPinEdgesToSuperviewEdges()
        label.textAlignment = .center
        label.textColor = .white
        label.isHidden = true
    }
    
    func tapPop() {
        if popped && label.text != nil {
            delegate?.tappedLabel(with: label.text!)
        }
        if traitCollection.forceTouchCapability != .available {
            popIt()
        }
    }
    
    func popIt() {
        popped = true
    }
    
    convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesBegan(on: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard popped == false && traitCollection.forceTouchCapability == .available else { return }
        currentlyOnPoppingGesture = true
        guard let first = touches.first else { return }
        if first.force / first.maximumPossibleForce >= 1 {
            popIt()
        }
    }
    
    var currentlyOnPoppingGesture = false
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentlyOnPoppingGesture == false {
            if let text = label.text {
                delegate?.tappedLabel(with: text)
            }
        }
        if popped {
            currentlyOnPoppingGesture = false
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        if popped {
            context?.setLineDash(phase: 2, lengths: [10, 22])
            context?.setLineCap(.round)
            
            context?.addEllipse(in: rect.insetBy(dx: 5, dy: 5))
            
            context?.setStrokeColor(UIColor.white.withAlphaComponent(0.3).cgColor)
            context?.setLineWidth(2)
            
            context?.strokePath()
        }
        else {
            context?.addEllipse(in: rect.insetBy(dx: 5, dy: 5))
            context?.setStrokeColor(UIColor.white.cgColor)
            context?.strokePath()
        }
    }
    
}

class BubbleCell: UICollectionViewCell, BubbleDelegate {
    
    var delegate: BubbleDelegate?
    let b = Bubble()
    var text: String? {
        get {
            return b.label.text
        }
        set {
            b.label.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(b)
        b.autoPinEdgesToSuperviewEdges()
        b.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: BubbleDelegate
    
    func touchesBegan(on bubble: Bubble) {
        delegate?.touchesBegan(on: bubble)
    }
    
    func bubblePopped(bubble: Bubble) {
        delegate?.bubblePopped(bubble: bubble)
    }
    
    func tappedLabel(with text: String) {
        delegate?.tappedLabel(with: text)
    }
    
}
