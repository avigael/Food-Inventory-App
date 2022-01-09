//
//  BarcodeManager.swift
//  FoodTracker
//
//  Created by Gael G. on 1/8/22.
//

import Foundation

class BarcodeManager {
    let API_HOST = "edamam-food-and-grocery-database.p.rapidapi.com"
    let API_KEY = "d31f04436dmsh16489e13b84f1b7p105955jsn081f216c2098"
    
    func getLabel(barcode: String, completion: @escaping (String?) -> Void) {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://\(API_HOST)/parser?upc=\(barcode)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "x-rapidapi-host": API_HOST,
            "x-rapidapi-key": API_KEY
        ]
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let jsonData = data, error == nil else {
                print("Error: Failed to get data")
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status Code: \(statusCode)")
            if statusCode == 404 {
                completion(nil)
                return
            }
            do {
                let data = try JSONDecoder().decode(BarcodeResult.self, from: jsonData)
                completion(data.results.first?.food.label)
            } catch {
                print(error)
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
