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
        userSignUpUseCase: UserSignUpUseCase(
            userRepository: UserRepository(
                networkService: NetworkService()
            )
        )
    )
    
    // MARK: - UI Components
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var idValidationLabel: UILabel! {
        didSet { idValidationLabel.isHidden = true }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailValidationLabel: UILabel! {
        didSet { emailValidationLabel.isHidden = true }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.textContentType = .oneTimeCode
        }
    }
    @IBOutlet weak var rePasswordTextField: UITextField! {
        didSet {
            rePasswordTextField.isSecureTextEntry = true
            rePasswordTextField.textContentType = .oneTimeCode
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
        
        [
            output.signUp
                .emit(onNext: {
                    self.showAlert(
                        message: "회원가입에 성공했습니다.",
                        handler: { _ in
                            self.dismiss(animated: false)
                        }
                    )
                }),
            output.idValidation
                .skip(1)
                .drive(onNext: { self.idValidationLabel.isHidden = $0 }),
            output.emailValidation
                .skip(1)
                .drive(onNext: { self.emailValidationLabel.isHidden = $0 }),
            output.passwordValidation
                .drive(),
            output.signUpButtonEnable
                .drive(onNext: { self.signUpButton.isEnabled = $0 }),
            output.error
                .emit(onNext: { _ in self.showAlert(message: SignUpError.anyError.rawValue) })
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
    
    private func showAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController.init(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction.init(
            title: "확인",
            style: .default,
            handler: handler
        )
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true)
    }
}
