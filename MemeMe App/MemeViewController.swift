//
//  MemeViewController.swift
//  MemeMe App
//
//  Created by Pedro De Morais Chiossi on 11/03/18.
//  Copyright © 2018 Pedro Chiossi. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    
    // MARK: Outlets

    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
   
    
    
    // initializing custom attributes
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5.0]
    
    // creating Meme object for saving
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //set delegates
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        
        //set defaults
        pickedImageView.contentMode = .scaleAspectFit
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        topTextField?.text = "TOP"
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        bottomTextField?.text = "BOTTOM"
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera button if not available, share button disabled without an image
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = pickedImageView.image != nil
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    

    
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    // clear default text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // restore default text
    func textFieldDidEndEditing(_ textField: UITextField) {
        if topTextField.text!.isEmpty{
            topTextField.text = "TOP"
        }
        else if bottomTextField.text!.isEmpty{
            bottomTextField.text = "BOTTOM"
        }
    }
    
  
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // get image from ImagePickerController and load on imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[ UIImagePickerControllerOriginalImage] as? UIImage{
            pickedImageView.image = image
            dismiss(animated: true, completion: nil)
        }
    
    }
    
    
    
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        }
    
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func navToolbarHide(_ hide: Bool){
        toolbar.isHidden = hide
        self.navigationController?.setNavigationBarHidden(hide,animated: true)

    }
    
    
  
    func savememe(memedImage: UIImage) {
        // create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: pickedImageView.image!, memedImage: memedImage)
    }
    
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navToolbarHide(true)
   
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navToolbarHide(false)
        return memedImage
    }
    
    
    @IBAction func shareMeme(_ sender: Any) {
        let memeToShare = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {activity, success, items, error in
        if success{
            self.savememe(memedImage: memeToShare)
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
            
        
    @IBAction func cancelMeme(_ sender: Any) {
        pickedImageView.image = nil
        topTextField?.text = "TOP"
        bottomTextField?.text = "BOTTOM"
        self.view.setNeedsDisplay()
    }
    
    
    
    
}

