//
//  ViewController.swift
//  lab5
//
//  Created by Elnara  on 4/26/20.
//  Copyright © 2020 Elnara . All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var documentsDirectoryURL: URL!
    var filesList: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        documentsDirectoryURL = try! FileManager.default.url(for: .documentDirectory,
                                                                 in: .userDomainMask,
                                                                 appropriateFor: nil,
                                                                 create: true)
        filesList = FileService.shared.downloadFiles(documentsDirectoryURL)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.rightBarButtonItem = .init(title: "♫", style: .plain, target: self, action: #selector(addMusic))
        navigationItem.leftBarButtonItem = .init(title: "📁", style: .plain, target: self, action: #selector(addFolder))
        documentsDirectoryURL = try! FileManager.default.url(for: .documentDirectory,
                                                                 in: .userDomainMask,
                                                                 appropriateFor: nil,
                                                                 create: true)
        filesList = FileService.shared.downloadFiles(documentsDirectoryURL)
        collectionView.reloadData()
    }
    
    @objc private func addMusic(){
        if let viewController = storyboard?.instantiateViewController(identifier: "MusicVC") as? MusicsViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc private func addFolder(){
        
        let alertCreate = UIAlertController(title: "Create Folder", message: "", preferredStyle: .alert)
        
        alertCreate.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "enter"
        }
        
        let save = UIAlertAction(title: "add", style: .default, handler: {alert -> Void in
            let textField = alertCreate.textFields![0] as UITextField
            let folderName = textField.text!
            
            let folder = self.documentsDirectoryURL.path + "/" + folderName
            
            
            if !FileManager.default.fileExists(atPath: folder){
                do{
                    try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print("error")
                    }
                } else {
                    let alertError = UIAlertController(title: "Error", message: "Folder with this name already exists, try one more time", preferredStyle: .alert)
                    alertError.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alertError, animated: true, completion: nil)
                }
        })
        alertCreate.addAction(save)
        
        let cancel = UIAlertAction(title: "cancel", style: .default, handler: nil )
        alertCreate.addAction(cancel)
        self.collectionView.reloadData()
        self.present(alertCreate, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = filesList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.deleteButton.tag = indexPath.row
        if item.pathExtension == "m4a" {
            let fileIcon = UIImage.icon(item)
            cell.imageView.image = fileIcon
        } else {
            cell.imageView.image = UIImage(systemName: "folder.fill")
        }
        
        cell.label.text = item.lastPathComponent
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3
        return CGSize(width: width, height: width)
    }
}

extension UIImage {
    public class func icon(_ fileURL: URL) -> UIImage? {
        let myInteractionController = UIDocumentInteractionController(url: fileURL)
        let allIcons = myInteractionController.icons
        return allIcons.first!
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = filesList[indexPath.row]
        
        if item.pathExtension == "m4a" {
            let name = item.lastPathComponent
            print (name)
            if let vc = storyboard?.instantiateViewController(identifier: "MusicPlayerVC") as? MusicPlayerViewController {
                vc.name.text = name
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.documentsDirectoryURL = item
            self.collectionView.reloadData()
        }
    }
}
