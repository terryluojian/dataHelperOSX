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
        print(NSBundle.mainBundle())
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
            //plistSave("testPlist", content: rows )
            
            // Columns
            let columns = csv.columns
            let id = csv.columns["id"]  //=> ["Alice", "Bob", "Charlie"]
            let c = csv.columns["content"]    //=> ["18", "19", "20"]
            //print("\(anyObject2Json(rows))")
            
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
        for (key,value) in data!{
            let v = value as! NSString
            data?.setValue(v.aes256_decrypt("good"), forKey: key as! String)
        }
        return data!
    }
    
    func plistSave(fileName:String,content:[Dictionary<String,String>]){
        let plistPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist")
        var data = NSMutableDictionary(contentsOfFile:plistPath!)
        
        for value in content{
            let cache = value["content"]! as NSString
            data?.setValue(cache.aes256_encrypt("good"), forKey: value["id"]!)
        }
        data!.writeToFile(plistPath!, atomically: true)
    }
    
    func anyObject2Json(input:AnyObject) -> NSString{
        let data = try? NSJSONSerialization.dataWithJSONObject(input, options: .PrettyPrinted)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let encode = string?.aes256_encrypt("good")
        return encode!
    }
    
    func json2Array(input:NSString) -> [String]{
        let data = input.dataUsingEncoding(NSUTF8StringEncoding)
        let object = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [String]
        return object!
    }

    func json2Dictionary(input:NSString)-> [String:String]{
        let data = input.dataUsingEncoding(NSUTF8StringEncoding)
        let object = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [String:String]
        return object!
    }


}

