//
//  NewViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, GADBannerViewDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var mainView: UIView!
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var blendNameTextField: UITextField!
  @IBOutlet weak var originTextField: UITextField!
  @IBOutlet weak var placeTextField: UITextField!
  @IBOutlet weak var roastSegment: UISegmentedControl!
  @IBOutlet weak var darkSegment: UISegmentedControl!
  @IBOutlet weak var bodySegment: UISegmentedControl!
  @IBOutlet weak var aciditySegment: UISegmentedControl!
  @IBOutlet weak var flavorSegment: UISegmentedControl!
  @IBOutlet weak var sweetnessSegment: UISegmentedControl!
  @IBOutlet weak var cleanCupSegment: UISegmentedControl!
  @IBOutlet weak var aftertasteSegment: UISegmentedControl!
  @IBOutlet weak var overallSegment: UISegmentedControl!
  @IBOutlet weak var commentTextField: UITextView!
  
  
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // self.scrollView.contentSize = self.mainView.bounds.size
    
    placeTextField.delegate = self
    
    // change title of navigation bar
    let title = UILabel()
    title.font = UIFont.boldSystemFontOfSize(16)
    // title.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    title.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    title.text = NSLocalizedString("titleNewView", comment: "comment")
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
    roastSegment.setTitle(NSLocalizedString("light", comment: "comment"), forSegmentAtIndex: 0)
    roastSegment.setTitle(NSLocalizedString("medium", comment: "comment"), forSegmentAtIndex: 1)
    roastSegment.setTitle(NSLocalizedString("dark", comment: "comment"), forSegmentAtIndex: 2)
    darkSegment.setTitle(NSLocalizedString("light", comment: "comment"), forSegmentAtIndex: 0)
    darkSegment.setTitle(NSLocalizedString("medium", comment: "comment"), forSegmentAtIndex: 1)
    darkSegment.setTitle(NSLocalizedString("full", comment: "comment"), forSegmentAtIndex: 2)
    bodySegment.setTitle(NSLocalizedString("light", comment: "comment"), forSegmentAtIndex: 0)
    bodySegment.setTitle(NSLocalizedString("medium", comment: "comment"), forSegmentAtIndex: 1)
    bodySegment.setTitle(NSLocalizedString("heavy", comment: "comment"), forSegmentAtIndex: 2)
    
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
  
  
  // MARK: HideTextField
  
  @IBAction func blendNameTextField_finishEditing(sender: AnyObject) {
    self.originTextField.becomeFirstResponder()
  }
  
  @IBAction func originTextFiled_finishEditing(sender: AnyObject) {
    self.placeTextField.becomeFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  
  // MARK: Photo
  
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
    
    self.imageView.image = image
    picker.dismissViewControllerAnimated(true, completion: nil)
    
    self.cameraButton.alpha = 0.5
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    // [picker dismissViewControllerAnimated:YES completion:NULL];
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
 
  
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    if (buttonIndex==0) {
      self.takePhoto(self)
    }else if(buttonIndex==1){
      self.selectPhoto(self)
    }else {
      // Cancel Button
    }
  }
  
  @IBAction func pushCameraButton(sender: AnyObject) {
    let sheet = UIActionSheet()
    // sheet.title = "Set Photo of Coffee"
    sheet.title = NSLocalizedString("setPhoto", comment: "comment")
    sheet.delegate = self
    // sheet.addButtonWithTitle("Take Photo by Camera")
    sheet.addButtonWithTitle(NSLocalizedString("takePhoto", comment: "comment"))
    // sheet.addButtonWithTitle("Select Photo from Cameraroll")
    sheet.addButtonWithTitle(NSLocalizedString("selectPhoto", comment: "comment"))
    // sheet.addButtonWithTitle("Cancel")
    sheet.addButtonWithTitle(NSLocalizedString("cancel", comment: "comment"))
    sheet.cancelButtonIndex = 2
    
    sheet.showInView(self.view)
  }
  
  
  @IBAction func saveButtonPushed(sender: AnyObject) {
    // NULL check
    if (blendNameTextField.text == "" || placeTextField.text == "" || originTextField.text == "") {
      let myAlertView = UIAlertView()
      myAlertView.title = NSLocalizedString("alertTitleNewTexts", comment: "comment")
      myAlertView.message = NSLocalizedString("alertNewTexts", comment: "comment")
      myAlertView.addButtonWithTitle("Okay")
      myAlertView.show()
    }else {
      performSegueWithIdentifier("unwindToAllBySave", sender: self)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    print("prepareForSegue was called!")
    
    print(segue.identifier)
    
    if (segue.identifier == "unwindToAllBySave") {
      
      // NULL CHECK
      if (blendNameTextField.text == "" || originTextField.text == "" || placeTextField.text == "") {
        let alert = UIAlertView()
        alert.title = "Title"
        alert.message = "My message"
        alert.addButtonWithTitle("Ok")
        alert.show()
      }else {
        // sqlite from here
        let _dbfile:NSString = "sqlite.db"
        let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
          NSSearchPathDirectory.DocumentDirectory,
          NSSearchPathDomainMask.UserDomainMask,
          true)[0]
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        let _path:String = _dir.stringByAppendingPathComponent(_dbfile as String)
        
        // println(_path)
        
        let _db = FMDatabase(path: _path)
        
        _db.open()
        
        // set data when to create this note
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        // dateFormatter.dateFormat = "dd/MM"
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        print(dateFormatter.stringFromDate(now)) // -> 6/24/14, 11:01 AM
        
        // To avoid error of single quotation
        let blendNameTextFieldModified = blendNameTextField.text!.stringByReplacingOccurrencesOfString("\'", withString: "\'\'")
        let originTextFieldModified = originTextField.text!.stringByReplacingOccurrencesOfString("\'", withString: "\'\'")
        let placeTextFieldModified = placeTextField.text!.stringByReplacingOccurrencesOfString("\'", withString: "\'\'")
        let commentTextFieldModified = commentTextField.text.stringByReplacingOccurrencesOfString("\'", withString: "\'\'")
        
        let sql_insert = "INSERT INTO notes (blendName, origin, place, roast, dark, body, acidity, flavor, sweetness, cleancup, aftertaste, overall, comment, date) VALUES ('\(blendNameTextFieldModified)', '\(originTextFieldModified)', '\(placeTextFieldModified)', \(roastSegment.selectedSegmentIndex+1), \(darkSegment.selectedSegmentIndex+1), \(bodySegment.selectedSegmentIndex+1), \(aciditySegment.selectedSegmentIndex+1), \(flavorSegment.selectedSegmentIndex+1), \(sweetnessSegment.selectedSegmentIndex+1), \(cleanCupSegment.selectedSegmentIndex+1), \(aftertasteSegment.selectedSegmentIndex+1), \(overallSegment.selectedSegmentIndex+1), '\(commentTextFieldModified)', '\(dateFormatter.stringFromDate(now))');"
        
        let _result_insert = _db.executeUpdate(sql_insert, withArgumentsInArray:nil)
        
        // Debug and save photo
        
        let lastInsertId: Int = Int(_db.lastInsertRowId())
      
        let sql_select = "SELECT * FROM notes WHERE nid=\(lastInsertId);"
        let rows = _db.executeQuery(sql_select, withArgumentsInArray: nil)
        
        while rows.next() {
          let nid = rows.intForColumn("nid")
          let blendName = rows.stringForColumn("blendName")
          let origin = rows.stringForColumn("origin")
          let place = rows.stringForColumn("place")
          let roast = rows.intForColumn("roast")
          let dark = rows.intForColumn("dark")
          let body = rows.intForColumn("body")
          let acidity = rows.intForColumn("acidity")
          let flavor = rows.intForColumn("flavor")
          let sweetness = rows.intForColumn("sweetness")
          let cleancup = rows.intForColumn("cleancup")
          let aftertaste = rows.intForColumn("aftertaste")
          let overall = rows.intForColumn("overall")
          let comment = rows.stringForColumn("comment")
          let date = rows.stringForColumn("date")
          
          print("nid: \(nid), blendName: \(blendName), origin: \(origin), place: \(place), roast: \(roast), dark: \(dark), body: \(body), acidity: \(acidity), flavor: \(flavor), sweetness: \(sweetness), cleancup: \(cleancup), aftertaste: \(aftertaste), overall: \(overall), comment: \(comment), date: \(date)")
          
          // save photo
          if ((imageView.image) != nil) {
            // save image in DocumentDirectory
            let data: NSData = UIImageJPEGRepresentation(imageView.image!, 0.5)!
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
            let filePath = appDelegate.filePath!
            if (data.writeToFile("\(filePath)/img\(nid).jpg", atomically: true)) {
              print("Save Photo Suceeded(filePath: \(filePath)/img\(nid).png")
            }else {
              print("Failed to save photo")
            }
          }
        }
        
        _db.close()
      }
    }
  }
}
