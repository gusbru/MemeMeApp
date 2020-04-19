//
//  ViewController.swift
//  MemeMeApp
//
//  Created by Gustavo Brunetto on 2020-04-17.
//  Copyright © 2020 Gustavo Brunetto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlet
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    
    
    // instantiate the delegated class to deal with labels
    let titleDelegate = TitleTextFieldDelegate()
    
    // MARK: properties
    var memedImage: UIImage?
    
    // MARK: lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // setup the labels
        configureTextField(topLabel, text: "TOP")
        configureTextField(bottomLabel, text: "BOTTOM")
        
        // check to enable/disable share button
        checkImage()
        
        // update label
        centerLabel.text = "Pick or take a\npicture"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // check if camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // unsubscribe from keyboard notifications
        unsubstribeFromKeyboardNotifications()
    }
    
    // MARK: component functions

    @IBAction func pickImage(_ sender: Any) {
        
        getImage(source: .photoLibrary)
        
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
        getImage(source: .camera)
        
    }
    
    func getImage(source: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        
        generateMemedImage()
        
        if let image = memedImage {
            let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
            
            // completion handler
            activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
            Bool, arrayReturnedItems: [Any]?, error: Error?) in
                if completed {
                    print("share completed")
                    self.save()
                    return
                } else {
                    print("cancel")
                }
                if let shareError = error {
                    print("error while sharing: \(shareError.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: UIImagePickControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickImage = info[.originalImage] as? UIImage {
            image.image = pickImage
        }
        dismiss(animated: true, completion: nil)
        checkImage()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        checkImage()
    }
    
    // MARK: Keyboard
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubstribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if bottomLabel.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo!
        let keyboardSise = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSise.cgRectValue.height
        
    }
    
    // MARK: Generate Meme
    func generateMemedImage() {
        
        // hidden toolbar
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // generate memed image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // display toolbar
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
    }
    
    func save() {
        print("save meme")
        let meme = Meme(topText: topLabel.text!, bottomText: bottomLabel.text!, originalImage: image.image!, memedImage: memedImage!)
    }
    
    func checkImage() {
        if image.image != nil {
            shareButton.isEnabled = true
            centerLabel.isHidden = true
            leftArrow.isHidden = true
            rightArrow.isHidden = true
        } else {
            shareButton.isEnabled = false
            centerLabel.isHidden = false
            leftArrow.isHidden = false
            rightArrow.isHidden = false
        }
    }
    
    // MARK: Format meme
    func configureTextField(_ textfield: UITextField, text: String) {
        // Delegate
        textfield.delegate = titleDelegate
        
        // default format to labels
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: 5
        ]
        
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
        
        textfield.text = text.uppercased()
    }
    
}

