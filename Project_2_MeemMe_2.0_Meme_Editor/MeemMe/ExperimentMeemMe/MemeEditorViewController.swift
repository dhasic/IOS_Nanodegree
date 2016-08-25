//
//  MemeEditorViewController.swift
//  MeemMe
//
//  Created by Hasic Dalmir on 06/04/16.
//  Copyright (c) 2016 abc. All rights reserved.
//
import Foundation
import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate, UIBarPositioningDelegate, UINavigationBarDelegate  {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var navigationBarOutlet: UINavigationBar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolbarOutlet: UIToolbar!
    
    
    @IBOutlet weak var fontNameLabel: UILabel!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontField: UITextField!
    @IBOutlet weak var topTextBox: UITextField!
    @IBOutlet weak var bottomTextBox: UITextField!
    
    var savedMeme: Meme?
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -3.0    ]
    
    let fonts =  ["Impact", "Avenir-LightOblique", "AvenirNext-BoldItalic","GillSans-UltraBold", "HelveticaNeue-Light","PartyLetPlain","PingFangSC-Semibold ","SnellRoundhand-Bold"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTextFields(topTextBox, text: "TOP")
        initializeTextFields(bottomTextBox, text: "BOTTOM")
        initializeFontField()

        shareButton.enabled = false

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func initializeTextFields(textField: UITextField, text: String) {
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.backgroundColor = UIColor.clearColor()
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = self
    }
    
    //This method initializes picker controller for picking fonts
    func initializeFontField() {
        fontField.delegate = self
        var fontPickerView: UIPickerView
        fontPickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        fontPickerView.backgroundColor = .whiteColor()
        fontPickerView.dataSource = self
        fontPickerView.delegate = self
        fontField.inputView = fontPickerView
    }

    
    @IBAction func share(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activitiyController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activitiyController.completionWithItemsHandler = { (activityType, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) in
            if completed {
                self.savedMeme = self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activitiyController, animated: true, completion: nil)
    }
    

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromLibrary(sender: AnyObject) {
      pickAnImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
 
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImage(UIImagePickerControllerSourceType.Camera)
    }
    
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil )
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageViewOutlet.image = image
        
        let contentMode = UIViewContentMode.ScaleAspectFit
        imageViewOutlet.contentMode = contentMode
        
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if(bottomTextBox.editing ){
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        if(bottomTextBox.editing ){
            view.frame.origin.y = 0
        }
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {

        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = ""
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func generateMemedImage () -> UIImage{
        
        navigationBarOutlet.hidden = true
        toolbarOutlet.hidden = true
        fontLabel.hidden = true
        fontNameLabel.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationBarOutlet.hidden = false
        toolbarOutlet.hidden = false
        fontLabel.hidden = false
        fontNameLabel.hidden = false
        
        return memedImage
    }
    
    
    func save(memedImage: UIImage) -> Meme {
        let meme = Meme(topText: topTextBox.text, bottomText: bottomTextBox.text, originalImage: imageViewOutlet.image, memedImage: generateMemedImage())
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        return meme
    }
    
    //Hides the statusBar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setFonts(fontName:String) {
        fontLabel.text = fontName
        topTextBox.font = UIFont(name: fontName, size: 40)!
        bottomTextBox.font = UIFont(name: fontName, size: 40)!
    }
    
    func instantiateMeme(meme: Meme) {
        topTextBox.text = meme.topText
        bottomTextBox.text = meme.bottomText
        imageViewOutlet.image = meme.originalImage
        
        let contentMode = UIViewContentMode.ScaleAspectFit
        imageViewOutlet.contentMode = contentMode
        
        shareButton.enabled = true
    }
    
}
extension MemeEditorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fonts.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setFonts(fonts[row])
        fontField.resignFirstResponder()
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fonts[row]
    }

}

