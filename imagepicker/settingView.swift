//
//  settingView.swift
//  imagepicker
//
//  Created by Miao Gao on 2018/11/24.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation
import UIKit

class settingView: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var currentCal: UILabel!
    let goalDB = LSGoalDB.loadData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let current = goalDB.object(forKey: "goal") {
            currentCal.text = "\(current) cal"
        }
        saveButton.applyDesign()
        inputText.delegate = self
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        //inputText.returnKeyType = UIReturnKeyType.done

    }
    
    // name:    saveButton
    //function: 单击save按钮，保存用户设置
    @IBAction func saveButton(_ sender: Any) {
        if let goalValue = Int(inputText.text!) {
            if goalValue > 0 {
                currentCal.text = inputText.text! + " cal"
                LSGoalDB.saveData(value: goalValue, plistDict: goalDB)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
//func hideKeyboardWhenTappedAround(){
//    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.disablesAutomaticKeyboardDismissal))
//}

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        UIView.endEditing()
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if (text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }



extension UIButton{
    func applyDesign(){
        self.layer.cornerRadius = self.frame.height/2
        self.backgroundColor = UIColor(red: 190/255, green: 42/255, blue: 42/255, alpha: 1.0)
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
