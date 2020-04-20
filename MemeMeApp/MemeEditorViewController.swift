//
//  ViewController.swift
//  MemeMeApp
//
//  Created by Gustavo Brunetto on 2020-04-17.
//  Copyright © 2020 Gustavo Brunetto. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    var tableViewController: UITableViewController?
    var collectionViewController: UICollectionViewController?
    
    // MARK: lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the labels
        configureTextField(topLabel, text: "TOP")
        configureTextField(bottomLabel, text: "BOTTOM")
        
        // check to enable/disable share button
        checkImage()
        
        // update label
        centerLabel.text = "Pick or take a\npicture"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check if camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
                    self.save()
                    
                    // update table
                    if let tableViewController = self.tableViewController {
                        tableViewController.tableView.reloadData()
                    }
                    
                    // update collection
                    if let collectionViewController = self.collectionViewController {
                        collectionViewController.collectionView.reloadData()
                    }
                    
                    self.closeView()
                    return
                } else {
                    self.closeView()
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
        
        hideTollbar()
        
        // generate memed image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        showToolbar()
        
    }
    
    func hideTollbar() {
        
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
    }
    
    func showToolbar() {
        
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
    }
    
    func save() {
        print("save meme")
        let meme = Meme(topText: topLabel.text!, bottomText: bottomLabel.text!, originalImage: image.image!, memedImage: memedImage!)
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memesList.append(meme)
        
    }
    
    func checkImage() {
        let flag = image.image != nil
        shareButton.isEnabled = flag
        centerLabel.isHidden = flag
        leftArrow.isHidden = flag
        rightArrow.isHidden = flag
        
    }
    
    // MARK: Format meme
    func configureTextField(_ textfield: UITextField, text: String) {
        // Delegate
        textfield.delegate = titleDelegate
        
        // default format to labels
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.0
        ]
        
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
        
        textfield.text = text.uppercased()
    }
    
    // MARK: close view
    @IBAction func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
}

