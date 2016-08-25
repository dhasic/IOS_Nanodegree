//
//  MemeTableViewController.swift
//  MeemMe
//
//  Created by Hasic Dalmir on 11/06/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        controller.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! MemeTableViewCell
        cell.imageOutlet.image = memes[indexPath.row].memedImage
        cell.cellText.text = "\(memes[indexPath.row].topText!) ... \(memes[indexPath.row].bottomText!)"
        let contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageOutlet.contentMode = contentMode
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        // add the action button you want to show when swiping on tableView's cell , in this case add the delete button.
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action , indexPath) -> Void in
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            
            
        })
        
        // You can set its properties like normal button
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
}