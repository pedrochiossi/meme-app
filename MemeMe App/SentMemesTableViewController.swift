//
//  SentMemesTableViewController.swift
//  MemeMe App
//
//  Created by Pedro De Morais Chiossi on 29/03/18.
//  Copyright © 2018 Pedro Chiossi. All rights reserved.
//

import UIKit
import Foundation

private let cellIdentifier = "MemeTableViewCell"

class SentMemesTableViewController: UITableViewController {
    

    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    
    
    var memes: [Meme]! {
        
        get {
            return (UIApplication.shared.delegate as! AppDelegate).memes
        }
        
        set {
            (UIApplication.shared.delegate as! AppDelegate).memes = newValue
        }
        
    }
    
  
    
    @IBAction func addMeme(_ sender: Any) {
        let editorVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editorVC.memeToEdit = nil
        present(editorVC, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tableView?.reloadData()
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MemeTableViewCell
        let selectedMeme = self.memes[indexPath.row]
        cell.memeImage.image = selectedMeme.memedImage
        cell.memeLabel.text = "\(selectedMeme.topText)...\(selectedMeme.bottomText)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = self.memes[indexPath.row]
        detailVC.memeIndex = indexPath.row
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    @IBAction func unwindToTableView(segue: UIStoryboardSegue) {
        
    }
    
}
