//
//  APIManager.swift
//  BaiTap8App
//
//  Created by Trieu Le on 11/11/16.
//  Copyright © 2016 Trieu Le. All rights reserved.
//

import Foundation
import Alamofire

protocol APIManagerDelegate{
    func processResultResponseData(_ result: Any, requestId: Int)
}

class APIManager: NSObject {
    
    static let shared = APIManager()
    var root_url = "http://jsonplaceholder.typicode.com/"
    
    func getPostList(_ contextId: AnyObject){
        callApi(root_url + "posts", typeMethod: .get, parameters: nil, requestId: requestApiId.request_posts.rawValue, contextId: contextId)
    }
    
    func getComments(_ contextId: AnyObject, post_id: Int){
        callApi(root_url + "posts/\(post_id)/comments", typeMethod: .get, parameters: nil, requestId: requestApiId.request_comments.rawValue, contextId: contextId)
    }
    
    func callApi(_ url:String, typeMethod:HTTPMethod , parameters:[String:AnyObject]? ,requestId:Int , contextId:AnyObject){
        Alamofire.request(url, method: typeMethod, parameters: parameters).validate().responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            switch response.result {
            case .success:
                (contextId as? APIManagerDelegate)?.processResultResponseData(response.result.value, requestId: requestId)
            case .failure(let error):
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                (contextId as? UIViewController)?.present(alert, animated: true, completion: nil)
                print(error)
            }
        }
    }
}

enum requestApiId: Int
{
    case request_posts = 1
    case request_comments
}
