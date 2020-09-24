//
//  StartViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 9/23/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController {
    var player: AVPlayer?
    
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpVideo()
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
    }
    
    func setUpElements() {
        // Style the elements
        Utilities.styleFilledButton(signInButton)
    }
    
    func setUpVideo() {
        let path = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player?.play()
        self.player?.isMuted = true
        player?.playImmediately(atRate: 0.4)
    }
    
    @objc func playerItemDidReachEnd() {
        player!.seek(to: CMTime.zero)
    }
    
}

