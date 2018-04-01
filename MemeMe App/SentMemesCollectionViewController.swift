//
//  SentMemesCollectionViewController.swift
//  MemeMe App
//
//  Created by Pedro De Morais Chiossi on 29/03/18.
//  Copyright © 2018 Pedro Chiossi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!  
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    
    var memes: [Meme]! {
        
        get {
            return (UIApplication.shared.delegate as! AppDelegate).memes
        }
        
        set {
            (UIApplication.shared.delegate as! AppDelegate).memes = newValue
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.collectionView?.reloadData()
    }
    
    
   

    @IBAction func addMeme(_ sender: Any) {
        let editorVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editorVC.memeToEdit = nil
        present(editorVC, animated: true, completion: nil)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let selectedMeme = self.memes[indexPath.item]
        cell.MemeImageVIew?.image = selectedMeme.memedImage
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = self.memes[indexPath.row]
        detailVC.memeIndex = indexPath.row
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
  

}
