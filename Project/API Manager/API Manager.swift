//
//  API Manager.swift
//  API Manager
//
//  Created by Munib Hamza on 23/05/2022.
//

import Foundation
import Alamofire
import UIKit

enum CustomError: Error {
    // Throw when an invalid password is entered
    case invalidURL
    case tokenExpired
    // Throw in all other cases
    case unexpected(code: Int)
}

typealias RequestCompletion = (_ response: [String:Any]?, _ error: Error?) -> Void
//typealias RequestCompletionWithIndex = (_ response: Any?,_ index : IndexPath , _ error: Error?) -> Void


class APIRequestUtil {
    
    static let shared = APIRequestUtil()
    private init() {}
    
    func loginStudent(parameters: Parameters, completion: @escaping RequestCompletion) {
        let urlString = APIPaths.login_user
        print(urlString)
        sendRequest(urlString: urlString, parameters: parameters, method: .post, completion: completion)
    }
    
    
    func registerStudent(parameters: Parameters, completion: @escaping RequestCompletion) {
        let urlString = APIPaths.register_student
        print(urlString)
        sendRequest(urlString: urlString, parameters: parameters, method: .post, completion: completion)
    }
    
     func sendOTPStudent(parameters: Parameters, completion: @escaping RequestCompletion) {
        let urlString = APIPaths.generateOTP
        print(urlString)
        sendRequest(urlString: urlString, parameters: parameters, method: .post, completion: completion)
    }
    
    func verifyOTPStudent(parameters: Parameters, completion: @escaping RequestCompletion) {
        let urlString = APIPaths.verifyEmail
        print(urlString)
        sendRequest(urlString: urlString, parameters: parameters, method: .post, completion: completion)
    }
    
     func getStudentDetails(parameters: Parameters, completion: @escaping RequestCompletion) {
        let urlString = APIPaths.get_user
        print(urlString)
        sendRequest(urlString: urlString, parameters: parameters, method: .post, completion: completion)
    }
    
    
     func resetPassword(parameters: Parameters, completion: @escaping RequestCompletion) {
        let urlString = APIPaths.forgotPassword
        print(urlString)
        sendRequest(urlString: urlString, parameters: parameters, method: .post, completion: completion)
    }

    
    
    func bookSession(parameters: Parameters, completion: @escaping RequestCompletion) {
        let urlString = APIPaths.bookSession
        print(urlString)
        sendRequest(withToken: true, urlString: urlString, parameters: parameters, method: .post, completion: completion)
    }
    
    
}

extension APIRequestUtil {
    
