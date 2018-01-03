//
//  BubbleNavigationController.swift
//  Bubble
//
//  Created by Eric Kunz on 10/5/16.
//  Copyright © 2016 Eric Kunz. All rights reserved.
//

import Foundation
import UIKit

protocol BubbleTransitionController {
    var transitionStartEnd: CGRect { get set }
}

class BubbleNavigationController: UINavigationController, BubbleCollectionViewControllerDelegate {
    
    // MARK: BubbleCollectionViewControllerDelegate
    
    func tappedBubble(with text: String) {
        switch text {
        case NavLabel.about:
            let aboutVC = AboutViewController()
            let startEnd = (viewControllers.first as! BubbleTransitionController).transitionStartEnd
            aboutVC.transitionStartEnd = startEnd
            aboutVC.transitioningDelegate = self
            present(aboutVC, animated: true, completion: nil)
        case NavLabel.cat:
            let purrVC = PurrViewController()
            let startEnd = (viewControllers.first as! BubbleTransitionController).transitionStartEnd
            purrVC.transitionStartEnd = startEnd
            purrVC.transitioningDelegate = self
            present(purrVC, animated: true, completion: nil)
            
        default: break
        }
    }
    
}

extension BubbleNavigationController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = BubbleAnimator()
        let startEnd = (viewControllers.first as! BubbleTransitionController).transitionStartEnd
        transition.buttonFrame = startEnd
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = BubbleAnimator()
        let startEnd = (viewControllers.first as! BubbleTransitionController).transitionStartEnd
        transition.buttonFrame = startEnd
        transition.isPresenting = false
        return transition
    }
    
}
