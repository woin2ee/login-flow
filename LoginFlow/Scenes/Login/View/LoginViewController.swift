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
    
    private let disposeBag = DisposeBag.init()
    
    private var viewModel: LoginViewModel! = .init(userLoginUseCase: UserLoginUseCase(userRepository: UserRepository(networkService: NetworkService())))
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
        }
    }
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
        
        output.login
            .drive(
                onNext: {
                    self.view.endEditing(true)
                    self.dismiss(animated: false)
                }
            )
            .disposed(by: disposeBag)
        
        output.error
            .drive(
                onNext: { error in
                    self.view.endEditing(true)
                    self.passwordTextField.text = nil
                    
                    if let error = error as? SignUpError {
                        print("\(error.description)")
                    } else {
                        print("Error >>>>> \(error.localizedDescription)")
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    @IBAction func didTapDismissButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
