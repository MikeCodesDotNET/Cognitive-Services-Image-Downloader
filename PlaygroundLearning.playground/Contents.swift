//: Playground - noun: a place where people can play

import AppKit
import Foundation

var str = "Hello, playground"

let endPointUrl = "https://api.cognitive.microsoft.com/bing/v7.0/images/search"
let apiKey = "b5c1513a97084b09962eeb558c8645d9"
let outputFolderPath : String
var count = 0
var dowloadedCount = 0



var searchTerm = "Airbus A380"
let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

let totalPics = 100
let picsPerPage = 50
let mkt = "en-US"
let imageType = "photo"
let size = "medium"

let numPages = totalPics / picsPerPage

//Creates the URLS with correct Page numbers for looping through to cal the FetchImage class
(0 ..< numPages)
    .compactMap { URL(string: "\(endPointUrl)?q=\(encodedSearchTerm)&count=\(picsPerPage)&offset=\($0 * picsPerPage)&mkt=\(mkt)&imageType=\(imageType)&size=\(size)") }
    .map { fetchImageUrlsTask(forQueryUrl: $0) }
    .forEach { $0.resume() }

RunLoop.current.run()


func fetchImageUrlsTask(forQueryUrl url:URL) -> URLSessionDataTask {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    
    return URLSession(configuration: urlSessionConfig()).dataTask(with: request) { data, response, _ in
        guard let data = data else {
            print(FilterColors.red + "Error: No data returned.")
            return
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            let error: Error = try! JSONDecoder().decode(Error.self, from: data)
            print(FilterColors.red + "Error \(error.statusCode): \(error.message)")
            return
        }
        
        print(FilterColors.green + "Processing \(url.absoluteString)")
        
        var images = Array<NSImage>()
        
        print(data)
        
        do {
            try JSONDecoder().decode(Response.self, from: data)
                .value
                .map { URL(string: $0.contentUrl)! }
                .filter { $0.pathExtension.count > 0 }
                .forEach {
                    let image = try NSImage(data: Data(contentsOf: $0))
                    images.append(image!)
            }
        } catch(let error) {
            print(error)
        }
        
        print(images.count)
    }
}
