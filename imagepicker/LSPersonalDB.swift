//
//  LSPersonalDB.swift
//  imagepicker
//
//  Created by chuanqi shi on 2018/11/25.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation

class LSPersonalDB {
    static func loadData() -> (NSMutableDictionary){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let docDir = paths.object(at: 0) as! String
        let path = (paths as NSString).appendingPathComponent("personalCalorieInTake.plist")
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: path)) {
            if let bundlePath = Bundle.main.path(forResource: "personalCalorieInTake", ofType: "plist") {
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
    
    static func saveData(value:[[String]], imageValue:String, plistDict:NSMutableDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let docDir = paths.object(at: 0) as! String
        let path = (paths as NSString).appendingPathComponent("personalCalorieInTake.plist")
        let dict = NSMutableDictionary(contentsOfFile: path)
        var titles = dict?.object(forKey: "personalDB") as! Array<[String]>
        //insert date strings
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let weekday = calendar.component(.weekday, from: date)
        let weekOfMonth = calendar.component(.weekOfMonth, from: date)
        var calorie_total = 0
        for v in value {
            calorie_total += Int(v[1])!
        }
        var result = ["\(calorie_total)", "\(month)", "\(weekOfMonth)", "\(weekday)"]
        for v in value {
            result.append(v[0])
        }
        result.append(imageValue)
        titles.append(result)
        plistDict.setValue(titles, forKey: "personalDB")
        plistDict.write(toFile: path, atomically: false)
        print("pic info saved")
    }
    
    static func removeData(index:Int, plistDict:NSMutableDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let docDir = paths.object(at: 0) as! String
        let path = (paths as NSString).appendingPathComponent("personalCalorieInTake.plist")
        let dict = NSMutableDictionary(contentsOfFile: path)
        var titles = dict?.object(forKey: "personalDB") as! Array<[String]>
        titles.remove(at: index)
        plistDict.setValue(titles, forKey: "personalDB")
        plistDict.write(toFile: path, atomically: false)
        print("removed")
    }
    
    static func removeAll(plistDict:NSMutableDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let docDir = paths.object(at: 0) as! String
        
        let path = docDir.appending("personalCalorieInTake.plist")
        plistDict.setValue([String](), forKey: "personalDB")
        plistDict.write(toFile: path, atomically: false)
        print("removed all")
        
    }
}
