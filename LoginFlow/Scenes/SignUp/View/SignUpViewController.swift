//
//  SignUpViewController.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/02.
//

import UIKit
import RxSwift

final class SignUpViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    
    private var viewModel: SignUpViewModel! = SignUpViewModel(
        userSignUpUseCase: UserSignUpUseCase()
    )
    
    // MARK: - UI Components
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var rePasswordTextField: UITextField! {
        didSet {
            rePasswordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = SignUpViewModel.Input.init(
            id: idTextField.rx.text.orEmpty.asDriver(),
            email: emailTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            rePassword: rePasswordTextField.rx.text.orEmpty.asDriver(),
            signUpRequest: signUpButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        output.signUp
            .emit(onNext: { if $0 { self.dismiss(animated: false) } })
            .disposed(by: disposeBag)
        
        output.passwordValidation
            .drive(onNext: { self.signUpButton.isEnabled = $0 })
            .disposed(by: disposeBag)
        
        output.error
            .emit(
                onNext: { error in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
}
