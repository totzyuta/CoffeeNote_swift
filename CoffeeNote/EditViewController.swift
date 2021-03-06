//
//  EditViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/8/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, GADBannerViewDelegate {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var roastLabel: UILabel!
  @IBOutlet weak var darkLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var flavorLabel: UILabel!
  @IBOutlet weak var acidityLabel: UILabel!
  @IBOutlet weak var sweetnessLabel: UILabel!
  @IBOutlet weak var cleancupLabel: UILabel!
  @IBOutlet weak var aftertasteLabel: UILabel!
  @IBOutlet weak var overallLabel: UILabel!
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  
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
    let title = UILabel()
    title.font = UIFont.boldSystemFontOfSize(16)
    // title.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    title.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    title.text = NSLocalizedString("titleEditView", comment: "comment")
    title.sizeToFit()
    self.navigationItem.titleView = title;
   
    // set localized value
    blendNameTextField.placeholder = NSLocalizedString("blendName", comment: "comment")
    originTextField.placeholder = NSLocalizedString("origin", comment: "comment")
    placeTextField.placeholder = NSLocalizedString("place", comment: "comment")
    roastLabel.text = NSLocalizedString("roast", comment: "comment")
    darkLabel.text = NSLocalizedString("dark", comment: "comment")
    bodyLabel.text = NSLocalizedString("body", comment: "comment")
    flavorLabel.text = NSLocalizedString("flavor", comment: "comment")
    acidityLabel.text = NSLocalizedString("acidity", comment: "comment")
    sweetnessLabel.text = NSLocalizedString("sweetness", comment: "comment")
    cleancupLabel.text = NSLocalizedString("cleancup", comment: "comment")
    aftertasteLabel.text = NSLocalizedString("aftertaste", comment: "comment")
    overallLabel.text = NSLocalizedString("overall", comment: "comment")
    commentLabel.text = NSLocalizedString("comment", comment: "comment")
    deleteButton.titleLabel?.text = NSLocalizedString("deleteNote", comment: "comment")
    roastSegmentedControl.setTitle(NSLocalizedString("light", comment: "comment"), forSegmentAtIndex: 0)
    roastSegmentedControl.setTitle(NSLocalizedString("medium", comment: "comment"), forSegmentAtIndex: 1)
    roastSegmentedControl.setTitle(NSLocalizedString("dark", comment: "comment"), forSegmentAtIndex: 2)
    darkSegmentedControl.setTitle(NSLocalizedString("light", comment: "comment"), forSegmentAtIndex: 0)
    darkSegmentedControl.setTitle(NSLocalizedString("medium", comment: "comment"), forSegmentAtIndex: 1)
    darkSegmentedControl.setTitle(NSLocalizedString("full", comment: "comment"), forSegmentAtIndex: 2)
    bodySegmentedControl.setTitle(NSLocalizedString("light", comment: "comment"), forSegmentAtIndex: 0)
    bodySegmentedControl.setTitle(NSLocalizedString("medium", comment: "comment"), forSegmentAtIndex: 1)
    bodySegmentedControl.setTitle(NSLocalizedString("heavy", comment: "comment"), forSegmentAtIndex: 2)
    
    // textField from Capital letter
    blendNameTextField.autocapitalizationType = UITextAutocapitalizationType.Sentences
    originTextField.autocapitalizationType = UITextAutocapitalizationType.Sentences
    placeTextField.autocapitalizationType = UITextAutocapitalizationType.Sentences
    
    // to show aleart when not to have camera in device
    if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
      let myAlertView = UIAlertView()
      myAlertView.title = "Alert"
      myAlertView.message = "There's no camera on this device."
      myAlertView.addButtonWithTitle("Okay")
      myAlertView.show()
    }
    
    /* Ad Setting */
    let origin = CGPointMake(0.0,
        self.view.frame.size.height -
            CGSizeFromGADAdSize(kGADAdSizeBanner).height); // place at bottom of view

    let size = GADAdSizeFullWidthPortraitWithHeight(50) // set size to 50
    let adB = GADBannerView(adSize: size, origin: origin) // create the banner
    let config = Config()
    adB.adUnitID = config.setAdUnitId()
    adB.delegate = self // ??
    adB.rootViewController = self // ??
    self.view.addSubview(adB) // ??
    let request = GADRequest() // create request
    request.testDevices = [ GAD_SIMULATOR_ID ]; // set it to "test" request
    adB.loadRequest(request) // actually load it (?
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    print("--- EditView --- viewWillAppear called!!")
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let nid = Int(appDelegate.nid!)
    
    
    // sqlite from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile as String)
    let _db = FMDatabase(path: _path)
    
    _db.open()
    
    let sql_select = "SELECT * FROM notes WHERE nid=\(nid);"
    let rows = _db.executeQuery(sql_select, withArgumentsInArray: nil)
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
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let nid = Int(appDelegate.nid!)
    // set image
    if ((appDelegate.editImage) != nil) {
      // set new image (editImage)
      coffeeImageView.image = appDelegate.editImage
      print("appDelegate.editImage exists. New image set")
    }else {
      // set old image
      print("appDelegate.editImage NOT exists")
      let filePath = appDelegate.filePath
      let imageFilePath = filePath!+"/img\(nid).jpg"
      let imgfileManager = NSFileManager()
      if (imgfileManager.fileExistsAtPath(imageFilePath)) {
        coffeeImageView.image = UIImage(contentsOfFile: imageFilePath)
        print(imageFilePath)
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
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = UIImagePickerControllerSourceType.Camera
    self.presentViewController(picker, animated: true, completion: nil)
  }
  
  func selectPhoto(sender: AnyObject) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(picker, animated: true, completion: nil)
  }
 
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    
    picker.dismissViewControllerAnimated(true, completion: nil)
    // save the image to appDelegate.editImage
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    print(appDelegate.editImage)
    appDelegate.editImage = image
    print("Saved appDelegate.editImage")
    print(appDelegate.editImage)
   
    self.cameraButtonImageView.alpha = 0.5
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    // [picker dismissViewControllerAnimated:YES completion:NULL];
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  @IBAction func pushCameraButton(sender: AnyObject) {
    let sheetCamera = UIActionSheet()
    sheetCamera.title = NSLocalizedString("setPhoto", comment: "comment")
    sheetCamera.delegate = self
    sheetCamera.addButtonWithTitle(NSLocalizedString("takePhoto", comment: "comment"))
    sheetCamera.addButtonWithTitle(NSLocalizedString("selectPhoto", comment: "comment"))
    sheetCamera.addButtonWithTitle(NSLocalizedString("cancel", comment: "comment"))
    sheetCamera.cancelButtonIndex = 2
    
    sheetCamera.tag = 0
    
    sheetCamera.showInView(self.view)
  }
  

  
  // MARK: Delete Button
  
  @IBAction func pushedDeleteButton(sender: AnyObject) {
    let sheet = UIActionSheet()
    sheet.title = NSLocalizedString("deleteNote", comment: "comment")
    sheet.delegate = self
    sheet.addButtonWithTitle("OK")
    sheet.addButtonWithTitle(NSLocalizedString("cancel", comment: "comment"))
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
        print("Cancel button tapped.")
      }else{
        // OK Button
        print("OK button tapped.")
        
        /* Delete Note */
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegatのインスタンスを取得
        let nid = Int(appDelegate.nid!)
        
        // sql from here
        let _dbfile:NSString = "sqlite.db"
        let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
          NSSearchPathDirectory.DocumentDirectory,
          NSSearchPathDomainMask.UserDomainMask,
          true)[0]
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        let _path:String = _dir.stringByAppendingPathComponent(_dbfile as String)
        
        let db = FMDatabase(path: _path)
        
        let sql_delete = "DELETE FROM notes WHERE nid=\(nid);"
        
        db.open()
        
        if db.executeUpdate(sql_delete, withArgumentsInArray: nil) {
          print("Delete notes nid: \(nid)")
          
          let fileManager = NSFileManager()
          let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
          let filePath = appDelegate.filePath
          // let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
          do {
            try fileManager.removeItemAtPath(filePath!+"/img\(nid).img")
            print("Deleted img file (Path: \(filePath)/img\(nid).img")
          }
          catch let error as NSError {
            print("Failed to delete image file (Path: \(filePath)/img\(nid).img")
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
    print("prepareForSegue was called!")
    
    print(segue.identifier)
    
    if (segue.identifier == "unwindToDetailBySave") {
      
      // MARK: Save Data
      
      // sqlite from here
      let _dbfile:NSString = "sqlite.db"
      let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
        NSSearchPathDirectory.DocumentDirectory,
        NSSearchPathDomainMask.UserDomainMask,
        true)[0]
      let fileManager:NSFileManager = NSFileManager.defaultManager()
      let _path:String = _dir.stringByAppendingPathComponent(_dbfile as String)
      let _db = FMDatabase(path: _path)
      
      _db.open()
      
      let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let nid = Int(appDelegate.nid!)
      
      // To avoid error of single quotation
      let blendNameTextFieldModified = blendNameTextField.text!.stringByReplacingOccurrencesOfString("\'", withString: "\'\'")
      let originTextFieldModified = originTextField.text!.stringByReplacingOccurrencesOfString("\'", withString: "\'\'")
      let placeTextFieldModified = placeTextField.text!.stringByReplacingOccurrencesOfString("\'", withString: "\'\'")
      let commentTextFieldModified = commentTextView.text.stringByReplacingOccurrencesOfString("\'", withString: "\'\'")
      
      // let sql_update = "UPDATE notes SET blendName='\(self.blendNameTextField.text)' WHERE nid=\(nid);"
      let sql_update = "UPDATE notes SET blendName='\(blendNameTextFieldModified)', origin='\(originTextFieldModified)', place='\(placeTextFieldModified)', roast='\(roastSegmentedControl.selectedSegmentIndex+1)', dark=\(darkSegmentedControl.selectedSegmentIndex+1), body=\(bodySegmentedControl.selectedSegmentIndex+1), acidity=\(aciditySegmentedControl.selectedSegmentIndex+1), flavor=\(flavorSegmentedControl.selectedSegmentIndex+1), sweetness=\(sweetnessSegmentedControl.selectedSegmentIndex+1), cleancup=\(cleanCupSegmentedControl.selectedSegmentIndex+1), aftertaste=\(aftertasteSegmentedControl.selectedSegmentIndex+1), overall=\(overallSegmentedControl.selectedSegmentIndex+1), comment='\(commentTextFieldModified)' WHERE nid=\(nid);"
      let _result_insert = _db.executeUpdate(sql_update, withArgumentsInArray: nil)
      
      // save photo
      if (appDelegate.editImage != nil) {
        // save image in DocumentDirectory
        // let data: NSData = UIImagePNGRepresentation(coffeeImageView.image)
        let data: NSData = UIImageJPEGRepresentation(coffeeImageView.image!, 1.0)!
        let filePath = appDelegate.filePath!
        // let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let imageFilePath = filePath+"/img\(nid).jpg"
        /*if (fileManager.removeItemAtPath(imageFilePath, error: nil)) {
          print("Delete old photo")
        }*/
        if (data.writeToFile(imageFilePath, atomically: true)) {
          print("Save Photo Suceeded(filePath: \(imageFilePath))")
        }else {
          print("Failed to save photo(filePath: \(imageFilePath))")
        }
        appDelegate.editImage = nil
      }
      
      
      
      /* Debug to comfirm the inserted data */
      
      let sql_select = "SELECT * FROM notes WHERE nid=\(nid);"
      let rows = _db.executeQuery(sql_select, withArgumentsInArray: nil)
      while rows.next() {
        let nid = rows.intForColumn("nid")
        let blendName = rows.stringForColumn("blendName")
        print("UPDATED: nid = \(nid), blendName = \(blendName)")

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