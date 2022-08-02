//
//  SignUpError.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/02.
//

import Foundation

enum SignUpError: String, Error {
    case invalidPassword = "비밀번호는 5자 이상 15자 이하로 입력해주세요."
}
