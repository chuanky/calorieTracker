//
//  LSGoalDB.swift
//  imagepicker
//
//  Created by Miao Gao on 2018/11/25.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation

class LSGoalDB {
    static func loadData() -> (NSMutableDictionary){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let docDir = paths.object(at: 0) as! String
        let path = (paths as NSString).appendingPathComponent("goal.plist")
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: path)) {
            if let bundlePath = Bundle.main.path(forResource: "goal", ofType: "plist") {
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
    
    static func saveData(value:Int, plistDict:NSMutableDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let docDir = paths.object(at: 0) as! String
        let path = (paths as NSString).appendingPathComponent("goal.plist")
        plistDict.setValue(value, forKey: "goal")
        plistDict.write(toFile: path, atomically: false)
        print("goal saved")
    }
}
