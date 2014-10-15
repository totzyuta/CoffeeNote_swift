//
//  EditViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/8/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var mainView: UIView!
  
  @IBOutlet weak var coffeeImageView: UIImageView!
  @IBOutlet weak var cameraButtonImageView: UIButton!
  @IBOutlet weak var blendNameTextField: UITextField!
  @IBOutlet weak var originTextField: UITextField!
  @IBOutlet weak var placeTextField: UITextField!
  @IBOutlet weak var roastSegmentedControl: UISegmentedControl!
  @IBOutlet weak var darkSegmentedControl: UISegmentedControl!
  @IBOutlet weak var bodySegmentedControl: UISegmentedControl!
  @IBOutlet weak var aciditySegmentedControl: UISegmentedControl!
  @IBOutlet weak var flavorSegmentedControl: UISegmentedControl!
  @IBOutlet weak var sweetnessSegmentedControl: UISegmentedControl!
  @IBOutlet weak var cleanCupSegmentedControl: UISegmentedControl!
  @IBOutlet weak var aftertasteSegmentedControl: UISegmentedControl!
  @IBOutlet weak var overallSegmentedControl: UISegmentedControl!
  @IBOutlet weak var commentTextView: UITextView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.scrollView.contentSize = self.mainView.bounds.size
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var nid = Int(appDelegate.nid!)
    
    let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let imageFilePath = filePath+"/img\(nid).png"
    
    var imgfileManager = NSFileManager()
    if (imgfileManager.fileExistsAtPath(imageFilePath)) {
      coffeeImageView.image = UIImage(named: imageFilePath)
      cameraButtonImageView.hidden = true
    }
    
    
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
      self.originTextField.text = rows.stringForColumn("origin")
      self.placeTextField.text = rows.stringForColumn("place")
      self.roastSegmentedControl.selectedSegmentIndex = Int(rows.intForColumn("roast")-1)
      self.darkSegmentedControl.selectedSegmentIndex = Int(rows.intForColumn("dark")-1)
      self.bodySegmentedControl.selectedSegmentIndex = Int(rows.intForColumn("body")-1)
      self.aciditySegmentedControl.selectedSegmentIndex = Int(rows.intForColumn("acidity")-1)
      self.flavorSegmentedControl.selectedSegmentIndex = Int(rows.intForColumn("flavor")-1)
      self.sweetnessSegmentedControl.selectedSegmentIndex = Int(rows.intForColumn("sweetness")-1)
      self.cleanCupSegmentedControl.selectedSegmentIndex = Int(rows.intForColumn("cleancup")-1)
      self.aftertasteSegmentedControl.selectedSegmentIndex = Int(rows.intForColumn("aftertaste")-1)
      self.overallSegmentedControl.selectedSegmentIndex = Int(rows.intForColumn("overall")-1)
      self.commentTextView.text = rows.stringForColumn("comment")
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
      
      
      // To avoid error of single quotation
      var blendNameTextFieldModified = blendNameTextField.text.stringByReplacingOccurrencesOfString("\'", withString: "\'\'", options: nil, range: nil)
      var originTextFieldModified = originTextField.text.stringByReplacingOccurrencesOfString("\'", withString: "\'\'", options: nil, range: nil)
      var placeTextFieldModified = placeTextField.text.stringByReplacingOccurrencesOfString("\'", withString: "\'\'", options: nil, range: nil)
      var commentTextFieldModified = commentTextView.text.stringByReplacingOccurrencesOfString("\'", withString: "\'\'", options: nil, range: nil)
      
      // let sql_update = "UPDATE notes SET blendName='\(self.blendNameTextField.text)' WHERE nid=\(nid);"
      let sql_update = "UPDATE notes SET blendName='\(blendNameTextFieldModified)', origin='\(originTextFieldModified)', place='\(placeTextFieldModified)', roast='\(roastSegmentedControl.selectedSegmentIndex+1)', dark=\(darkSegmentedControl.selectedSegmentIndex+1), body=\(bodySegmentedControl.selectedSegmentIndex+1), acidity=\(aciditySegmentedControl.selectedSegmentIndex+1), flavor=\(flavorSegmentedControl.selectedSegmentIndex+1), sweetness=\(sweetnessSegmentedControl.selectedSegmentIndex+1), cleancup=\(cleanCupSegmentedControl.selectedSegmentIndex+1), aftertaste=\(aftertasteSegmentedControl.selectedSegmentIndex+1), overall=\(overallSegmentedControl.selectedSegmentIndex+1), comment='\(commentTextFieldModified)' WHERE nid=\(nid);"
      var _result_insert = _db.executeUpdate(sql_update, withArgumentsInArray: nil)
      
      
      /* Debug to comfirm the inserted data */
      
      let sql_select = "SELECT * FROM notes WHERE nid=\(nid);"
      var rows = _db.executeQuery(sql_select, withArgumentsInArray: nil)
      while rows.next() {
        let nid = rows.intForColumn("nid")
        let blendName = rows.stringForColumn("blendName")
        println("UPDATED: nid = \(nid), blendName = \(blendName)")

      _db.close()
        
      }
      
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