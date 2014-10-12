//
//  NewViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var mainView: UIView!
  
  
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
    
    // Do any additional setup after loading the view.
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
      
      let sql_insert = "INSERT INTO notes (blendName, origin, place, roast, dark, body, acidity, flavor, sweetness, cleancup, aftertaste, overall, comment) VALUES ('\(blendNameTextField.text)', '\(originTextField.text)', '\(placeTextField.text)', \(roastSegment.selectedSegmentIndex+1), \(darkSegment.selectedSegmentIndex+1), \(bodySegment.selectedSegmentIndex+1), \(aciditySegment.selectedSegmentIndex+1), \(flavorSegment.selectedSegmentIndex+1), \(sweetnessSegment.selectedSegmentIndex+1), \(cleanCupSegment.selectedSegmentIndex+1), \(aftertasteSegment.selectedSegmentIndex+1), \(overallSegment.selectedSegmentIndex+1), '\(commentTextField.text)');"
      
      var _result_insert = _db.executeUpdate(sql_insert, withArgumentsInArray:nil)
      
      // Debug for comfirm the inserted data
      
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
        
        println("nid: \(nid), blendName: \(blendName), origin: \(origin), place: \(place), roast: \(roast), dark: \(dark), body: \(body), acidity: \(acidity), flavor: \(flavor), sweetness: \(sweetness), cleancup: \(cleancup), aftertaste: \(aftertaste), overall: \(overall), comment: \(comment)")
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
