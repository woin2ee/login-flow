//
//  NetworkService.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkServiceProtocol {
    func request(_ path: String, _ query: String, _ method: HTTPMethod) -> Observable<JSON>
    func request(_ path: String, _ httpBody: Data?, _ method: HTTPMethod) -> Observable<JSON>
}

final class NetworkService: NetworkServiceProtocol {
    
    private let endPoint: String = "http://localhost:8080"
    
    func request(_ path: String, _ query: String, _ method: HTTPMethod) -> Observable<JSON> {
        let absolutePath = "\(endPoint)\(path)?\(query)"
        
        guard let url = URL.init(string: absolutePath)
        else { return .error(NetworkError.invalidURL) }
        
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = .init(10)
        
        return URLSession.shared.rx.response(request: urlRequest)
            .retry(3)
            .map { _, data -> JSON in try JSON.init(data: data) }
    }
    
    func request(_ path: String, _ httpBody: Data?, _ method: HTTPMethod) -> Observable<JSON> {
        let absolutePath = "\(endPoint)\(path)"
        
        guard let url = URL.init(string: absolutePath)
        else { return .error(NetworkError.invalidURL) }
        
        var urlRequest: URLRequest = .init(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = httpBody
        urlRequest.timeoutInterval = .init(10)
        
        return URLSession.shared.rx.response(request: urlRequest)
            .retry(3)
            .map { _, data -> JSON in try JSON.init(data: data) }
    }
}
