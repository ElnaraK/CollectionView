//
//  MusicCellControllerTableViewCell.swift
//  lab5
//
//  Created by Elnara  on 4/27/20.
//  Copyright © 2020 Elnara . All rights reserved.
//

import UIKit

protocol TrackTableViewCellDelegate: class {
    func didPressPlay(track: Track)
    func didPressDownload(track: Track, completion: @escaping (Track) -> ())
}

class MusicCellControllerTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - Variables
    var track: Track! {
        didSet {
            self.nameLabel.text = track.trackName
            self.artistLabel.text = track.artistName
            
            let isDownloaded = MusicService.shared.isDownloaded(track: self.track)
            
            downloadButton.isUserInteractionEnabled = !isDownloaded
            downloadButton.isHidden = isDownloaded
        }
    }
    weak var delegate: TrackTableViewCellDelegate?
    
    // MARK: - Actions
    @IBAction func play(_ sender: Any) {
        delegate?.didPressPlay(track: track)
    }
    
    
    @IBAction func download(_ sender: Any) {
        delegate?.didPressDownload(track: track) { track in
            self.track = track
        }
    }

}
