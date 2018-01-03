//
//  AboutViewController.swift
//  Bubble
//
//  Created by Eric Kunz on 10/9/16.
//  Copyright © 2016 Eric Kunz. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class AboutViewController: UIViewController, BubbleTransitionController {
    
    var transitionStartEnd: CGRect = .zero {
        didSet {
            closeButton.frame = transitionStartEnd.insetBy(dx: 5, dy: 5)
        }
    }
    
    private lazy var closeButton: CircleButton = {
        let b = CircleButton()
        b.setTitle("X", for: .normal)
        b.borderColor = .black
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        let button = TitleInsetButton()
        view.addSubview(button)
        button.setTitle("Eric Kunz", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 32)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.autoCenterInSuperview()
        
        button.layer.borderColor = UIColor(red:0.05, green:0.14, blue:0.98, alpha:1.00).cgColor
        button.layer.borderWidth = 3
        
        button.addTarget(self, action: #selector(nameButtonTapped), for: .touchUpInside)
        
        view.addSubview(closeButton)
    }
    
    func nameButtonTapped() {
        guard let aboutMeURL = URL(string: "http://erickunz.com") else { return }
        let safariVC = SFSafariViewController(url: aboutMeURL)
        present(safariVC, animated: true, completion: nil)
    }
    
    func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

class TitleInsetButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        get {
            var i = super.intrinsicContentSize
            i.width += titleEdgeInsets.left + titleEdgeInsets.right
            i.height += titleEdgeInsets.top + titleEdgeInsets.bottom
            return i
        }
    }
    
}
