//
//  LoginViewController.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/25.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    private var viewModel: LoginViewModel! = .init()
    private let disposeBag = DisposeBag.init()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input.init(
            loginRequest: loginButton.rx.tap.asDriver(),
            signUpRequest: signUpButton.rx.tap.asDriver(),
            id: idTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver()
        )
        let output = viewModel.transform(input: input)
        
    }
}