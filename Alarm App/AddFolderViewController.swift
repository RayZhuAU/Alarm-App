//
//  AddFolderViewController.swift
//  Alarm App
//
//  Created by Ray Zhu on 17/08/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import UIKit
import RealmSwift

class AddFolderViewController: UIViewController {

    @IBOutlet weak var folderTitleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        let newFolder = Folder()
        if folderTitleTextField.text?.isEmpty == true {
            newFolder.title = "Folder"
        }
        else {
            newFolder.title = folderTitleTextField.text!
        }
        newFolder.image = "folder"
        newFolder.activated = true
        RealmHelper.addFolder(newFolder)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
