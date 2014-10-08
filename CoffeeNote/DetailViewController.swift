//
//  DetailViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var blendNameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    println("---DetailViewDidLoad---")
  }
  
  override func viewWillAppear(animated: Bool) {
    println("---DetailViewWillAppear---")

    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegatのインスタンスを取得
    var nid = Int(appDelegate.nid!)
    println("nid: \(nid)")

    // sql from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
    let db = FMDatabase(path: _path)
    
    
    let sql_select = "SELECT * FROM notes WHERE nid=\(nid)"
    
    db.open()
    
    var rows = db.executeQuery(sql_select, withArgumentsInArray: nil)
    
    // fetch data and put data into label
    while rows.next() {
      // let blendNames = rows.stringForColumnIndex(1)
      var blendName: String = rows.stringForColumn("blendName")
      // Put data to label
      self.blendNameLabel.text = blendName
      println(blendName)
    }
    
    db.close()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func pushedEditButton(sender: AnyObject) {
    
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
      }
      db.close()
      
      self.performSegueWithIdentifier("unwindFromDetail", sender: self)
      
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(okAction)
    
    presentViewController(alertController, animated: true, completion: nil)
    
  }
  
  
  @IBAction func unwindToDetailByCancel(segue: UIStoryboardSegue) {
    NSLog("unwindToAllByCancel was called")
  }
  
  
  @IBAction func unwindToDetailBySave(segue: UIStoryboardSegue) {
    NSLog("unwindToAllBySave was called")
  }
  
  
  
}
