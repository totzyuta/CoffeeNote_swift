//
//  EditViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/8/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

  @IBOutlet weak var blendNameTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var nid = Int(appDelegate.nid!)
    
    // sqlite from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    let _db = FMDatabase(path: _path)
    
    _db.open()
    
    let sql_select = "SELECT * FROM notes WHERE nid=\(nid);"
    var rows = _db.executeQuery(sql_select, withArgumentsInArray: nil)
    while rows.next() {
      self.blendNameTextField.text = rows.stringForColumn("blendName")
    }
    
  }
  
  
  @IBAction func pushedDeleteButton(sender: AnyObject) {
    
    let alertController = UIAlertController(title: "Deleting This Note", message: "Are you sure to delete?", preferredStyle: .ActionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
      println("Cancel button tapped.")
    }
    
    
    let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
      println("OK button tapped.")
      
      /* Delete Note */
      
      var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegatのインスタンスを取得
      var nid = Int(appDelegate.nid!)
      
      // sql from here
      let _dbfile:NSString = "sqlite.db"
      let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
        NSSearchPathDirectory.DocumentDirectory,
        NSSearchPathDomainMask.UserDomainMask,
        true)[0]
      let fileManager:NSFileManager = NSFileManager.defaultManager()
      let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
      
      let db = FMDatabase(path: _path)
      
      let sql_delete = "DELETE FROM notes WHERE nid=\(nid);"
      
      db.open()
      
      if db.executeUpdate(sql_delete, withArgumentsInArray: nil) {
        println("Delete notes nid: \(nid)")
        
        // remove image file
        // - (BOOL)removeFilePath:(NSString*)path;
        // NSFileManager *fileManager = [[NSFileManager alloc] init];
        // return [fileManager removeItemAtPath:path error:NULL];
        var fileManager = NSFileManager()
        let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        if fileManager.removeItemAtPath(filePath+"/img\(nid).png", error: nil) {
          println("Deleted img file (Path: \(filePath)/img\(nid).png")
        }
      }
      
      db.close()
      
      self.performSegueWithIdentifier("unwindFromEditByDeleteButton", sender: self)
      
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(okAction)
    
    presentViewController(alertController, animated: true, completion: nil)
    
  }


  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    println("prepareForSegue was called!")
    
    println(segue.identifier)
    
    if (segue.identifier == "unwindToDetailBySave") {
      
      // sqlite from here
      let _dbfile:NSString = "sqlite.db"
      let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
        NSSearchPathDirectory.DocumentDirectory,
        NSSearchPathDomainMask.UserDomainMask,
        true)[0]
      let fileManager:NSFileManager = NSFileManager.defaultManager()
      let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
      let _db = FMDatabase(path: _path)
      
      _db.open()
      
      var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      var nid = Int(appDelegate.nid!)
      
      if (self.blendNameTextField.text != nil) {
        let sql_update = "UPDATE notes SET blendName='\(self.blendNameTextField.text)' WHERE nid=\(nid);"
        var _result_insert = _db.executeUpdate(sql_update, withArgumentsInArray: nil)
        
        /* Debug for comfirm the inserted data */
        
        let sql_select = "SELECT * FROM notes WHERE nid=\(nid);"
        var rows = _db.executeQuery(sql_select, withArgumentsInArray: nil)
        while rows.next() {
          let nid = rows.intForColumn("nid")
          let blendName = rows.stringForColumn("blendName")
          println("UPDATED: nid = \(nid), blendName = \(blendName)")
        }
      }else {
        println("Not Updated")
      }

      _db.close()
      
    }
    
  
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


}