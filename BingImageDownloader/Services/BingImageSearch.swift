//
//  BingImageSearch.swift
//  BingImageDownloader
//
//  Created by Michael James on 02/05/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Cocoa
import SwiftyBeaver

class BingImageSearch : ImageServiceProtocol {
    
    private let apiKey : String 
    private var images = [ImageSearchResult]()
    private let log = SwiftyBeaver.self
    
    init(apiKey : String) {
        self.apiKey = apiKey
    }
    
    //MARK: ImageServiceProtocol
    func searchForImageTerm(searchTerm : String){
        
        // Search for images and add each result to AppData

        //Cognitive Services requires a subscription key, so we will create a URLRequest with the key within the header
        DispatchQueue.global(qos: .background).async {
            
            let totalPics = 2000
            let picsPerPage = 200
            let numPages = totalPics / picsPerPage
            (0 ..< numPages)
                .compactMap { self.createUrlRequest(searchTerm: searchTerm, pageOffset: $0)}
                .forEach { self.fetchRequest(request: $0 as NSURLRequest) }
            RunLoop.current.run()
        }
    }
    
    // Search for images with a completion handler for processing the result array
    func searchForImageTerm(searchTerm : String, completion : @escaping ([ImageSearchResult]) -> ()) {
        
        //Because Cognitive Services requires a subscription key, we need to create a URLRequest to pass into the dataTask method of a URLSession instance..
        let request = createUrlRequest(searchTerm: searchTerm, pageOffset: 0)
       
        //This task is responsbile for downloading a page of results
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            //We didn't recieve a response
            guard let data = data, error == nil, response != nil else {
                print("something is wrong with the fetch")
                return
            }
            
            //Check the response code
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(response : response!)
                    completion([ImageSearchResult]())
                    return
            }
            
            //Convert data to concrete type
            do
            {
                let decoder = JSONDecoder()
                let bingImageSearchResults = try decoder.decode(ImageResultWrapper.self, from: data)
                
                //We use a closure to pass back our results.
                completion(bingImageSearchResults.images)
                
            } catch {
                self.log.error("Decoding ImageResultWrapper \(error)")
            }
            
        })
        task.resume()
    }
    
    //MARK: Helper Functions
    private func processSearchResponse(images : [ImageSearchResult]){
        self.log.info("ready to process \(images.count) ImageSearhResults")
    }
   
    private func createUrlRequest(searchTerm : String, pageOffset : Int) -> URLRequest {
        
        let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let endPointUrl = "https://api.cognitive.microsoft.com/bing/v7.0/images/search"
        
        let mkt = "en-US"
        let imageType = "photo"
        let size = "medium"
        
        let imageCount = 1000
        let pageCount = 10
        let picsPerPage = imageCount / pageCount
        
        let url = URL(string: "\(endPointUrl)?q=\(encodedQuery)&count=\(picsPerPage)&offset=\(pageOffset * picsPerPage)&mkt=\(mkt)&imageType=\(imageType)&size=\(size)")!
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        return request
        
    }
    
    private func fetchRequest(request : NSURLRequest){
        //This task is responsbile for downloading a page of results
        let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) -> Void in
            
            //We didn't recieve a response
            guard let data = data, error == nil, response != nil else {
                self.log.error("Fetch Request returned no data : \(request.url?.absoluteString)")
                return
            }
            
            //Check the response code
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(response : response!)
                    return
            }
            
            //Convert data to concrete type
            do
            {
                let decoder = JSONDecoder()
                let bingImageSearchResults = try decoder.decode(ImageResultWrapper.self, from: data)
                
                let imagesToAdd = bingImageSearchResults.images.filter { $0.encodingFormat != EncodingFormat.unknown }
                AppData.shared.addImages(imagesToAdd)
                                
            } catch {
                self.log.error("Error decoding ImageResultWrapper : \(error)")
                self.log.debug("Corrupted Base64 Data: \(data.base64EncodedString())")
            }
            
        }
        
        //Tasks are created in a paused state. We want to resume to start the fetch.
        task.resume()
    }
    
    private func handleServerError(response: URLResponse){
        //Handle response errors
        print("Error \(response)")
    }
    
}
