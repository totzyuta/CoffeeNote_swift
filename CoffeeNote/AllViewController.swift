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
    title.text = "All Coffee Notes"
    title.sizeToFit()
    self.navigationItem.titleView = title;

    // Create a notes table if not exists
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
    let db = FMDatabase(path: _path)
    
    // Query to create a notes table
    let sql_create_table = "CREATE TABLE IF NOT EXISTS notes (nid INTEGER PRIMARY KEY AUTOINCREMENT, blendName TEXT, origin TEXT, place TEXT, roast INTEGER, dark INTEGER, body INTEGER, acidity INTEGER, flavor INTEGER, sweetness INTEGER, cleancup INTEGER, aftertaste, INTEGER, overall INTEGER, comment TEXT, date TEXT);"
    
    db.open()
    
    var result_create_table = db.executeStatements(sql_create_table)
    if result_create_table {
      println("notes table created")
      println(_path)
    }else {
      println("notes table already exists")
    }
    
    
    // share one filePath
    let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegateのインスタンスを取得
    appDelegate.filePath = filePath
    
  }
  
  override func viewWillAppear(animated: Bool) {
    println("---AllViewWillAppear---")
    
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    
    // sql from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
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
    let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell") as CustomCell
    
    // sql from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
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
    // var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegateのインスタンスを取得
    // let filePath = appDelegate.filePath
    let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    var imageFilePath = filePath+"/img\(nidArray[indexPath.row]).jpg"
    // var imageFilePath = filePath!+"/img\(nidArray[indexPath.row]).png"
    var imgfileManager = NSFileManager()
    println("imageFilePath: \(imageFilePath)")
    if (imgfileManager.fileExistsAtPath(imageFilePath)) {
      // use class and method of Obejctive-C
      var obj = for_image_files()
      cell.backImage.image = obj.loadImage(imageFilePath)
      println("imageFilepath is there!")
    }else{
      cell.backImage.image = UIImage(named: "img1.jpg")
      println("NO imageFilepath")
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
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
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
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
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
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
    let db = FMDatabase(path: _path)
    
    
    var cellNumber = fetchCellNumber(indexPath.row)
    
    let sql_select = "SELECT * FROM notes WHERE nid=\(cellNumber);"
    
    db.open()
    
    var rows = db.executeQuery(sql_select, withArgumentsInArray: nil)
    
    while rows.next() {
      var nid: Int = Int(rows.intForColumn("nid"))
      var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegateのインスタンスを取得
      appDelegate.nid = nid
    }
    
    db.close()
    
    
    performSegueWithIdentifier("toDetailViewController", sender: self)
    
  }
  
  
  @IBAction func unwindToAllByCancel(segue: UIStoryboardSegue) {
  }
  

  @IBAction func unwindToAllBySave(segue: UIStoryboardSegue) {
  }
  
  @IBAction func unwindFromEditByDeleteButton(segue: UIStoryboardSegue) {
  }

  
}

