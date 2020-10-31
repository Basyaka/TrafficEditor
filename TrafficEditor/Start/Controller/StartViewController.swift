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
    
    @IBOutlet weak var backround: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        backgroundVideo()
        
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
    }
    
    
    func backgroundVideo() {
        let imageData = NSData(contentsOf: Bundle.main.url(forResource: "flow", withExtension: "gif")!)
        let imageGif = UIImage.gif(data: imageData! as Data)
        backround.image = imageGif
    }
    
    func setUpElements() {
        // Style the elements
        Utilities.styleFilledButton(signInButton)
    }
}

