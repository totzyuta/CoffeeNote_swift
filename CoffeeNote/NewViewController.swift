//
//  NewViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.scrollView.contentSize = self.mainView.bounds.size
    
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
  }
  
  
  /* Photo */
  
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
    self.imageView.image = chosenImage
    picker.dismissViewControllerAnimated(true, completion: nil)
    
    
    // hide cameraButton
    self.cameraButton.hidden = true
    
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    // [picker dismissViewControllerAnimated:YES completion:NULL];
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func pushCameraButton(sender: AnyObject) {
    
    // ActionMethod
    let alertController = UIAlertController(title: "Set Photo of Coffee", message: "Chose Action", preferredStyle: .ActionSheet)
    
    let takePhotoAction = UIAlertAction(title: "Take Photo by Camera", style: .Default) { (action) -> Void in
      self.takePhoto(self)
    }
    let selectPhotoAction = UIAlertAction(title: "Select Photo from Cameraroll", style: .Default) { (action) -> Void in
      self.selectPhoto(self)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
      println("cancelAction")
    }
    
    alertController.addAction(takePhotoAction)
    alertController.addAction(selectPhotoAction)
    alertController.addAction(cancelAction)
    
    presentViewController(alertController, animated: true, completion: nil)
    
  }
  
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    println("prepareForSegue was called!")
    
    println(segue.identifier)
    
    if (segue.identifier == "unwindToAllBySave") {
    
      // sqlite from here
      let _dbfile:NSString = "sqlite.db"
      let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
        NSSearchPathDirectory.DocumentDirectory,
        NSSearchPathDomainMask.UserDomainMask,
        true)[0]
      let fileManager:NSFileManager = NSFileManager.defaultManager()
      let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
      
      // println(_path)
      
      let _db = FMDatabase(path: _path)
      
      _db.open()
      
      // set data when to create this note
      let now = NSDate()
      let dateFormatter = NSDateFormatter()
      // dateFormatter.dateFormat = "dd/MM"
      dateFormatter.timeStyle = .ShortStyle
      dateFormatter.dateStyle = .ShortStyle
      println(dateFormatter.stringFromDate(now)) // -> 6/24/14, 11:01 AM
      
      
      let sql_insert = "INSERT INTO notes (blendName, origin, place, roast, dark, body, acidity, flavor, sweetness, cleancup, aftertaste, overall, comment, date) VALUES ('\(blendNameTextField.text)', '\(originTextField.text)', '\(placeTextField.text)', \(roastSegment.selectedSegmentIndex+1), \(darkSegment.selectedSegmentIndex+1), \(bodySegment.selectedSegmentIndex+1), \(aciditySegment.selectedSegmentIndex+1), \(flavorSegment.selectedSegmentIndex+1), \(sweetnessSegment.selectedSegmentIndex+1), \(cleanCupSegment.selectedSegmentIndex+1), \(aftertasteSegment.selectedSegmentIndex+1), \(overallSegment.selectedSegmentIndex+1), '\(commentTextField.text)', '\(dateFormatter.stringFromDate(now))');"
      
      var _result_insert = _db.executeUpdate(sql_insert, withArgumentsInArray:nil)
      
      
      // Debug and save photo
      let sql_select = "SELECT * FROM notes ORDER BY nid;"
      var rows = _db.executeQuery(sql_select, withArgumentsInArray: nil)
      
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
        
        println("nid: \(nid), blendName: \(blendName), origin: \(origin), place: \(place), roast: \(roast), dark: \(dark), body: \(body), acidity: \(acidity), flavor: \(flavor), sweetness: \(sweetness), cleancup: \(cleancup), aftertaste: \(aftertaste), overall: \(overall), comment: \(comment), date: \(date)")
        
        // save image in DocumentDirectory
        var data: NSData = UIImagePNGRepresentation(imageView.image)
        let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        if (data.writeToFile(filePath+"\(nid).png", atomically: true)) {
          println("Save Photo Suceeded(filePath: \(filePath)")
        }else {
          println("Failed to save photo")
        }
        
      }
      
      _db.close()
      
    }
    
  }
  
}
