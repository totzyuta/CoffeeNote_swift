//
//  EditViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/8/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate {

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
    
    // self.scrollView.contentSize = self.mainView.bounds.size
    
    // to hide keyboard
    self.placeTextField.delegate = self
    
    // change title of navigation bar
    var title = UILabel()
    title.font = UIFont.boldSystemFontOfSize(16)
    // title.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    title.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    title.text = "Edit Coffee Note"
    title.sizeToFit()
    self.navigationItem.titleView = title;
    
    
    // to show aleart when not to have camera in device
    if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
      var myAlertView = UIAlertView()
      myAlertView.title = "Alert"
      myAlertView.message = "There's no camera on this device."
      myAlertView.addButtonWithTitle("Okay")
      myAlertView.show()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    println("--- EditView --- viewWillAppear called!!")
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
    
    _db.close()
    
  }
  
  override func viewDidAppear(animated: Bool) {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var nid = Int(appDelegate.nid!)
    // set image
    if ((appDelegate.editImage) != nil) {
      // set new image (editImage)
      coffeeImageView.image = appDelegate.editImage
      println("appDelegate.editImage exists. New image set")
    }else {
      // set old image
      println("appDelegate.editImage NOT exists")
      let filePath = appDelegate.filePath
      let imageFilePath = filePath!+"/img\(nid).jpg"
      var imgfileManager = NSFileManager()
      if (imgfileManager.fileExistsAtPath(imageFilePath)) {
        coffeeImageView.image = UIImage(contentsOfFile: imageFilePath)
        println(imageFilePath)
      }else{
        coffeeImageView.image = UIImage(named: "img1.jpg")
      }
    }

  }
  
  
  // MARK: HideTextField
  
  @IBAction func blendNameTextField_finishEditing(sender: AnyObject) {
    self.originTextField.becomeFirstResponder()
  }
  
  @IBAction func originTextField_finishEditing(sender: AnyObject) {
    self.placeTextField.becomeFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  
  // MARK: - Photo
  
  func takePhoto(sender: AnyObject) {
    var picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = UIImagePickerControllerSourceType.Camera
    self.presentViewController(picker, animated: true, completion: nil)
  }
  
  func selectPhoto(sender: AnyObject) {
    var picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(picker, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    
    // set image to imageView
    var chosenImage = info[UIImagePickerControllerEditedImage] as UIImage
    picker.dismissViewControllerAnimated(true, completion: nil)
    // save the image to appDelegate.editImage
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    println(appDelegate.editImage)
    appDelegate.editImage = chosenImage
    println("Saved appDelegate.editImage")
    println(appDelegate.editImage)
   
    self.cameraButtonImageView.alpha = 0.5
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    // [picker dismissViewControllerAnimated:YES completion:NULL];
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  @IBAction func pushCameraButton(sender: AnyObject) {
    var sheetCamera = UIActionSheet()
    sheetCamera.title = "Set Photo of Coffee"
    sheetCamera.delegate = self
    sheetCamera.addButtonWithTitle("Take Photo by Camera")
    sheetCamera.addButtonWithTitle("Select Photo from Cameraroll")
    sheetCamera.addButtonWithTitle("Cancel")
    sheetCamera.cancelButtonIndex = 2
    
    sheetCamera.tag = 0
    
    sheetCamera.showInView(self.view)
  }
  

  
  // MARK: Delete Button
  
  @IBAction func pushedDeleteButton(sender: AnyObject) {
    var sheet = UIActionSheet()
    sheet.title = "Deleting This Note"
    sheet.delegate = self
    sheet.addButtonWithTitle("OK")
    sheet.addButtonWithTitle("Cancel")
    sheet.cancelButtonIndex = 1
    
    sheet.tag = 1
    
    sheet.showInView(self.view)
  }
  
  // 0: CameraButton / 1: DeleteButton
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    switch (actionSheet.tag) {
    case 0:
      /* Photo ActionSheet */
      if (buttonIndex==0) {
        // take photo
        self.takePhoto(self)
      }else if(buttonIndex==1) {
        // select photo
        self.selectPhoto(self)
      }else {
        // cancel
      }
      break
    case 1:
      /* Delete ActionSheet */
      if (buttonIndex==1) {
        // Cancel Button
        println("Cancel button tapped.")
      }else{
        // OK Button
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
          var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegateのインスタンスを取得
          var filePath = appDelegate.filePath
          // let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
          if fileManager.removeItemAtPath(filePath!+"/img\(nid).img", error: nil) {
            println("Deleted img file (Path: \(filePath)/img\(nid).img")
          }
        }
        
        db.close()
        
        self.performSegueWithIdentifier("unwindFromEditByDeleteButton", sender: self)
        
        break
      }
    default:
      break
    }
    
  }
  

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    println("prepareForSegue was called!")
    
    println(segue.identifier)
    
    if (segue.identifier == "unwindToDetailBySave") {
      
      // MARK: Save Data
      
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
      
      // save photo
      if (appDelegate.editImage != nil) {
        // save image in DocumentDirectory
        // var data: NSData = UIImagePNGRepresentation(coffeeImageView.image)
        var data: NSData = UIImageJPEGRepresentation(coffeeImageView.image, 1.0)
        let filePath = appDelegate.filePath!
        // let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var imageFilePath = filePath+"/img\(nid).jpg"
        /*if (fileManager.removeItemAtPath(imageFilePath, error: nil)) {
          println("Delete old photo")
        }*/
        if (data.writeToFile(imageFilePath, atomically: true)) {
          println("Save Photo Suceeded(filePath: \(imageFilePath))")
        }else {
          println("Failed to save photo(filePath: \(imageFilePath))")
        }
        appDelegate.editImage = nil
      }
      
      
      
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