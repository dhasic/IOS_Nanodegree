//
//  MemeDetailViewController.swift
//  MeemMe
//
//  Created by Hasic Dalmir on 11/06/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var imageOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentMode = UIViewContentMode.ScaleAspectFit
        
        imageOutlet.image = meme.memedImage
        imageOutlet.contentMode = contentMode
    }
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(controller, animated: true, completion: {
            controller.instantiateMeme(self.meme)
        
        })
    
    }
    
    
}