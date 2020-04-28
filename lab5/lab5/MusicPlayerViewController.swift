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

    override func viewDidLoad() {
        super.viewDidLoad()
        player?.play()
        // Do any additional setup after loading the view.
    }
    
    weak var delegate: TrackTableViewCellDelegate?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    var previewURL: URL!
    var player: AVPlayer?
    
    var track: Track! {
        didSet {
            self.name.text = track.trackName
            self.previewURL = track.previewUrl
        }
    }
    
    @IBAction func playOrPause(_ sender: Any) {
        var play: Bool = false
        if !play {
            player?.pause()
            play = true
        } else if play {
            player?.play()
            play = false
        }
     }
    @IBAction func close(_ sender: Any) {
    }
    
    

}

extension MusicPlayerViewController: TrackTableViewCellDelegate {
    
    func didPressPlay(track: Track) {
        MusicService.shared.play(track: track)
    }
    
    func didPressDownload(track: Track, completion: @escaping (Track) -> ()) {
        MusicService.shared.download(track: track) { url, error in
            if let url = url {
                completion(track)
            } else if let error = error {
                print(error)
            }
        }
    }
    
}
