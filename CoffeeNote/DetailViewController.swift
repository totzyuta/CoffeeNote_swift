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
  
  @IBOutlet weak var star1Image: UIImageView!
  @IBOutlet weak var star2Image: UIImageView!
  @IBOutlet weak var star3Image: UIImageView!
  @IBOutlet weak var star4Image: UIImageView!
  @IBOutlet weak var star5Image: UIImageView!
  
  @IBOutlet weak var flavorStar1: UIImageView!
  @IBOutlet weak var flavorStar2: UIImageView!
  @IBOutlet weak var flavorStar3: UIImageView!
  @IBOutlet weak var flavorStar4: UIImageView!
  @IBOutlet weak var flavorStar5: UIImageView!
  
  @IBOutlet weak var acidityStar1: UIImageView!
  @IBOutlet weak var acidityStar2: UIImageView!
  @IBOutlet weak var acidityStar3: UIImageView!
  @IBOutlet weak var acidityStar4: UIImageView!
  @IBOutlet weak var acidityStar5: UIImageView!
  
  @IBOutlet weak var sweetnessStar1: UIImageView!
  @IBOutlet weak var sweetnessStar2: UIImageView!
  @IBOutlet weak var sweetnessStar3: UIImageView!
  @IBOutlet weak var sweetnessStar4: UIImageView!
  @IBOutlet weak var sweetnessStar5: UIImageView!
  
  @IBOutlet weak var cleancupStar1: UIImageView!
  @IBOutlet weak var cleancupStar2: UIImageView!
  @IBOutlet weak var cleancupStar3: UIImageView!
  @IBOutlet weak var cleancupStar4: UIImageView!
  @IBOutlet weak var cleancupStar5: UIImageView!
  
  @IBOutlet weak var aftertasteStar1: UIImageView!
  @IBOutlet weak var aftertasteStar2: UIImageView!
  @IBOutlet weak var aftertasteStar3: UIImageView!
  @IBOutlet weak var aftertasteStar4: UIImageView!
  @IBOutlet weak var aftertasteStar5: UIImageView!
  
  @IBOutlet weak var placeLabel: UILabel!
  @IBOutlet weak var roastLabel: UILabel!
  @IBOutlet weak var darkLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var commentText: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // self.scrollView.contentSize = self.mainView.bounds.size
    // scrollView.pagingEnabled = true
    
    
    // change title of navigation bar
    var title = UILabel()
    title.font = UIFont.boldSystemFontOfSize(16)
    // title.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    title.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    title.text = "Detail"
    title.sizeToFit()
    self.navigationItem.titleView = title;
  }
  
  override func viewWillAppear(animated: Bool) {
    println("viewwillAppear in DetailView called")

    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegatのインスタンスを取得
    var nid = Int(appDelegate.nid!)
    println("nid: \(nid)")
    
    // set image
    let filePath = appDelegate.filePath!
    // let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    var imageFilePath = filePath+"/img\(nid).jpg"
    var imgfileManager = NSFileManager()
    if (imgfileManager.fileExistsAtPath(imageFilePath)) {
      // var tmp_img = UIImage(named: imageFilePath)
      // var test_path = NSBundle.mainBundle()
      // var path = test_path.pathForResource("img\(nid)", ofType: "png")
      // coffeeImage.image = UIImage(named: "\(filePath)/img\(nid).jpg")
      // use class and method of Obejctive-C
      var obj = for_image_files()
      coffeeImage.image = obj.loadImage(imageFilePath)
      println("imagefile exists(imageFilePath: \(imageFilePath))")
    }else{
      println("imagefile NOT exists(imagefilePath: \(imageFilePath)")
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
      self.blendNameLabel.text = rows.stringForColumn("blendName")
      self.dateLabel.text = rows.stringForColumn("date")
      
      // set start images
      switch (rows.intForColumn("overall")){
      case 1:
        self.star1Image.image = UIImage(named: "gray-circle.png")
        self.star2Image.image = UIImage(named: "gray-circle.png")
        self.star3Image.image = UIImage(named: "gray-circle.png")
        self.star4Image.image = UIImage(named: "gray-circle.png")
        self.star5Image.image = UIImage(named: "star.png")
      case 2:
        self.star1Image.image = UIImage(named: "gray-circle.png")
        self.star2Image.image = UIImage(named: "gray-circle.png")
        self.star3Image.image = UIImage(named: "gray-circle.png")
        self.star4Image.image = UIImage(named: "star.png")
        self.star5Image.image = UIImage(named: "star.png")
      case 3:
        self.star1Image.image = UIImage(named: "gray-circle.png")
        self.star2Image.image = UIImage(named: "gray-circle.png")
        self.star3Image.image = UIImage(named: "star.png")
        self.star4Image.image = UIImage(named: "star.png")
        self.star5Image.image = UIImage(named: "star.png")
      case 4:
        self.star1Image.image = UIImage(named: "gray-circle.png")
        self.star2Image.image = UIImage(named: "star.png")
        self.star3Image.image = UIImage(named: "star.png")
        self.star4Image.image = UIImage(named: "star.png")
        self.star5Image.image = UIImage(named: "star.png")
      case 5:
        self.star1Image.image = UIImage(named: "star.png")
        self.star2Image.image = UIImage(named: "star.png")
        self.star3Image.image = UIImage(named: "star.png")
        self.star4Image.image = UIImage(named: "star.png")
        self.star5Image.image = UIImage(named: "star.png")
      default:
        println("Error of overall parametor")
      }
      
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
      switch (rows.intForColumn("flavor")){
      case 1:
        self.flavorStar1.hidden = false
        self.flavorStar2.hidden = true
        self.flavorStar3.hidden = true
        self.flavorStar4.hidden = true
        self.flavorStar5.hidden = true
      case 2:
        self.flavorStar1.hidden = false
        self.flavorStar2.hidden = false
        self.flavorStar3.hidden = true
        self.flavorStar4.hidden = true
        self.flavorStar5.hidden = true
      case 3:
        self.flavorStar1.hidden = false
        self.flavorStar2.hidden = false
        self.flavorStar3.hidden = false
        self.flavorStar4.hidden = true
        self.flavorStar5.hidden = true
      case 4:
        self.flavorStar1.hidden = false
        self.flavorStar2.hidden = false
        self.flavorStar3.hidden = false
        self.flavorStar4.hidden = false
        self.flavorStar5.hidden = true
      case 5:
        self.flavorStar1.hidden = false
        self.flavorStar2.hidden = false
        self.flavorStar3.hidden = false
        self.flavorStar4.hidden = false
        self.flavorStar5.hidden = false
      default:
        println("Error of overall parametor")
      }
      switch (rows.intForColumn("acidity")){
      case 1:
        self.acidityStar1.hidden = false
        self.acidityStar2.hidden = true
        self.acidityStar3.hidden = true
        self.acidityStar4.hidden = true
        self.acidityStar5.hidden = true
      case 2:
        self.acidityStar1.hidden = false
        self.acidityStar2.hidden = false
        self.acidityStar3.hidden = true
        self.acidityStar4.hidden = true
        self.acidityStar5.hidden = true
      case 3:
        self.acidityStar1.hidden = false
        self.acidityStar2.hidden = false
        self.acidityStar3.hidden = false
        self.acidityStar4.hidden = true
        self.acidityStar5.hidden = true
      case 4:
        self.acidityStar1.hidden = false
        self.acidityStar2.hidden = false
        self.acidityStar3.hidden = false
        self.acidityStar4.hidden = false
        self.acidityStar5.hidden = true
      case 5:
        self.acidityStar1.hidden = false
        self.acidityStar2.hidden = false
        self.acidityStar3.hidden = false
        self.acidityStar4.hidden = false
        self.acidityStar5.hidden = false
      default:
        println("Error of overall parametor")
      }
      switch (rows.intForColumn("sweetness")){
      case 1:
        self.sweetnessStar1.hidden = false
        self.sweetnessStar2.hidden = true
        self.sweetnessStar3.hidden = true
        self.sweetnessStar4.hidden = true
        self.sweetnessStar5.hidden = true
      case 2:
        self.sweetnessStar1.hidden = false
        self.sweetnessStar2.hidden = false
        self.sweetnessStar3.hidden = true
        self.sweetnessStar4.hidden = true
        self.sweetnessStar5.hidden = true
      case 3:
        self.sweetnessStar1.hidden = false
        self.sweetnessStar2.hidden = false
        self.sweetnessStar3.hidden = false
        self.sweetnessStar4.hidden = true
        self.sweetnessStar5.hidden = true
      case 4:
        self.sweetnessStar1.hidden = false
        self.sweetnessStar2.hidden = false
        self.sweetnessStar3.hidden = false
        self.sweetnessStar4.hidden = false
        self.sweetnessStar5.hidden = true
      case 5:
        self.sweetnessStar1.hidden = false
        self.sweetnessStar2.hidden = false
        self.sweetnessStar3.hidden = false
        self.sweetnessStar4.hidden = false
        self.sweetnessStar5.hidden = false
      default:
        println("Error of overall parametor")
      }
      switch (rows.intForColumn("cleancup")){
      case 1:
        self.cleancupStar1.hidden = false
        self.cleancupStar2.hidden = true
        self.cleancupStar3.hidden = true
        self.cleancupStar4.hidden = true
        self.cleancupStar5.hidden = true
      case 2:
        self.cleancupStar1.hidden = false
        self.cleancupStar2.hidden = false
        self.cleancupStar3.hidden = true
        self.cleancupStar4.hidden = true
        self.cleancupStar5.hidden = true
      case 3:
        self.cleancupStar1.hidden = false
        self.cleancupStar2.hidden = false
        self.cleancupStar3.hidden = false
        self.cleancupStar4.hidden = true
        self.cleancupStar5.hidden = true
      case 4:
        self.cleancupStar1.hidden = false
        self.cleancupStar2.hidden = false
        self.cleancupStar3.hidden = false
        self.cleancupStar4.hidden = false
        self.cleancupStar5.hidden = true
      case 5:
        self.cleancupStar1.hidden = false
        self.cleancupStar2.hidden = false
        self.cleancupStar3.hidden = false
        self.cleancupStar4.hidden = false
        self.cleancupStar5.hidden = false
      default:
        println("Error of overall parametor")
      }
      switch (rows.intForColumn("aftertaste")){
      case 1:
        self.aftertasteStar1.hidden = false
        self.aftertasteStar2.hidden = true
        self.aftertasteStar3.hidden = true
        self.aftertasteStar4.hidden = true
        self.aftertasteStar5.hidden = true
      case 2:
        self.aftertasteStar1.hidden = false
        self.aftertasteStar2.hidden = false
        self.aftertasteStar3.hidden = true
        self.aftertasteStar4.hidden = true
        self.aftertasteStar5.hidden = true
      case 3:
        self.aftertasteStar1.hidden = false
        self.aftertasteStar2.hidden = false
        self.aftertasteStar3.hidden = false
        self.aftertasteStar4.hidden = true
        self.aftertasteStar5.hidden = true
      case 4:
        self.aftertasteStar1.hidden = false
        self.aftertasteStar2.hidden = false
        self.aftertasteStar3.hidden = false
        self.aftertasteStar4.hidden = false
        self.aftertasteStar5.hidden = true
      case 5:
        self.aftertasteStar1.hidden = false
        self.aftertasteStar2.hidden = false
        self.aftertasteStar3.hidden = false
        self.aftertasteStar4.hidden = false
        self.aftertasteStar5.hidden = false
      default:
        println("Error of overall parametor")
      }
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
