//
//  ViewController.swift
//  dataHelperOSX
//
//  Created by jianluo on 16/1/6.
//  Copyright © 2016年 jianluo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let fileLocation = NSBundle.mainBundle().pathForResource("testCSV", ofType: "csv")!
        
        let error: NSErrorPointer = nil
        
        if let csv = CSV(contentsOfFile: fileLocation, error: error) {
            // Rows
            let rows = csv.rows
            let headers = csv.headers  //=> ["id", "name", "age"]
            let a = csv.rows[0]    //=> ["id": "1", "name": "Alice", "age": "18"]
            let b = csv.rows[1]      //=> ["id": "2", "name": "Bob", "age": "19"]
            print("\n\(plistLoad("testPlist"))")
            plistSave("testPlist", content: rows )
            
            // Columns
            let columns = csv.columns
            let id = csv.columns["id"]  //=> ["Alice", "Bob", "Charlie"]
            let c = csv.columns["content"]    //=> ["18", "19", "20"]
            //print("无视\n\(columns)\(id)\n\(c)")
            
        }

    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func plistLoad(fileName:String) -> NSMutableDictionary{
        let plistPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist")
        let data = NSMutableDictionary(contentsOfFile:plistPath!)
        return data!
    }
    
    func plistSave(fileName:String,content:[Dictionary<String,String>]){
        let plistPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist")
        var data = NSMutableDictionary(contentsOfFile:plistPath!)
        
        for value in content{
            data?.setValue(value["content"], forKey: value["id"]!)
            print(data)
        }
        
        //let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        //let documentsDirectory = paths.objectAtIndex(0) as! NSString
        //let path = documentsDirectory.stringByAppendingPathComponent("testPlist.plist")
        data!.writeToFile(plistPath!, atomically: true)
        //let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        //print("Saved testPlist.plist file is --> \(resultDictionary?.description)")
        
    }



}

