//
//  BubbleCollectionViewController.swift
//  Bubble
//
//  Created by Eric Kunz on 9/29/16.
//  Copyright © 2016 Eric Kunz. All rights reserved.
//

import Foundation
import UIKit
import CCHexagonFlowLayout
import AVFoundation
import PureLayout

struct NavLabel {
    static let cat = "=^··^="
    static let about = "i"
}

protocol BubbleCollectionViewControllerDelegate {
    func tappedBubble(with text: String)
}

class BubbleCollectionViewController: UICollectionViewController, BubbleDelegate, BubbleTransitionController {
    
    var transitionStartEnd: CGRect = .zero
    
    var delegate: BubbleCollectionViewControllerDelegate?
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private var infoCellRect: CGRect?
    private var nextCellRect: CGRect?
    
    var cellDimension: CGFloat = 0
    
    var swooshPlayer: AVAudioPlayer = {
        let path = Bundle.main.path(forResource: "swoosh", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        let player = try! AVAudioPlayer(contentsOf: url)
        player.volume = 0.2
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        return player
    }()
    
    convenience init() {
        let layout = CCHexagonFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = -8.0;
        layout.minimumLineSpacing = 0.0;
        let d = (UIScreen.main.bounds.width - (layout.minimumInteritemSpacing * 4)) / 5
        layout.itemSize = CGSize(width: d, height: d);
        layout.gap = d / 2;
        
        self.init(collectionViewLayout: layout)
        cellDimension = d
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(BubbleCell.self, forCellWithReuseIdentifier: "BubbleCell")
        collectionView?.isScrollEnabled = false
        
        players = [popPlayer(), popPlayer()]
    }
    
    var players: [AVAudioPlayer] = []
    
    func popPlayer() -> AVAudioPlayer {
        let path = Bundle.main.path(forResource: "pop", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        let player = try! AVAudioPlayer(contentsOf: url)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        return player
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            for cell in collectionView?.visibleCells as! [BubbleCell] {
                if cell.b.popped {
                    swooshPlayer.play()
                    reset()
                    break
                }
            }
        }
    }
    
    func reset() {
        for cell in collectionView?.visibleCells as! [BubbleCell] {
            cell.b.popped = false
        }
    }
    
    // MARK: BubbleDelegate
    
    func touchesBegan(on bubble: Bubble) {
        feedbackGenerator.prepare()
    }
    
    func bubblePopped(bubble: Bubble) {
        feedbackGenerator.impactOccurred()
        if players.first!.isPlaying {
            players[1].play()
        }
        else {
            players.first!.play()
        }
    }
    func tappedLabel(with text: String) {
        switch text {
        case NavLabel.about:
            let attributes = collectionView?.layoutAttributesForItem(at: IndexPath(item: totalCells - 5, section: 0))
            transitionStartEnd = attributes?.frame ?? .zero
        case NavLabel.cat:
            let attributes = collectionView?.layoutAttributesForItem(at: IndexPath(item: totalCells - 1, section: 0))
            transitionStartEnd = attributes?.frame ?? .zero
        default: break
        }
        
        delegate?.tappedBubble(with: text)
    }
    
    // MARK: UICollectionViewDataSource
    
    var numPerColumn: Int {
        return Int(view.bounds.height / cellDimension)
    }
    var totalCells: Int {
        return numPerColumn * 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numPerColumn * 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleCell", for: indexPath) as! BubbleCell
        cell.delegate = self
        
        if indexPath.row == (totalCells - 2) || indexPath.row == (totalCells - 4) {
            cell.isHidden = true
        }
        if indexPath.row == totalCells - 1 {
            cell.text = NavLabel.cat
        }
        if indexPath.row == totalCells - 5 {
            cell.text = NavLabel.about
        }
        
        return cell
    }
    
}
