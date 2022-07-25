//
//  ViewModelType.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/25.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
