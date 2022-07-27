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
        
        // 로그인 성공 or 실패해서 onNext event 가 넘어왔을때 넘어온 데이터를 이용해 어떻게 View에 보여줄지 지정
        output.login
            .drive(
                onNext: { success in
                    self.view.endEditing(true)
                    if success { // 로그인 성공 : 로그인 화면 dismiss
                        self.dismiss(animated: false)
                    } else { // 로그인 실패 : 비밀번호 초기화, 틀렸다는 알림 보여주기
                        self.passwordTextField.text = nil
                        print("show alert view")
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    @IBAction func didTapDismissButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
