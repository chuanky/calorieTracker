//
//  LSFoodPlist.swift
//  This class provides utilities to load and save food carlorie data
//  imagepicker
//
//  Created by chuanqi shi on 2018/11/24.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation

class LSFoodPlist {
    static func loadData() -> (NSMutableDictionary){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let docDir = paths.object(at: 0) as! String
        let path = (paths as NSString).appendingPathComponent("foodCarlorieDB.plist")
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: path)) {
            if let bundlePath = Bundle.main.path(forResource: "foodCarlorieDB", ofType: "plist") {
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                } catch {
                    print("copy error")
                }
            }else {
                print("bundle plist does not found")
            }
        } else {
            print("file exist")
        }
        return NSMutableDictionary(contentsOfFile: path)!
    }
    
    static func saveData(value:[String], plistDict:NSMutableDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let docDir = paths.object(at: 0) as! String
        let path = (paths as NSString).appendingPathComponent("foodCarlorieDB.plist")
        let dict = NSMutableDictionary(contentsOfFile: path)
        var titles = dict?.object(forKey: "foodCarlorieDB") as! Array<[String]>
        
        titles.append(value)
        plistDict.setValue(titles, forKey: "foodCarlorieDB")
        plistDict.write(toFile: path, atomically: false)
        print("saved")
    }
    
    static func removeData(index:Int, plistDict:NSMutableDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let docDir = paths.object(at: 0) as! String
        let path = (paths as NSString).appendingPathComponent("foodCarlorieDB.plist")
        let dict = NSMutableDictionary(contentsOfFile: path)
        var titles = dict?.object(forKey: "foodCarlorieDB") as! Array<[String]>
        titles.remove(at: index)
        plistDict.setValue(titles, forKey: "foodCarlorieDB")
        plistDict.write(toFile: path, atomically: false)
        print("removed")
    }
    
    static func removeAll(plistDict:NSMutableDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let docDir = paths.object(at: 0) as! String
        let path = (paths as NSString).appendingPathComponent("foodCarlorieDB.plist")
        plistDict.setValue([String](), forKey: "foodCarlorieDB")
        plistDict.write(toFile: path, atomically: false)
        print("removed all")
        
    }
}
