//
//  NetworkingManager.swift
//  Cornelis Assesment
//
//  Created by Cornelis Kuijpers on 2020/06/09.
//  Copyright © 2020 Cor Kuijpers. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkingManagerDelegate {
    func didUpdateData(StackOverflowdata : StackOverflowdata)
    func didFail(error : Error)
}

struct NetworkingManager {
    
    var delegate : NetworkingManagerDelegate?
    
    func searchStackOverflow(searchText: String){
        let urlString = "https://api.stackexchange.com/2.2/search/advanced?pagesize=20&order=desc&sort=activity&title={\(searchText)}&site=stackoverflow&filter=withbody"
        
        performRequest(urlString: urlString)
        
    }
    
    func performRequest(urlString: String){
        //1. Create URL
                
        let components = transformURLString(urlString)

        if let url = components?.url {
            //2. Create URL Session
            
            let session = URLSession(configuration: .default)
        
            //3. Give Session a task
            let task = session.dataTask(with: url,completionHandler: taskHandle(data:respone:error:))
        
            //4. Start the task
            task.resume()
        }else{
            print("Invalid Url")
        }
    }
    
    func taskHandle(data: Data?, respone: URLResponse?, error: Error?){
        if error != nil {
            
            self.delegate?.didFail(error: error!)
            return
        }
        
        if let safeData = data {
            if let stackOverflowData = parseJSON(stackOverflowData: safeData) {
                self.delegate?.didUpdateData(StackOverflowdata : stackOverflowData)
            }
        }
    }
    
    func parseJSON(stackOverflowData: Data) -> StackOverflowdata?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(StackOverflowdata.self, from: stackOverflowData)
            return decodedData
        }catch{
            self.delegate?.didFail(error: error)
            return nil
        }
        
    }
    
    func transformURLString(_ string: String) -> URLComponents? {
        guard let urlPath = string.components(separatedBy: "?").first else {
            return nil
        }
        var components = URLComponents(string: urlPath)
        if let queryString = string.components(separatedBy: "?").last {
            components?.queryItems = []
            let queryItems = queryString.components(separatedBy: "&")
            for queryItem in queryItems {
                guard let itemName = queryItem.components(separatedBy: "=").first,
                      let itemValue = queryItem.components(separatedBy: "=").last else {
                        continue
                }
                components?.queryItems?.append(URLQueryItem(name: itemName, value: itemValue))
            }
        }
        return components!
    }
    
}
