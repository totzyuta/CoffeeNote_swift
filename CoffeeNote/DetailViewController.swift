//
//  DetailViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var mainView: UIView!
  
  @IBOutlet weak var coffeeImage: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var blendNameLabel: UILabel!
  @IBOutlet weak var placeLabel: UILabel!
  @IBOutlet weak var roastLabel: UILabel!
  @IBOutlet weak var darkLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var flavorLabel: UILabel!
  @IBOutlet weak var acidityLabel: UILabel!
  @IBOutlet weak var sweetnessLabel: UILabel!
  @IBOutlet weak var cleanCupLabel: UILabel!
  @IBOutlet weak var aftertasteLabel: UILabel!
  @IBOutlet weak var commentText: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.scrollView.contentSize = self.mainView.bounds.size
    // scrollView.pagingEnabled = true
  }
  
  override func viewWillAppear(animated: Bool) {

    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegatのインスタンスを取得
    var nid = Int(appDelegate.nid!)
    println("nid: \(nid)")
    
    // set image
    let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    var imageFilePath = filePath+"/img\(nid).png"
    var imgfileManager = NSFileManager()
    if (imgfileManager.fileExistsAtPath(imageFilePath)) {
      coffeeImage.image = UIImage(named: filePath+"/img\(nid).png")
    }else{
      coffeeImage.image = UIImage(named: "img1.jpg")
    }

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
      // Put data to label
      self.blendNameLabel.text = rows.stringForColumn("blendName")
      self.dateLabel.text = rows.stringForColumn("date")
      self.placeLabel.text = rows.stringForColumn("place")
      switch rows.intForColumn("roast") {
      case 1:
        self.roastLabel.text = "Light"
      case 2:
        self.roastLabel.text = "Medium"
      case 3:
        self.roastLabel.text = "Dark"
      default:
        self.roastLabel.text = "Unknown"
      }
      switch rows.intForColumn("dark") {
      case 1:
        self.darkLabel.text = "Light"
      case 2:
        self.darkLabel.text = "Medium"
      case 3:
        self.darkLabel.text = "Full"
      default:
        self.darkLabel.text = "Unknown"
      }
      switch rows.intForColumn("body") {
      case 1:
        self.bodyLabel.text = "Light"
      case 2:
        self.bodyLabel.text = "Medium"
      case 3:
        self.bodyLabel.text = "Dark"
      default:
        self.bodyLabel.text = "Unknown"
      }
      self.flavorLabel.text = rows.stringForColumn("flavor")
      self.acidityLabel.text = rows.stringForColumn("acidity")
      self.sweetnessLabel.text = rows.stringForColumn("sweetness")
      self.cleanCupLabel.text = rows.stringForColumn("cleanCup")
      self.aftertasteLabel.text = rows.stringForColumn("aftertaste")
      self.commentText.text = rows.stringForColumn("comment")
      self.commentText.textColor = UIColor.grayColor()
    }
    
    db.close()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func pushedEditButton(sender: AnyObject) {
    
  }
  
  
  @IBAction func unwindToDetailByCancel(segue: UIStoryboardSegue) {
  }
  
  
  @IBAction func unwindToDetailBySave(segue: UIStoryboardSegue) {
  }
  
  
  
}
