//
//  tableView.swift
//  imagepicker
//
//  Created by Miao Gao on 2018/11/24.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation
import UIKit

// struct
struct cellData{
    var image: UIImage?
    var message: String?
    
}
var data = [cellData]()
var pickedData = [cellData]()
var currentIndex = 0

class tableView: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let imagePicker = UIImagePickerController()
    
    
    // name:        viewDidLoad
    // function:    加载界面时自动运行
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.tableView.register(customCell.self, forCellReuseIdentifier: "custom")
        
        // set ui properties for the table view
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        imagePicker.delegate = self
    }
    
    // album按钮事件
    @IBAction func albumButtonClick(_ sender: UIBarButtonItem) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    // camera按钮事件
    @IBAction func cameraButtonClick(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = ["public.image"]
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController.init(title: "提示", message: "没有检测到摄像头", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.show(alert, sender: nil)
            print("no camera")
        }
    }
    
    
    // name:        tableView
    // function:    更新row所在行的tableView的内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! customCell
        // get image and message
        cell.mainImage = data[indexPath.row].image
        cell.message = data[indexPath.row].message
        
        cell.layoutSubviews()
        return cell
    }
    
    // name:        tableView
    // function:    更新row所在行的tableView的内容
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // name:        tableView
    // function:    单击tableView中的cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        currentIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    // name:        imagePickerController
    // function:    选择照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let temp = " "
            data.append(cellData.init(image: pickedImage, message: temp))
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // name:        imagePickerControllerDidCancel
    // function:    取消选择照片
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let personalDB = LSPersonalDB.loadData()
        let titles = personalDB.object(forKey: "personalDB") as! Array<[String]>
        var index = 0;
        while index < titles.count {
            let title = titles[index]
            let imageData = Data(base64Encoded: title[title.count - 1] as String, options: NSData.Base64DecodingOptions())
            
            var foodString = ""
            let foodList_endIndex = title.count - 2
            var foodList_startIndex = 4
            while foodList_startIndex <= foodList_endIndex {
                foodString += title[foodList_startIndex] + " "
                foodList_startIndex += 1
            }
            
            let currentMessage = "The total calorie for this meal is: \(title[0])\nFood in this meal: \(foodString)\nMonth:\(title[1]) Weekday:\(title[3])"
            while data.count - 1 < index {
                data.append(cellData.init())
            }
            if let currentImage = UIImage(data: imageData as! Data) {
                data[index] = cellData.init(image: currentImage, message: currentMessage)
            }
            index += 1
        }
        tableView.reloadData()
    }
    
}
