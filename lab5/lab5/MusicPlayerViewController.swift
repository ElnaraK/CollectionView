//
//  MusicPlayerViewController.swift
//  lab5
//
//  Created by Elnara  on 4/27/20.
//  Copyright © 2020 Elnara . All rights reserved.
//

import UIKit
import AVFoundation


class MusicPlayerViewController: UIViewController {

    var play: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        play = true
        // Do any additional setup after loading the view.
    }
    
    weak var delegate: TrackTableViewCellDelegate?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    var previewURL: URL!
    var player: AVPlayer?
    
    @IBAction func playOrPause(_ sender: Any) {
        
        let playerItem: AVPlayerItem
        
        playerItem = .init(url: self.previewURL)

        self.player = AVPlayer(playerItem: playerItem)
        player?.volume = 1.0
        
        if !play {
            player?.pause()
            play = true
        } else if play {
            player?.play()
            play = false
        }
     }
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    

}
