//
//  BaseFetcher.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON
import Alamofire

enum APIDataType {
    case formData
    case jsonData
    case querryString
    
    var dataType: ParameterEncoding {
        switch self {
        case .formData:
            return URLEncoding.httpBody
        case .jsonData:
            return JSONEncoding.default
        case .querryString:
            return URLEncoding.queryString
        }
    }
    
    var httpHeaders: HTTPHeaders {
        switch self {
        case .formData:
            return ["Accept": "application/json",
                    "Content-Type": "application/x-www-form-urlencoded",
                    "Transfer-Encoding": "chunked"]
        case .jsonData, .querryString:
            return ["Accept": "application/json",
                    "Content-Type": "application/json",
                    "Transfer-Encoding": "chunked"]
        }
    }
}

protocol RequestConditions {
    var baseURL: String { get }
    var apiURL: String { get }
    var params: Dictionary<String, Any> { get }
    var method: HTTPMethod { get }
    var dataType: APIDataType { get }
}

extension RequestConditions {
    var urlString: String {
        baseURL.appending(apiURL)
    }
}

typealias CompleteAPIClosure = (_ jsonData: JSON) -> Void
typealias FailureAPIClosure = (_ error: Error) -> Void

protocol BaseFetcherInterface {
    func fetchRequest(requestConditions: RequestConditions,
                      complete: CompleteAPIClosure?,
                      failure: FailureAPIClosure?)
}

final class BaseFetcher {
    static let shared = BaseFetcher()
    
    private lazy var alamoFireManager: SessionManager = SessionManager()
}

extension BaseFetcher: BaseFetcherInterface {
    private func dataRequest(requestConditions: RequestConditions) -> DataRequest {
        alamoFireManager.request(requestConditions.urlString,
                                 method: requestConditions.method,
                                 parameters: requestConditions.params,
                                 encoding: requestConditions.dataType.dataType,
                                 headers: requestConditions.dataType.httpHeaders)
    }
    
    func fetchRequest(requestConditions: RequestConditions,
                      complete: CompleteAPIClosure?,
                      failure: FailureAPIClosure?) {
        let _ = dataRequest(requestConditions: requestConditions)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let value = response.result.value else {
                        return
                    }
                    complete?(JSON(value))
                case .failure:
                    guard let error = response.error else {
                        return
                    }
                    failure?(error)
                }
        }
    }
}
