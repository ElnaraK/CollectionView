//
//  ImageService.swift
//  lab5
//
//  Created by Elnara  on 4/28/20.
//  Copyright © 2020 Elnara . All rights reserved.
//

import Foundation
import UIKit

class ImageService {

    static let shared = ImageService()
    
    func downloadImage(image: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = image else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
}
