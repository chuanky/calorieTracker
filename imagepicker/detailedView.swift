//
//  detailedView.swift
//  imagepicker
//
//  Created by Miao Gao on 2018/11/24.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import UIKit
import SwiftyJSON


class detailedView: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var manualButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var analyzeButton: UIButton!
    
    var labels: Array<String> = []
    var label_inDB: Array<[String]> = []
    var labelCounts: Array<String> = []
    var imageStringData = ""
    // API related variables
    let session = URLSession.shared
    var googleAPIKey = "AIzaSyDjdHmS_fo4y_OPIWRzezXtt27ZXSHL2Sk"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descriptionLabel.text = data[currentIndex].message
        currentImage.image = data[currentIndex].image
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        spinner.isHidden = true
        //tableView.register(Cell.self, forCellReuseIdentifier: "foodCell")
        manualButton.applyDesign()
        //okButton.applyDesign()
        analyzeButton.applyDesign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // name:        analyzeButtonClick
    // function:    单击”analyze“按钮，调用api返回结果
    @IBAction func analyzeButtonClick(_ sender: Any) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        let binaryImageData = base64EncodeImage(data[currentIndex].image!)
        imageStringData = binaryImageData
        createRequest(with: binaryImageData)
        
    }
    
    // name:        manualButtonClicked
    // function:    单击”manual“按钮，手动添加食材
    @IBAction func manualButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "manual", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is manualView{
            tableView.reloadData()
            let vc = segue.destination as? manualView
            vc?.labels = self.labels
            vc?.labelCounts = self.labelCounts
            vc?.label_inDB = self.label_inDB
            vc?.imageStringData = self.imageStringData
        }
    }

    //          below is code for analyzing the image    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if ((imagedata?.count)! > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ],
                    [
                        "type": "WEB_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    /////////////////////////////////////////////////////////////////////
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
    
    func analyzeResults(_ dataToParse: Data) {
        // Update UI on the main thread
        DispatchQueue.main.async(execute:
            {
                // Use SwiftyJSON to parse results
//                self.spinner.isHidden = false
//                self.spinner.startAnimating()
                let json = JSON(data: dataToParse)
                let errorObj: JSON = json["error"]
                
                //var labelResultsText:String = "Labels found: "
                // Check for errors
                if (errorObj.dictionaryValue != [:]) {
                    self.descriptionLabel.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
                } else {
                    // Parse the response
                    //                print(json)
                    let responses: JSON = json["responses"][0]
                    
                    let webAnnotations: JSON = responses["webDetection"]["webEntities"]
                    let webLabels: Int = webAnnotations.count
                    if (webLabels > 0) {
                        for index in 0..<webLabels {
                            let label = webAnnotations[index]["description"].stringValue
                            if !self.labels.contains(label.lowercased()) {
                                self.labels.append(label.lowercased())
                            }
                        }
//                        for label in self.labels {
//                            // if it's not the last item add a comma
//                            if self.labels[self.labels.count - 1] != label {
//                                labelResultsText += "\(label), "
//                            } else {
//                                labelResultsText += "\(label)"
//                            }
//                        }
                        //self.descriptionLabel.text = labelResultsText
                    }
                    else{
                        //self.descriptionLabel.text = "No labels found"
                    }
                    // Get label annotations
                    let labelAnnotations: JSON = responses["labelAnnotations"]
                    let numLabels: Int = labelAnnotations.count
                    if (numLabels > 0) {
                        //var labelResultsText:String = "Labels found: "
                        for index in 0..<numLabels {
                            let label = labelAnnotations[index]["description"].stringValue
                            if !self.labels.contains(label.lowercased()) {
                                self.labels.append(label.lowercased())
                            }
                        }
//                        for label in self.labels {
//                            // if it's not the last item add a comma
//                            if self.labels[self.labels.count - 1] != label {
//                                labelResultsText += "\(label), "
//                            } else {
//                                labelResultsText += "\(label)"
//                            }
//                        }
                        //self.descriptionLabel.text = labelResultsText
                    }
                    else{
                        //self.descriptionLabel.text = "No labels found"
                    }
                    
                    
                    data[currentIndex].message = self.descriptionLabel.text
                    
                    self.labelFilter()
                    if self.labels.count == 0 {
                        let alert = UIAlertController(title: "WARNING", message: "No food ingredients found! Please use MANUAL to add food!", preferredStyle: .alert)
                        let iKnow = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(iKnow)
                        self.present(alert,animated: true, completion: nil)
                    }
                    self.tableView.reloadData()
                }
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! Cell
        print(labels[indexPath.row])
        cell.food?.text = self.labels[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            self.labels.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func labelFilter() {
        tableView.isHidden = false
        self.spinner.isHidden = true
        //load calorie info according to labels
        let foodDB = LSFoodPlist.loadData()
        let f_titles = foodDB.object(forKey: "foodCarlorieDB") as! Array<[String]>
        for label in labels {
            for f_title in f_titles {
                if label.lowercased() == f_title[0] {
                    label_inDB.append(f_title)
                }
            }
        }
        labels = []
        labelCounts = []
        //initialize labelCounts array
        for label in label_inDB {
            labels.append(label[0])
            labelCounts.append("1")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


