//
//  MusicsViewController.swift
//  lab5
//
//  Created by Elnara  on 4/27/20.
//  Copyright © 2020 Elnara . All rights reserved.
//

import UIKit

class MusicsViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var tracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textField.addTarget(self, action: #selector(downloadSearch), for: UIControl.Event.editingChanged)
        textField.delegate = self
        downloadModels()
    }
    
    @objc func downloadModels() {
        MusicService.shared.defaultMusic { [weak self] result, error in
            guard let self = self else { return }
            
            if let tracks = result?.tracks {
                self.tracks = tracks
                self.tableView.reloadData()
            } else if let error = error {
                print(error)
            }
        }
    }
    
    @objc func downloadSearch() {
        let search = self.textField.text
        self.tracks.removeAll()
        let url = "https://itunes.apple.com/search?term=\(String(describing: search ?? ""))&entity=song"
        MusicService.shared.searchForMusic(url)
        {
            [weak self] result, error in
            guard let self = self else { return }
            
            if let tracks = result?.tracks {
                self.tracks += tracks
                self.tableView.reloadData()
            } else if let error = error {
                print(error)
            }
        }
    }
}


extension MusicsViewController: TrackTableViewCellDelegate {
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

extension MusicsViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! MusicCellControllerTableViewCell
        cell.track = self.tracks[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        self.tracks.removeAll()
        downloadModels()
        return true
    }
}

