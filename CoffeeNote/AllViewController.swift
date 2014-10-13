//
//  ViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class AllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
  @IBOutlet weak var allTableView: UITableView!
  
  var arrayOfPersons: [Person] = [Person]()
  
  func setUpPersons() {
    var person1 = Person(name: "Anna", number: 16, imageName: "img1.jpg")
    var person2 = Person(name: "John", number: 35, imageName: "img2.jpg")
    
    arrayOfPersons.append(person1)
    arrayOfPersons.append(person2)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    allTableView.delegate = self
    allTableView.dataSource = self

    // Create a notes table if not exists
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
    let db = FMDatabase(path: _path)
    
    // Create a query to create a notes table
    let sql_create_table = "CREATE TABLE IF NOT EXISTS notes (nid INTEGER PRIMARY KEY AUTOINCREMENT, blendName TEXT, origin TEXT, place TEXT, roast INTEGER, dark INTEGER, body INTEGER, acidity INTEGER, flavor INTEGER, sweetness INTEGER, cleancup INTEGER, aftertaste, INTEGER, overall INTEGER, comment TEXT, date TEXT);"
    
    db.open()
    
    var result_create_table = db.executeStatements(sql_create_table)
    if result_create_table {
      println("notes table created")
      println(_path)
    }else {
      println("notes table already exists")
    }
    
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
  
  
  // セルの内容を返す
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
    
    var blendNames: [String] = []
    
    while rows.next() {
      let nid = rows.intForColumn("nid")
      blendNames.append(rows.stringForColumn("blendName"))
    }
    
    db.close()
    
    // let person = arrayOfPersons[indexPath.row]
    
    // cell.textLabel?.text = blendNames[indexPath.row]
    cell.titleLabel.text = blendNames[indexPath.row]
    // cell.titleLabel.text = person.name
    // cell.setCell(person.name, imageName: person.imageName)
    cell.backImage.image = UIImage(named: "img\(indexPath.row+1).jpg")
    
    return cell
  }
  
  
  // セルの行数
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
    
    println("arrayOfPersons:\(arrayOfPersons.count)")
    
    return blendNames.count
    // return arrayOfPersons.count
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
    println("---cell was tapped---")
    
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
      // var blendName: String = rows.stringForColumn("blendName")
      var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegateのインスタンスを取得
      appDelegate.nid = nid
      // appDelegate.blendName = blendName
    }
    
    db.close()
    
    
    performSegueWithIdentifier("toDetailViewController", sender: self)
    
  }
  
  
  @IBAction func unwindToAllByCancel(segue: UIStoryboardSegue) {
  }
  

  @IBAction func unwindToAllBySave(segue: UIStoryboardSegue) {
  }
  
  @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
  }

  
}

