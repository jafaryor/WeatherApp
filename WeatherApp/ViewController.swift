//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jafar Yormahmadzoda on 14/03/2017.
//  Copyright © 2017 Jafar Yormahmadzoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func getWeather(_ sender: Any) {
        // Define URL. As the url is not secure (not https) we should whitelist it
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            // Create URL Request
            let request = NSMutableURLRequest(url: url)
            // Create task for downloading data from URL
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                var message = ""
                if error != nil {
                    print(error ?? "Can't fetch data")
                } else {
                    if let unwrappedData = data {
                        // Create UTF-8 string from data
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        // Extracting the weather forecast info from HTML markup
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(message)
                                }
                            }
                        }
                    }
                }
                
                if message == "" {
                    message = "The weather there couldn't be found. Please try again."
                }
                // As the data fetching is asyn process, need to return to main thread
                DispatchQueue.main.sync(execute: {
                    // We use self as we are inside of closure
                    self.resultLabel.text = message
                })
            }
            task.resume()
        } else {
            resultLabel.text = "The weather there couldn't be found. Please try again."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

