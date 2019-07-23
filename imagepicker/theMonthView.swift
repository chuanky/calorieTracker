//
//  theMonthView.swift
//  imagepicker
//
//  Created by Miao Gao on 2018/11/25.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import UIKit

class theMonthView: UIViewController {
    
    // 用于显示当月总摄入量的label
    
    @IBOutlet weak var monthTotalLabel: UILabel!
    
    // 用于存储每周总共摄入卡路里量的变量
    var goal = 0
    var week1total = 0
    var week2total = 0
    var week3total = 0
    var week4total = 0
    var week5total = 0
    let dayLabel1: UILabel = {
        let label = UILabel()
        label.text = "WEEK 1"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    let dayLabel2: UILabel = {
        let label = UILabel()
        label.text = "WEEK 2"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    let dayLabel3: UILabel = {
        let label = UILabel()
        label.text = "WEEK 3"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    let dayLabel4: UILabel = {
        let label = UILabel()
        label.text = "WEEK 4"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    let dayLabel5: UILabel = {
        let label = UILabel()
        label.text = "WEEK 5"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    let summaryLabel1: UILabel = {
        let label = UILabel()
        label.text = "WEEK 1 = "+String(0)+" cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let summaryLabel2: UILabel = {
        let label = UILabel()
        label.text = "WEEK 2 = "+String(0)+" cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let summaryLabel3: UILabel = {
        let label = UILabel()
        label.text = "WEEK 3 = "+String(0)+" cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let summaryLabel4: UILabel = {
        let label = UILabel()
        label.text = "WEEK 4 = "+String(0)+" cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let summaryLabel5: UILabel = {
        let label = UILabel()
        label.text = "WEEK 5 = "+String(0)+" cal"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    
    // name:        viewDidLoad
    // function:    加载view时自动运行
    
    override func viewDidLoad() {
        
        // navigation bar 样式
        self.navigationItem.title = "THIS MONTH"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.red]
//
        super.viewDidLoad()
        
    }
    
    
    
    func carlorieCircle(_center:CGPoint, _bg_color:CGColor, _week:String, _endValue:CGFloat) {
        
        let shapeLayer = CAShapeLayer()
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: _center, radius: 30, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        
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
        //reset local variables
        resetLocal()
        //load data from DB
        let personalDB = LSPersonalDB.loadData()
        let titles = personalDB.object(forKey: "personalDB") as! Array<[String]>
        for title in titles {
            if title[2] == "1" {
                week1total += Int(title[0])!
            }
            if title[2] == "2" {
                week2total += Int(title[0])!
            }
            if title[2] == "3" {
                week3total += Int(title[0])!
            }
            if title[2] == "4" {
                week4total += Int(title[0])!
            }
            if title[2] == "5" {
                week5total += Int(title[0])!
            }
        }
        let goalDB = LSGoalDB.loadData()
        goal = goalDB.object(forKey: "goal") as! Int
        
        // 用于统计当月总共摄入卡路里量的变量
        let monthTotal = week1total + week2total + week3total + week4total + week5total
        
        //////////////////////////////////      WEEK 1      //////////////////////////////////
        let space = 100.0
        let firstRow = 180.0
        let xPosition = 86.0
        let center1 = CGPoint(x:xPosition,y:firstRow)
        let bg_color1 = UIColor.red.cgColor
        let week1 = "1"
        let week1EndValue = CGFloat(week1total) / CGFloat(goal * 6) * 0.8
        carlorieCircle(_center: center1, _bg_color: bg_color1, _week: week1, _endValue:week1EndValue)
        
        // summaryLabel
        view.addSubview(summaryLabel1)
        summaryLabel1.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        summaryLabel1.center = CGPoint(x:260,y:firstRow)
        summaryLabel1.text = "WEEK 1 = "+String(week1total)+" cal"
        
        view.addSubview(dayLabel1)
        dayLabel1.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel1.center = center1
        
        //////////////////////////////////      WEEK 2      //////////////////////////////////
        let center2 = CGPoint(x:xPosition,y:firstRow + space)
        let bg_color2 = UIColor.orange.cgColor
        let week2 = "2"
        let week2EndValue = CGFloat(week2total) / CGFloat(goal * 6) * 0.8
        carlorieCircle(_center: center2, _bg_color: bg_color2, _week: week2, _endValue:week2EndValue)
        
        // summaryLabel
        view.addSubview(summaryLabel2)
        summaryLabel2.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        summaryLabel2.center = CGPoint(x:260,y:firstRow+space)
        summaryLabel2.text = "WEEK 2 = "+String(week2total)+" cal"
        
        view.addSubview(dayLabel2)
        dayLabel2.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel2.center = center2
        
        //////////////////////////////////      WEEK 3      //////////////////////////////////
        let center3 = CGPoint(x:xPosition,y:firstRow + space*2)
        let bg_color3 = UIColor.yellow.cgColor
        let week3 = "3"
        let week3EndValue = CGFloat(week3total) / CGFloat(goal * 6) * 0.8
        carlorieCircle(_center: center3, _bg_color: bg_color3, _week: week3, _endValue:week3EndValue)
        
        // summaryLabel
        view.addSubview(summaryLabel3)
        summaryLabel3.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        summaryLabel3.center = CGPoint(x:260,y:firstRow+space*2)
        summaryLabel3.text = "WEEK 3 = "+String(week3total)+" cal"
        
        view.addSubview(dayLabel3)
        dayLabel3.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel3.center = center3
        
        //////////////////////////////////      WEEK 4      //////////////////////////////////
        let center4 = CGPoint(x:xPosition,y:firstRow + space * 3)
        let bg_color4 = UIColor.green.cgColor
        let week4 = "4"
        let week4EndValue = CGFloat(week4total) / CGFloat(goal * 6) * 0.8
        carlorieCircle(_center: center4, _bg_color: bg_color4, _week: week4, _endValue:week4EndValue)
        
        // summaryLabel
        view.addSubview(summaryLabel4)
        summaryLabel4.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        summaryLabel4.center = CGPoint(x:260,y:firstRow+space*3)
        summaryLabel4.text = "WEEK 4 = "+String(week4total)+" cal"
        
        view.addSubview(dayLabel4)
        dayLabel4.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel4.center = center4
        
        //////////////////////////////////      WEEK 5      //////////////////////////////////
        let center5 = CGPoint(x:xPosition,y:firstRow + space * 4)
        let bg_color5 = UIColor.blue.cgColor
        let week5 = "5"
        let week5EndValue = CGFloat(week5total) / CGFloat(goal * 6) * 0.8
        carlorieCircle(_center: center5, _bg_color: bg_color5, _week: week5, _endValue:week5EndValue)
        
        // summaryLabel
        view.addSubview(summaryLabel5)
        summaryLabel5.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        summaryLabel5.center = CGPoint(x:260,y:firstRow+space*4)
        summaryLabel5.text = "WEEK 5 = "+String(week5total)+" cal"
        view.addSubview(dayLabel5)
        dayLabel5.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dayLabel5.center = center5
        
        
        /////////////////////////////////   monthTotalLabel
        monthTotalLabel.text = "TOTAL: "+String(monthTotal)+" cal"
        
    }
    
    func resetLocal() {
        week1total = 0
        week2total = 0
        week3total = 0
        week4total = 0
        week5total = 0
    }

}
