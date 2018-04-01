//
//  MemeDetailViewController.swift
//  MemeMe App
//
//  Created by Pedro De Morais Chiossi on 29/03/18.
//  Copyright © 2018 Pedro Chiossi. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    var memeIndex: Int!

    @IBOutlet weak var detailImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMemeInDetail(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailImage?.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func editMemeInDetail(_ sender: Any) {
        let editorVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editorVC.memeToEdit = meme
        editorVC.memeToEditIndex = memeIndex
        present(editorVC, animated: true, completion: nil)
    }
    
}
