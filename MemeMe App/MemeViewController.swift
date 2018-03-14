//
//  MemeViewController.swift
//  MemeMe App
//
//  Created by Pedro De Morais Chiossi on 11/03/18.
//  Copyright © 2018 Pedro Chiossi. All rights reserved.
//
import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Custom TextAttributes
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5.0]
    
    // MARK: Outlets
    
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    // MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set defaults
        pickedImageView.contentMode = .scaleAspectFit
        configure(topTextField, defaultText: "TOP")
        configure(bottomTextField, defaultText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera button if not available, share button disabled without an image.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = pickedImageView.image != nil
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func configure(_ textField: UITextField, defaultText: String){
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .center
    }
    
    
    
    //MARK: Notification methods
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
        self.navigationController?.navigationBar.alpha = 1.0
        
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
            
            view.frame.origin.y -= getKeyboardHeight(notification)
            // alpha changed to see bottom text
            self.navigationController?.navigationBar.alpha = 0.0
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    // MARK: Image methods
    
    // Get image from ImagePickerController and load on imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[ UIImagePickerControllerOriginalImage] as? UIImage{
            pickedImageView.image = image
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickanImage(from: .camera)
    }
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickanImage(from: .photoLibrary)
    }
    
    
    func pickanImage(from source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func navToolbarHide(_ hide: Bool){
        toolbar.isHidden = hide
        self.navigationController?.setNavigationBarHidden(hide,animated: true)
        
    }
    
    
    // MARK: Meme methods
    
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
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
            pickedImageView.image = nil
            topTextField?.text = "TOP"
            bottomTextField?.text = "BOTTOM"
            self.view.setNeedsDisplay()
        }
        
}
