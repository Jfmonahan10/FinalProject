//
//  RestaurantObject.swift
//  FinalProject
//
//  Created by James Monahan on 12/10/20.
//

import Foundation

class RestaurantObject{
    let headers = [
        "x-rapidapi-key": "39bf3c6dc8mshc1dd862a7e3d4a6p1f3292jsnb63ffd2b644e",
        "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    ]

    let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/extract?url=http%3A%2F%2Fwww.melskitchencafe.com%2Fthe-best-fudgy-brownies%2F")! as URL,cachePolicy: .useProtocolCachePolicy,imeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error)
        } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
        }
    })

    dataTask.resume()

}

