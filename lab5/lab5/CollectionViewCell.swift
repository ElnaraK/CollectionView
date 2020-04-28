//
//  CollectionViewCell.swift
//  lab5
//
//  Created by Elnara  on 4/27/20.
//  Copyright © 2020 Elnara . All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var track: Track? {
        didSet {
            self.label.text = track?.trackName
            ImageService.shared.downloadImage(image: track?.artworkUrl100) { image in
                self.imageView.image = image
            }
        }
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        let documentsDirectoryURL = try! FileManager.default.url(for: .documentDirectory,
                                                                 in: .userDomainMask,
                                                                 appropriateFor: nil,
                                                                 create: true)
        let filesList = FileService.shared.contentsOf(documentsDirectoryURL)
        let item = filesList[sender.tag]
        
        do {
            if FileManager.default.fileExists(atPath: item.path) {
                try FileManager.default.removeItem(atPath: item.path)
            } else {
                print("empty")
            }
        } catch {
            print("error")
        }
    }
}
