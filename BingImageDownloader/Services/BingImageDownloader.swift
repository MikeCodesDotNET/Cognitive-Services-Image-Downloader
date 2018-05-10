//
//  ImageDownloaderService.swift
//  BingImageDownloader
//
//  Created by Michael James on 17/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation
import AppKit

public class BingImageDownloader {
    
    private let endPointUrl = "https://api.cognitive.microsoft.com/bing/v7.0/images/search"
    private let apiKey = "b5c1513a97084b09962eeb558c8645d9"
    private var count = 0
    private var dowloadedCount = 0
    private var images = Array<NSImage>()
  
    var imageUrls = Array<URL>()
    
    init(){
        
    }
    
    func searchFor(searchTerm: String){
        
        let query = searchTerm
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let totalPics = UserDefaults.standard.getImageDownloadCount()
        let picsPerPage = 50
        let mkt = "en-US"
        let imageType = "photo"
        let size = "medium"
        
        //This is really a hack as we don't know for sure how many images we'll get.....and so the page count could be wrong.
        let numPages = totalPics / picsPerPage

        //.compactMap is creating an Array of URLs which allow us to fetch a page from CogS. If we have 700 images with 50 images per page, it would be 700 / 50 = 14 pages. We can expect an Array of 14 URLs.
        //.map takes the Array of URLs and executes ..fetchImageUrlsTask for every page.
        (0 ..< numPages)
            .compactMap { URL(string: "\(endPointUrl)?q=\(encodedQuery)&count=\(picsPerPage)&offset=\($0 * picsPerPage)&mkt=\(mkt)&imageType=\(imageType)&size=\(size)") }
            .map {  self.fetchImageUrlsTask(forQueryUrl: $0) }
            .forEach { imageUrls.append(URL($0)) }
        
        
        //Puts the receiver into a permanent loop, during which time it processes data from all attached input sources.
        //RunLoop.current.run()
    }
    
    
    func fetchImageUrlsTask(forQueryUrl url:URL) -> URLSessionDataTask {
        
        //Setup our HTTP request.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        return URLSession(configuration: urlSessionConfig()).dataTask(with: request) { data, response, _ in
            
            //Handle no data.
            guard let data = data else {
                print(FilterColors.red + "Error: No data returned.")
                return
            }
            
            //Handle non-successful status code
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let error: Error = try! JSONDecoder().decode(Error.self, from: data)
                print(FilterColors.red + "Error \(error.statusCode): \(error.message)")
                return
            }
            
            //We can probably assume its a good response and start processing.
            print(FilterColors.green + "Processing \(url.absoluteString)")
            print(data)
            
            do {
                try JSONDecoder().decode(Response.self, from: data)
                    .value
                    .map { URL(string: $0.contentUrl)! }
                    .filter { $0.pathExtension.count > 0 }
                    .forEach {
                        print($0.absoluteString)
                        self.imageUrls.append($0)
                }
                print(self.imageUrls.count)
                
            } catch(let error) {
                print(error)
            }
            
            print(self.images.count)
        }
    }
    
    
    
}

private extension BingImageDownloader {

    func urlSessionConfig() -> URLSessionConfiguration {
        let urlConfig = URLSessionConfiguration.default
        urlConfig.timeoutIntervalForRequest = 10
        urlConfig.timeoutIntervalForResource = 10
        return urlConfig
    }
}
