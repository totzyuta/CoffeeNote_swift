//
//  NewViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {
  

  @IBOutlet weak var blendName: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func pushButton(sender: AnyObject) {
    
    // sqlite from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
    println(_path)
    
    
    let _db = FMDatabase(path: _path)
    
    // Create a query to create a notes table
    // let _sql = "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT,blendName TEXT);"
    let sql_create_table = "CREATE TABLE IF NOT EXISTS notes (nid INTEGER PRIMARY KEY AUTOINCREMENT, blendName TEXT);"
      
    _db.open()
  
    var result = _db.executeStatements(sql_create_table)
    println(result)
    
    let db = FMDatabase(path: _path)
      
    let sql_insert = "INSERT INTO notes (blendName) values (?);"
    let sql_select = "SELECT nid, blendName FROM notes ORDER BY nid;"
    
    var _result_insert = _db.executeUpdate(sql_insert, withArgumentsInArray: [self.blendName.text])
    // var rows = _db.executeQuery(sql_select, withArgumentsInArray: [2])
    var rows = _db.executeQuery(sql_select, withArgumentsInArray: nil)
    
    while rows.next() {
      // カラム名を指定して値を取得する方法
      let nid = rows.intForColumn("nid")
      // カラムのインデックスを指定して取得する方法
      let blendName = rows.stringForColumnIndex(1)
      
      println("nid = \(nid), blendName = \(blendName)")
    }
    
    _db.close()
  
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    println("prepareForSegue was called!")
    
    // NSUserDefaultsインスタンスの生成
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // キー: "saveText" , 値: "<textFieldの入力値>" を格納。（idは任意）
    userDefaults.setObject(blendName.text?, forKey: "saveText")
        
    // キーが"saveText"のStringをとります。
    var loadText : String! = userDefaults.stringForKey("saveText")
    
    // labelに表示
    println("Saved: " + loadText)

    
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
