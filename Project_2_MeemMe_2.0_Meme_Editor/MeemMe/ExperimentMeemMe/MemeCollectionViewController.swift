//
//  MemeCollectionViewController.swift
//  MeemMe
//
//  Created by Hasic Dalmir on 11/06/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  
    @IBAction func moveToMemeEditor(sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        
        let space: CGFloat = 3.0
        var dimensions: CGFloat = 0.0
      
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            dimensions  = (view.frame.size.height - (4 * space))/5.0
            
        } else {
            dimensions = (view.frame.size.width - (2 * space))/3.0
        }
        
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimensions,dimensions)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
    
        cell.imageOutlet.image = memes[indexPath.row].memedImage
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        controller.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

    
}