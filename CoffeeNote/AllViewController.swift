//
//  ViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class AllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate  {
  
  @IBOutlet weak var allTableView: UITableView!
  // @IBOutlet weak var searchBar: UISearchBar!
  // var fileteredNotes: Array = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    allTableView.delegate = self
    allTableView.dataSource = self
    
    // change title of navigation bar
    var title = UILabel()
    title.font = UIFont.boldSystemFontOfSize(16)
    // title.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    title.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    title.text = NSLocalizedString("titleAllView", comment: "comment")
    title.sizeToFit()
    self.navigationItem.titleView = title;
    
    // share one filePath
    let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    appDelegate.filePath = filePath

    // Create a notes table if not exists
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile as String)
    
    let db = FMDatabase(path: _path)
    
    // Query to create a notes table
    let sql_create_table = "CREATE TABLE IF NOT EXISTS notes (nid INTEGER PRIMARY KEY AUTOINCREMENT, blendName TEXT, origin TEXT, place TEXT, roast INTEGER, dark INTEGER, body INTEGER, acidity INTEGER, flavor INTEGER, sweetness INTEGER, cleancup INTEGER, aftertaste, INTEGER, overall INTEGER, comment TEXT, date TEXT);"
    
    db.open()
    
    var result_create_table = db.executeStatements(sql_create_table)
    if result_create_table {
      print("notes table created")
    }else {
      print("notes table already exists")
    }
    
    // process if this is first time to launch this app
    let defaults = NSUserDefaults.standardUserDefaults()
    if defaults.boolForKey("firstLaunch") {
      
      // Create sample data
      // set data when to create this note
      let now = NSDate()
      let dateFormatter = NSDateFormatter()
      // dateFormatter.dateFormat = "dd/MM"
      dateFormatter.timeStyle = .ShortStyle
      dateFormatter.dateStyle = .ShortStyle
      print(dateFormatter.stringFromDate(now)) // -> 6/24/14, 11:01 AM
      // Create first sample note
      let sample_comment = NSLocalizedString("sampleComment", comment: "comment")
      let sql_insert_first_note = "INSERT INTO notes (blendName, origin, place, roast, dark, body, acidity, flavor, sweetness, cleancup, aftertaste, overall, comment, date) VALUES ('House Blend', 'Brazil', 'CoffeeNote Cafe', 2, 3, 2, 1, 4, 2, 5, 4, 4, '\(sample_comment)', '\(dateFormatter.stringFromDate(now))');"
      
      if db.executeUpdate(sql_insert_first_note, withArgumentsInArray: nil) {
        print("First Sample Note Created")
      }
      
      // Create second sample note
      let sample_name = NSLocalizedString("sampleName", comment: "comment")
      let sample_origin = NSLocalizedString("sampleOrigin", comment: "comment")
      let sample_place = NSLocalizedString("samplePlace", comment: "comment")
      let sample_comment2 = NSLocalizedString("sampleComment2", comment: "comment")
      let sql_insert_second_note = "INSERT INTO notes (blendName, origin, place, roast, dark, body, acidity, flavor, sweetness, cleancup, aftertaste, overall, comment, date) VALUES ('\(sample_name)', '\(sample_origin)', '\(sample_place)', 1, 2, 1, 5, 2, 4, 2, 2, 3, '\(sample_comment2)', '\(dateFormatter.stringFromDate(now))');"
    
      if db.executeUpdate(sql_insert_second_note, withArgumentsInArray: nil) {
        print("Second Sample Note Created")
      }
      
      // Set Sample Photo
      var lastInsertId: Int = Int(db.lastInsertRowId())
      
      // save sample image in DocumentDirectory
      var sampleImage = UIImage(named: "img5.jpg")
      var data: NSData = UIImageJPEGRepresentation(sampleImage!, 0.5)!
      var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let filePath = appDelegate.filePath! // Path to Documents Directory
      if (data.writeToFile("\(filePath)/img\(lastInsertId).jpg", atomically: true)) {
        print("Save Photo Suceeded(filePath: \(filePath)/img\(lastInsertId).jpg")
      }else {
        print("Failed to save photo for second sample note")
      }

      // off the flag to know if it is first time to launch
      defaults.setBool(false, forKey: "firstLaunch")
    }
    
    self.allTableView.reloadData()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    print("---AllViewWillAppear---")
    
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    
    // sql from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile as String)
    
    let db = FMDatabase(path: _path)
    
    
    let sql_select = "SELECT * FROM notes ORDER BY nid;"
    
    db.open()
    
    var rows = db.executeQuery(sql_select, withArgumentsInArray: nil)
    
    var blendNames: [String] = []
    
    while rows.next() {
      let nid = rows.intForColumn("nid")
    blendNames.append(rows.stringForColumn("blendName"))
    }
    
    db.close()
    
    self.allTableView.reloadData()

  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    // change the backgound color of tableView
    self.allTableView.backgroundView = nil
    self.allTableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
  }
  
  /*
  // for searching
  func filterContentForSearchText(searchText: String) {
    // Filter the array using the filter method
    self.filteredNotes = self.candies.filter({( candy: Candy) -> Bool in
      let categoryMatch = (scope == "All") || (candy.category == scope)
      let stringMatch = candy.name.rangeOfString(searchText)
      return categoryMatch && (stringMatch != nil)
    })
  }
  */
  
  // Set the contents of cells
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    // let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "noteCell")
    let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
    
    // sql from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile as String)
    
    let db = FMDatabase(path: _path)
    
    
    let sql_select = "SELECT * FROM notes ORDER BY nid;"
    
    db.open()
    
    var rows = db.executeQuery(sql_select, withArgumentsInArray: nil)
    
    var nidArray: [String] = []
    var blendNameArray: [String] = []
    var placesArray: [String] = []
    var dateArray: [String] = []
    
    while rows.next() {
      // nidArray.append(Int(rows.intForColumn("nid")))
      nidArray.append(rows.stringForColumn("nid"))
      blendNameArray.append(rows.stringForColumn("blendName"))
      placesArray.append(rows.stringForColumn("place"))
      var tmp_datewords = split(rows.stringForColumn("date"), { $0 == "," })
      var datewords = split(tmp_datewords[0], { $0 == "/" })
      dateArray.append(datewords[0]+"/"+datewords[1])
    }
    
    db.close()
    
    cell.titleLabel.text = blendNameArray[indexPath.row]
    cell.placeLabel.text = placesArray[indexPath.row]
    cell.dateLabel.text = dateArray[indexPath.row]
    
    
    // set image
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    let filePath = appDelegate.filePath
    var imageFilePath = filePath!+"/img\(nidArray[indexPath.row]).jpg"
    var imgfileManager = NSFileManager()
    print("imageFilePath: \(imageFilePath)")
    if (imgfileManager.fileExistsAtPath(imageFilePath)) {
      cell.backImage.image = UIImage(contentsOfFile: imageFilePath)
      prprintimageFilepath is there!")
    }else{
      cell.backImage.image = UIImage(named: "img1.jpg")
      print("NO imageFilepath")
    }
    
    // set propety font for title
    if ((cell.titleLabel.text?.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)) != nil) {
      cell.titleLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 42.0)
    }else {
      cell.titleLabel.font = UIFont(name: "HiraKakuProN-W3", size: 32.0)
      cell.titleLabel.alpha = 0.8
    }
    // set propety font for place
    if ((cell.placeLabel.text?.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)) != nil) {
      cell.placeLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 25.0)
    }else {
      cell.placeLabel.font = UIFont(name: "HiraKakuProN-W3", size: 18.0)
      cell.placeLabel.alpha = 0.6
    }
    
    return cell
  }
  
  
  // return number of cell
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // sql from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile as String)
    
    let db = FMDatabase(path: _path)
    
    
    let sql_select = "SELECT nid, blendName FROM notes ORDER BY nid;"
    
    db.open()
    
    var rows = db.executeQuery(sql_select, withArgumentsInArray: nil)
    
    var blendNames: [String] = []
    
    while rows.next() {
      blendNames.append(rows.stringForColumn("blendName"))
    }
    
    db.close()
    
    return blendNames.count
  }

    
  func fetchCellNumber(cellNumber: Int) ->Int {
    // sql from here
    // fetch the nid of the cell tapped
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathCompone as Stringnt;(_dbfile)
    
    let db = FMDatabase(path: _path)
    let sql = "SELECT * FROM notes LIMIT 1 OFFSET \(cellNumber)"
    
    db.open()
    
    var rows = db.executeQuery(sql, withArgumentsInArray: nil)
    var nid = 1
    
    while rows.next() {
      nid = Int(rows.intForColumn("nid"))
    }
    return nid
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    // sql from here
    // fetch the nid of the cell tapped
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathCompone as Stringnt;(_dbfile)
    
    let db = FMDatabase(path: _path)
    
    
    var cellNumber = fetchCellNumber(indexPath.row)
    
    let sql_select = "SELECT * FROM notes WHERE nid=\(cellNumber);"
    
    db.open()
    
    var rows = db.executeQuery(sql_select, withArgumentsInArray: nil)
    
    while rows.next() {
      var nid: Int = Int(rows.intForColumn("nid"))
      var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
      appDelegate.nid = nid
    }
    
    db.close()
    
    
    performSegueWithIdentifier("toDetailViewController", sender: self)
    
  }
  
  @IBAction func unwindToAllFromSetting(segue: UIStoryboardSegue) {
  }
  
  @IBAction func unwindToAllByCancel(segue: UIStoryboardSegue) {
  }

  @IBAction func unwindToAllBySave(segue: UIStoryboardSegue) {
  }
  
  @IBAction func unwindFromEditByDeleteButton(segue: UIStoryboardSegue) {
  }

  
}