    fileprivate func sendRequest(withToken : Bool = false, urlString: String, parameters: Parameters, method : HTTPMethod, completion: @escaping RequestCompletion) {
        var urlStr = urlString
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        if parameters.count > 0 {
            if method == .get {
                let qPM = buildQueryString(fromDictionary: parameters)
                urlStr = urlString + qPM
            }
        }
        guard let url = URL(string: urlStr) else {
            print("URL invalid")
            completion(nil, CustomError.invalidURL)
            return
        }
        var request = URLRequest(url: url)
        
        if withToken {
            guard let accessToken = DataManager.shared.getAccessToken() else {
                completion(nil, CustomError.tokenExpired)
                return
            }
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("Token:",accessToken)

        }
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if parameters.count > 0 && method != .get {
            request.httpBody = toJSonString(data: parameters).data(using: .utf8)
        }
        
        request.httpMethod = method.rawValue
        
        print("************** \(method.rawValue) Request with url \(url)")
        
        print("************** \(method.rawValue) Request with Params \(parameters)")
        
        manager.request(request).responseJSON { response in
            print("************* Response ****************")
            print(response)
            switch response.result {
            case .success(let value):
                completion(value as? [String : Any], nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    fileprivate func MultipartRequest(withToken : Bool = false, url: String, parameters: Parameters, method : HTTPMethod ,image: UIImage, withImgName: String, completion: @escaping RequestCompletion) {
        
        var headers = ["Accept": "application/json"]
        
        if withToken {
            guard let accessToken = DataManager.shared.getAccessToken() else {
                completion(nil, CustomError.tokenExpired)
                return
            }
            
            headers = ["Authorization": "Bearer " + accessToken,
                        "Accept": "application/json"]
            print("Token:",accessToken)
        }
        print("********** Multipart \(method.rawValue) Request with url \( url)")
        print("********** Multipart \(method.rawValue) Request with Params \(parameters)")
        
        let URL = URL(string: url)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let imageData = image.pngData()!
            
            multipartFormData.append(imageData, withName: withImgName, fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
            
            for (key, value) in parameters {
                let stringValue = "\(value)"
                multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: URL!, method: method, headers: headers)
        { (result) in
            switch result{
            case .success(let upload, _,_ ):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UploadProgress"), object: nil, userInfo: ["progress": Progress.fractionCompleted])
                    
                })
                
                upload.responseJSON { (response) in
                    print("************* Response ****************")
                    print(response)
                    if response.result.isSuccess {
                        if let response = response.result.value as? [String : Any] {
                            completion(response,nil)
                        } else {
                            completion(nil, response.result.error)
                        }
                    } else {
                        completion(nil, response.result.error)
                    }
                }
                
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(nil, error)
                
            }
        }
    }

    //    static func downloadFile(with url: URL, completion:@escaping ( _ path:URL,  _ error:NSError?)-> Void) {
    //        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    //        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
    //        let sessionConfig = URLSessionConfiguration.default
    //        sessionConfig.timeoutIntervalForRequest = 20.0
    //        sessionConfig.timeoutIntervalForResource = 60.0
    //        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"
    //        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
    //            if (error == nil) {
    //                if let response = response as? HTTPURLResponse {
    //                    if response.statusCode == 200 {
    //                        if (try? data!.write(to: destinationUrl, options: [.atomic])) != nil {
    //                            completion(destinationUrl, nil)
    //                        } else {
    //                            let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
    //                            completion(destinationUrl, error)
    //                        }
    //                    }
    //                }
    //            }
    //            else {
    //                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
    //                completion(destinationUrl, error)
    //            }
    //        })
    //        task.resume()
    //    }
    //

    fileprivate func toJSonString(data : Any) -> String {
        
        var jsonString = "";
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .init(rawValue: 0))
            jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            jsonString = jsonString.replacingOccurrences(of: "\n", with: "")
            
        } catch {
            print(error.localizedDescription)
        }
        print(jsonString)
        return jsonString;
    }
    
    fileprivate func buildQueryString(fromDictionary parameters: [String: Any]) -> String {
        var urlVars = [String]()
        for (var k, var v) in parameters {
            let characters = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
            characters.removeCharacters(in: "&")
            v = "\(v)".addingPercentEncoding(withAllowedCharacters: characters as CharacterSet)!
            k = k.addingPercentEncoding(withAllowedCharacters: characters as CharacterSet)!
            urlVars += [k + "=" + "\(v)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }
    
    
}
extension NSObject {
    func buildQueryString(fromDictionary parameters: [String:String]) -> String {
        var urlVars = [String]()
        for (var k, var v) in parameters {
            let characters = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
            characters.removeCharacters(in: "&")
            v = v.addingPercentEncoding(withAllowedCharacters: characters as CharacterSet)!
            k = k.addingPercentEncoding(withAllowedCharacters: characters as CharacterSet)!
            urlVars += [k + "=" + "\(v)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }
}
extension URL {
    
    @discardableResult
    func append(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string:  absoluteString) else { return absoluteURL }
        
        // create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // create query item if value is not nil
        guard let value = value else { return absoluteURL }
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // append updated query items array in the url component object
        urlComponents.queryItems = queryItems// queryItems?.append(item)
        
        // returns the url from new url components
        return urlComponents.url!
    }
}

class APIResponseUtil {
    
    public static func isValidResponse(viewController: UIViewController, response: [String:Any]?, error: Error?, renderError: Bool = true) -> Bool {
        
        var isValidResponse = true
        var message = ""
        
        if let resDic = response, let code = resDic["success"] as? Int, code == 0 {
            message = resDic["message"] as? String ?? "Something went wrong"
            isValidResponse = false
        } else if let error {
            isValidResponse = false
            message = error.localizedDescription
        }
        
        if !isValidResponse && message.count > 0 && renderError {
            viewController.showAlert(title: AlertConstants.Error, message: message)
        }
        
        return isValidResponse
    }
    
    
//    public static func isValidResponse(cell: UITableViewCell,
//                                       response: Any?, error: Error?, renderError: Bool = false,
//                                       dismissLoading: Bool = true) -> Bool {
//        return  APIResponseUtil.check(response: response, error: error, renderError: renderError, dismissLoading: dismissLoading)
//    }
//
//
//    static func check (response: Any?, error: Error?, renderError: Bool = true,
//                       dismissLoading: Bool = true) -> Bool{
//        var isValidResponse = false
//        var message = ""
//
//        print(response as Any)
//
//        if error != nil {
//            if dismissLoading {
//                BaseClass().hideLoading()
//            }
//            message = AC.SomeThingWrong
//
//        } else {
//            if dismissLoading {
//                BaseClass().hideLoading()
//            }
//            if response != nil {
//                isValidResponse = true
//                if let code = response["Code"] as? Int, code == 1 {
//                    isValidResponse = true
//                }
//                else {
//                    message = response["message"] as? String ?? AC.SomeThingWrong
//                    //                    message = (message.count == 0 ? json["error_message"].stringValue : message)
//                }
//            } else {
//                isValidResponse = false
//            }
//        }
//        if !isValidResponse && message.count > 0 && renderError {
//            //            showErrorAlert(message: message, AlertTitle: AC.Error)
//        }
//        return isValidResponse
//    }
}

func decodeJson<T: Decodable>(_ dataJS: Any) -> T?{
    
    if let data = try? JSONSerialization.data(withJSONObject: dataJS) {
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            print(error as Any)
            return nil
        }
    } else {
        return nil
    }
}
