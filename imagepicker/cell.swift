//
//  cell.swift
//  imagepicker
//
//  Created by Xiangyun on 11/25/18.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation
import  UIKit

class Cell: UITableViewCell{
    
    
    @IBOutlet var food: UILabel!
    
    
    @IBAction func add(_ sender: Any) {
        var num = Int(serving.text!)
        num = num! + 1
        serving.text = String(num!)
        
    }
    
    
    @IBAction func less(_ sender: Any) {
        var num = Int(serving.text!)
        num = num! - 1
        if num! <= 0 {
            num = 1
        }
        serving.text = String(num!)
        
    }
    
    @IBOutlet weak var serving: UILabel!
}
