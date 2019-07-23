//
//  manualView.swift
//  imagepicker
//
//  Created by Xiangyun on 11/25/18.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation
import UIKit

class manualView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var labels: Array<String> = []
    var labelCounts: Array<String> = []
    var label_inDB: Array<[String]> = []
    var imageStringData = ""
    var foodName = ""
    var calorieValue = ""
    var popedUp = false

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var manualOkButton: UIButton!

    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        //tableView.register(Cell.self, forCellReuseIdentifier: "foodCell")
        manualOkButton.applyDesign()
        homeButton.applyDesign()
        //addFoodBtn.applyDesign()
        
        popUpView.isHidden = true
    }
    
    @IBAction func less(_ sender: Any) {
        tableView.reloadData()
    }
    @IBAction func add(_ sender: Any) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! Cell
        print(labels[indexPath.row])
        cell.food?.text = self.labels[indexPath.row]
        labelCounts[indexPath.row] = (cell.serving?.text)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            self.labels.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    @IBAction func home(_ sender: UIStoryboardSegue) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    //ok btn action
    @IBAction func okButtonClicked(_ sender: Any) {
        loadCalorieInfo()
        let personalDB = LSPersonalDB.loadData()
        var labels_toSave:[[String]] = []
        var index = 0
        while index < labels.count {
            var count = Int(labelCounts[index])!
            while count > 0 {
                labels_toSave.append(label_inDB[index])
                count = count - 1
            }
            index = index + 1
        }
        LSPersonalDB.saveData(value: labels_toSave,imageValue: imageStringData,plistDict: personalDB)
        manualOkButton.setTitle("SAVED", for: .normal)
        manualOkButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //load calorie info according to labels
    func loadCalorieInfo() {
        label_inDB = []
        let foodDB = LSFoodPlist.loadData()
        let f_titles = foodDB.object(forKey: "foodCarlorieDB") as! Array<[String]>
        for label in labels {
            for f_title in f_titles {
                if label == f_title[0] {
                    label_inDB.append(f_title)
                }
            }
        }
    }
    
    var popUpView = UIView(frame: CGRect(x: 50, y: 250, width: 300, height: 180))
    
    @IBAction func addAnotherFood(_ sender: Any) {
            popUpView.isHidden = false
        
            let popUpWidth = CGFloat(300)
            //create labels and textfield for popUpView
            let foodNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: popUpWidth, height: 30))
            foodNameLabel.text = "food name:"
            foodNameLabel.textAlignment = .center
            popUpView.addSubview(foodNameLabel)
            let foodNameField = UITextField(frame: CGRect(x: 50, y: 30, width: popUpWidth - 100, height: 30))
            foodNameField.borderStyle = .roundedRect
            foodNameField.addTarget(self, action: #selector(foodNameChanged), for: .editingChanged)
            popUpView.addSubview(foodNameField)
            
            let calorieLabel = UILabel(frame: CGRect(x: 0, y: 60, width: popUpWidth, height: 30))
            calorieLabel.text = "calorie per 100g:"
            calorieLabel.textAlignment = .center
            popUpView.addSubview(calorieLabel)
            let calorieField = UITextField(frame: CGRect(x: 50, y: 90, width: popUpWidth - 100, height: 30))
            calorieField.borderStyle = .roundedRect
            calorieField.addTarget(self, action: #selector(calorieChanged), for: .editingChanged)
            popUpView.addSubview(calorieField)
            
            let addFoodBtn_popUp = UIButton(frame: CGRect(x: 50, y: 130, width: 80, height: 30))
            addFoodBtn_popUp.setTitle("add", for: .normal)
            addFoodBtn_popUp.applyDesign()
            addFoodBtn_popUp.addTarget(self, action: #selector(addFoodBtn_popUp_pressed), for: .touchUpInside)
            popUpView.addSubview(addFoodBtn_popUp)
        
            let cancelFoodBtn_popUp = UIButton(frame: CGRect(x: 180, y: 130, width: 80, height: 30))
            cancelFoodBtn_popUp.setTitle("cancel", for: .normal)
            cancelFoodBtn_popUp.applyDesign()
            cancelFoodBtn_popUp.addTarget(self, action: #selector(cancelFoodBtn_popUp_pressed), for: .touchUpInside)
            popUpView.addSubview(cancelFoodBtn_popUp)
            
            //modify popUpView style
            popUpView.layer.borderColor = UIColor(red: 190/255, green: 40/255, blue: 40/255, alpha: 1.0).cgColor
            popUpView.layer.borderWidth = 1
            popUpView.backgroundColor = UIColor.white
            popUpView.layer.cornerRadius = 40
            view.addSubview(popUpView)
        
    }
    
    //addFoodBtn_popUp_preseed function
    @objc func addFoodBtn_popUp_pressed(sender: UIButton!) {
        let foodDB = LSFoodPlist.loadData()
        let f_titles = foodDB.object(forKey: "foodCarlorieDB") as! Array<[String]>
        foodName = foodName.lowercased()
        let foodToSave = [foodName, calorieValue]
        var notInDB = true
        for f_title in f_titles {
            if foodName == f_title[0] {
                let alert = UIAlertController(title: "WARNING", message: "\(foodName) already exists!", preferredStyle: .alert)
                let iKnow = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(iKnow)
                self.present(alert,animated: true, completion: nil)
                notInDB = false
            }
        }
        if notInDB {
            LSFoodPlist.saveData(value: foodToSave, plistDict: foodDB)
            sender.setTitle("added", for: .normal)
            sender.isEnabled = false
            labels.append(foodName)
            labelCounts.append("1")
            popUpView.isHidden = true
        }
        tableView.reloadData()
    }
    
    @objc func cancelFoodBtn_popUp_pressed(sender: UIButton!) {
        popUpView.isHidden = true
    }
    
    @objc func foodNameChanged(sender: UITextField!) {
        foodName = sender.text!
    }
    
    @objc func calorieChanged(sender: UITextField!) {
        calorieValue = sender.text!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manualOkButton.setTitle("SAVE", for: .normal)
        manualOkButton.isEnabled = true
    }
}
