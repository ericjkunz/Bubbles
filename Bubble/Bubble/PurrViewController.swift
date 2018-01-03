//
//  ViewController.swift
//  OOH
//
//  Created by Eric Kunz on 9/22/16.
//  Copyright © 2016 Eric Kunz. All rights reserved.
//

import UIKit
import AVFoundation
import PureLayout

class PurrViewController: UIViewController, BubbleTransitionController {
    
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
    
    private lazy var catImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "cat")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let catFeedbackGenerator = UISelectionFeedbackGenerator()
    
    private var purrPlayer: AVAudioPlayer = {
        let path = Bundle.main.path(forResource: "purr", ofType: "wav")
        let url = URL(fileURLWithPath: path!)
        let p = try? AVAudioPlayer(contentsOf: url)
        p?.prepareToPlay()
        return p!
    }()
    
    private let leftEye = EyeView()
    private let rightEye = EyeView()
    private let eyeStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pannedOnCat(pan:)))
        catImageView.addGestureRecognizer(panGesture)
        
        catFeedbackGenerator.prepare()
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        view.addSubview(closeButton)
        view.addSubview(catImageView)
        
        catImageView.autoSetDimensions(to: CGSize(width: 300, height: 300))
        catImageView.autoCenterInSuperview()
        
        let eyeSize = CGSize(width: 20, height: 10)
        leftEye.autoSetDimensions(to: eyeSize)
        rightEye.autoSetDimensions(to: eyeSize)
        eyeStack.addArrangedSubview(leftEye)
        eyeStack.addArrangedSubview(rightEye)
        eyeStack.axis = .horizontal
        eyeStack.spacing = 40
        
        catImageView.addSubview(eyeStack)
        eyeStack.autoAlignAxis(.horizontal, toSameAxisOf: catImageView, withMultiplier: 0.4)
        eyeStack.autoAlignAxis(.vertical, toSameAxisOf: catImageView, withMultiplier: 1.13)
    }
    
    var overallTranslation: CGFloat = 0
    
    private dynamic func pannedOnCat(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            purrPlayer.play()
        case .changed:
            let translation = pan.translation(in: catImageView)
            let t = translation.x * translation.x + translation.y + translation.y
            if Int(t.truncatingRemainder(dividingBy: 2)) == 0 {
                catFeedbackGenerator.selectionChanged()
            }
            if overallTranslation > 100000 {
                leftEye.close()
                rightEye.close()
                overallTranslation = 0
            }
            pan.setTranslation(.zero, in: catImageView)
            overallTranslation += t
        case .ended:
            purrPlayer.stop()
        default:
            return
        }
    }
    
    func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

