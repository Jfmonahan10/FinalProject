//
//  Activity.swift
//  FinalProject
//
//  Created by James Monahan
//

import Foundation

class Activity{
    
    
    var activityArray: [ActivityStruct] = []

    
    var url = "https://www.boredapi.com/api/activity/"
    
    func getData(completed: @escaping ()->()) {
            let urlString = url
            print("🕸 We are accessing the url \(urlString)")
            guard let url = URL(string: urlString) else {
                print("😡 ERROR: Could not create a URL from \(urlString)")
                completed()
                return
            }
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("😡 ERROR: \(error.localizedDescription)")
                }
                
                do {
                    let results = try JSONDecoder().decode(ActivityStruct.self, from: data!)
                    self.activityArray =  self.activityArray + [results]
                    print("this works and this is the string ")
                } catch {
                    print("😡 JSON ERROR: \(error.localizedDescription)")
                }
                completed()
            }
            
            task.resume()
        }
    
    
}
