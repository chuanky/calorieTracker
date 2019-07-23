//
//  theWeekView.swift
//  imagepicker
//
//  Created by Miao Gao on 2018/11/23.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation
import UIKit


class theWeekViewController: UIViewController{
    
    
    @IBOutlet weak var weekTotalLabel: UILabel!
    var goal = 0
    var monTotal = 0
    var tueTotal = 0
    var wedTotal = 0
    var thuTotal = 0
    var friTotal = 0
    var satTotal = 0
    var sunTotal = 0
    
    let dayLabel1: UILabel = {
        let label = UILabel()
        label.text = "MON"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let dayLabel2: UILabel = {
        let label = UILabel()
        label.text = "TUE"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let dayLabel3: UILabel = {
        let label = UILabel()
        label.text = "WED"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let dayLabel4: UILabel = {
        let label = UILabel()
        label.text = "THU"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let dayLabel5: UILabel = {
        let label = UILabel()
        label.text = "FRI"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let dayLabel6: UILabel = {
        let label = UILabel()
        label.text = "SAT"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let dayLabel7: UILabel = {
        let label = UILabel()
        label.text = "SUN"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    // label to show detailed cal
    let monLabel: UILabel = {
        let label = UILabel()
        label.text = "MONDAY = " + String(0) + " cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let tueLabel: UILabel = {
        let label = UILabel()
        label.text = "TUESDAY = " + String(0) + " cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let wedLabel: UILabel = {
        let label = UILabel()
        label.text = "WEDNESDAY = " + String(0) + " cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let thuLabel: UILabel = {
        let label = UILabel()
        label.text = "THUSDAY = " + String(0) + " cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let friLabel: UILabel = {
        let label = UILabel()
        label.text = "FRIDAY = " + String(0) + " cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let satLabel: UILabel = {
        let label = UILabel()
        label.text = "SATURDAY = " + String(0) + " cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let sunLabel: UILabel = {
        let label = UILabel()
        label.text = "SUNDAY = " + String(0) + " cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    func carlorieCircle(_center:CGPoint, _bg_color:CGColor, _week:String, _endValue:CGFloat) {
        
        let shapeLayer = CAShapeLayer()
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: _center, radius: 32, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(trackLayer)
        
        // data path
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = _bg_color
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        addAnimation(_shapeLayer: shapeLayer, _week: _week, _endValue:_endValue)
    }
    
    func addAnimation(_shapeLayer:CAShapeLayer, _week:String, _endValue:CGFloat) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = _endValue
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        _shapeLayer.add(basicAnimation, forKey: "week" + _week)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //load data from DB
        resetLocal()
        let personalDB = LSPersonalDB.loadData()
        let titles = personalDB.object(forKey: "personalDB") as! Array<[String]>
        for title in titles {
            if title[3] == "1" {
                sunTotal += Int(title[0])!
            }
            if title[3] == "2" {
                monTotal += Int(title[0])!
            }
            if title[3] == "3" {
                tueTotal += Int(title[0])!
            }
            if title[3] == "4" {
                wedTotal += Int(title[0])!
            }
            if title[3] == "5" {
                thuTotal += Int(title[0])!
            }
            if title[3] == "6" {
                friTotal += Int(title[0])!
            }
            if title[3] == "7" {
                satTotal += Int(title[0])!
            }
        }
        
        let goalDB = LSGoalDB.loadData()
        goal = goalDB.object(forKey: "goal") as! Int
        
        
        
        
        //////////////////////////////////      MON      //////////////////////////////////
        let x1 = 105.5
        let x2 = 295.5
        let space = 120.0       //142.5
        let firstRow = 180.0
        let center1 = CGPoint(x:x1,y:firstRow)
        let bg_color1 = UIColor.red.cgColor
        let week1 = "1"
        //        let endValue = monTotal /
        carlorieCircle(_center: center1, _bg_color: bg_color1, _week: week1, _endValue: CGFloat(monTotal) / CGFloat(goal) * 0.8)
        
        view.addSubview(dayLabel1)
        dayLabel1.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel1.center = center1
        
        view.addSubview(monLabel)
        monLabel.text = "Monday = "+String(monTotal)+" cal"
        monLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        monLabel.center = CGPoint(x:x1,y:firstRow+60)
        
        //////////////////////////////////      TUE      //////////////////////////////////
        let center2 = CGPoint(x:x1,y:firstRow + space)
        let bg_color2 = UIColor.orange.cgColor
        let week2 = "2"
        carlorieCircle(_center: center2, _bg_color: bg_color2, _week: week2, _endValue:CGFloat(tueTotal) / CGFloat(goal) * 0.8)
        
        view.addSubview(dayLabel2)
        dayLabel2.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel2.center = center2
        
        view.addSubview(tueLabel)
        tueLabel.text = "Tuesday = "+String(tueTotal)+" cal"
        tueLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        tueLabel.center = CGPoint(x:x1,y:firstRow+space+60)
        
        
        //////////////////////////////////      WED      //////////////////////////////////
        let center3 = CGPoint(x:x1,y:firstRow + space * 2)
        let bg_color3 = UIColor.yellow.cgColor
        let week3 = "3"
        carlorieCircle(_center: center3, _bg_color: bg_color3, _week: week3, _endValue:CGFloat(wedTotal) / CGFloat(goal) * 0.8)
        
        view.addSubview(dayLabel3)
        dayLabel3.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel3.center = center3
        
        view.addSubview(wedLabel)
        wedLabel.text = "Wednesday = "+String(wedTotal)+" cal"
        wedLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        wedLabel.center = CGPoint(x:x1,y:firstRow+space*2+60)
        
        //////////////////////////////////      THU      //////////////////////////////////
        let center4 = CGPoint(x:x1,y:firstRow+space*3)
        let bg_color4 = UIColor.green.cgColor
        let week4 = "4"
        carlorieCircle(_center: center4, _bg_color: bg_color4, _week: week4, _endValue:CGFloat(thuTotal) / CGFloat(goal) * 0.8)
        
        view.addSubview(dayLabel4)
        dayLabel4.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel4.center = center4
        
        view.addSubview(thuLabel)
        thuLabel.text = "Thusday = "+String(thuTotal)+" cal"
        thuLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        thuLabel.center = CGPoint(x:x1,y:firstRow+space*3+60)
        
        
        //////////////////////////////////      FRI      //////////////////////////////////
        let center5 = CGPoint(x:x2,y:firstRow)
        let bg_color5 = UIColor.cyan.cgColor
        let week5 = "5"
        carlorieCircle(_center: center5, _bg_color: bg_color5, _week: week5, _endValue:CGFloat(friTotal) / CGFloat(goal) * 0.8)
        
        view.addSubview(dayLabel5)
        dayLabel5.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel5.center = center5
        
        view.addSubview(friLabel)
        friLabel.text = "Friday = "+String(friTotal)+" cal"
        friLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        friLabel.center = CGPoint(x:x2,y:firstRow+60)
        
        //////////////////////////////////      SAT      //////////////////////////////////
        let center6 = CGPoint(x:x2,y:firstRow + space)
        let bg_color6 = UIColor.blue.cgColor
        let week6 = "6"
        carlorieCircle(_center: center6, _bg_color: bg_color6, _week: week6, _endValue:CGFloat(satTotal) / CGFloat(goal) * 0.8)
        
        view.addSubview(dayLabel6)
        dayLabel6.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel6.center = center6
        
        view.addSubview(satLabel)
        satLabel.text = "Saturday = "+String(satTotal)+" cal"
        satLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        satLabel.center = CGPoint(x:x2,y:firstRow+space+60)
        
        //////////////////////////////////      SUN      //////////////////////////////////
        let center7 = CGPoint(x:x2,y:firstRow + space*2)
        let bg_color7 = UIColor.purple.cgColor
        let week7 = "7"
        carlorieCircle(_center: center7, _bg_color: bg_color7, _week: week7, _endValue:CGFloat(sunTotal) / CGFloat(goal) * 0.8)
        
        view.addSubview(dayLabel7)
        dayLabel7.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel7.center = center7
        
        view.addSubview(sunLabel)
        sunLabel.text = "Sunday = "+String(sunTotal)+" cal"
        sunLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        sunLabel.center = CGPoint(x:x2,y:firstRow+space*2+60)
        
        // week total label
        let weekTotal = monTotal + tueTotal + wedTotal + thuTotal + friTotal + satTotal + sunTotal
        weekTotalLabel.text = "TOTAL: "+String(weekTotal)+" cal"
    }
    
    func resetLocal() {
        monTotal = 0
        tueTotal = 0
        wedTotal = 0
        thuTotal = 0
        friTotal = 0
        satTotal = 0
        sunTotal = 0
    }
    
}
