//
//  Transition.swift
//  Bubble
//
//  Created by Eric Kunz on 10/2/16.
//  Copyright © 2016 Eric Kunz. All rights reserved.
//

import Foundation
import UIKit

class BubbleAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    var isPresenting = true
    private weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    var buttonFrame: CGRect = .zero
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView
        _ = transitionContext.viewController(forKey: .from)!
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        if isPresenting {
            containerView.addSubview(toViewController.view)
            
            let circleMaskPathInitial = UIBezierPath(ovalIn: buttonFrame)
            
            let width = toViewController.view.frame.size.width
            let height = toViewController.view.frame.size.height
            let radius = sqrt(width * width + height * height)
            let circleMaskPathFinal = UIBezierPath(ovalIn: buttonFrame.insetBy(dx: -radius, dy: -radius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = circleMaskPathFinal.cgPath
            toViewController.view.layer.mask = maskLayer
            
            let maskLayerAnimation = CABasicAnimation(keyPath: "path")
            maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
            maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
            maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
            maskLayerAnimation.delegate = self
            maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            maskLayer.add(maskLayerAnimation, forKey: "path")
        }
        else {
            containerView.addSubview(toViewController.view)
            containerView.addSubview(fromViewController.view)
            
            let circleMaskPathFinal = UIBezierPath.init(ovalIn: buttonFrame)
            
            let width = toViewController.view.frame.size.width
            let height = toViewController.view.frame.size.height
            let radius = sqrt(width * width + height * height)
            let circleMaskPathInitial = UIBezierPath(ovalIn: buttonFrame.insetBy(dx: -radius, dy: -radius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = circleMaskPathFinal.cgPath
            fromViewController.view.layer.mask = maskLayer
            
            let maskLayerAnimation = CABasicAnimation(keyPath: "path")
            maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
            maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
            maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
            maskLayerAnimation.delegate = self
            maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            maskLayer.add(maskLayerAnimation, forKey: "path")
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
        transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
    }
    
}

extension CGRect {
    
    /// Alias for origin.x.
    public var x: CGFloat {
        get {return origin.x}
        set {origin.x = newValue}
    }
    /// Alias for origin.y.
    public var y: CGFloat {
        get {return origin.y}
        set {origin.y = newValue}
    }
    
    /// Accesses origin.x + 0.5 * size.width.
    public var centerX: CGFloat {
        get {return x + width * 0.5}
        set {x = newValue - width * 0.5}
    }
    /// Accesses origin.y + 0.5 * size.height.
    public var centerY: CGFloat {
        get {return y + height * 0.5}
        set {y = newValue - height * 0.5}
    }
    
}
