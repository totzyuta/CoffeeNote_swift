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
      
      let sql_insert = "INSERT INTO notes (blendName) values (?);"
      
      var _result_insert = _db.executeUpdate(sql_insert, withArgumentsInArray: [self.blendName.text])
      
      
      
      // Debug for comfirm the inserted data
      
      let sql_select = "SELECT nid, blendName FROM notes ORDER BY nid;"
      
      // var rows = _db.executeQuery(sql_select, withArgumentsInArray: [2])
      var rows = _db.executeQuery(sql_select, withArgumentsInArray: nil)
      
      while rows.next() {
        // カラム名を指定して値を取得
        let nid = rows.intForColumn("nid")
        // カラムのインデックスを指定して取得
        let blendName = rows.stringForColumnIndex(1)
        
        println("nid = \(nid), blendName = \(blendName)")
      }
      
      _db.close()
      
      
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
