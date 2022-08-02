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
    
    private var viewModel: LoginViewModel! = LoginViewModel(
        userLoginUseCase: UserLoginUseCase(
            userRepository: UserRepository(
                networkService: NetworkService()
            ),
            keychainRepository: KeychainRepository(),
            userDefaultRepository: UserDefaultsRepository()
        )
    )
    
    // MARK: UI Component
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet { passwordTextField.isSecureTextEntry = true }
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addAction(
                UIAction.init(handler: { _ in
                    self.showSignUpView()
                }),
                for: .touchUpInside
            )
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input.init(
            loginRequest: loginButton.rx.tap.asSignal(),
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
            .emit(
                onNext: { error in
                    self.view.endEditing(true)
                    self.passwordTextField.text = ""
                    self.passwordTextField.sendActions(for: .valueChanged)
                    
                    if let error = error as? LoginError {
                        self.showAlert(message: error.description)
                    } else {
                        self.showAlert(message: LoginError.defaultDescription)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController.init(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction.init(
            title: "확인",
            style: .default
        )
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true)
    }
    
    private func showSignUpView() {
        let storyboard = UIStoryboard.init(name: "SignUp", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "SignUpNavigationController")
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false)
    }
}
