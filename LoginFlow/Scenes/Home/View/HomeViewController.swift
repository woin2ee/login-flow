//
//  HomeViewController.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/25.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    
    private var viewModel: HomeViewModel! = HomeViewModel(
        tokenValidationUseCase: TokenValidationUseCase(
            keychainRepository: KeychainRepository(),
            userRepository: UserRepository(
                networkService: NetworkService()
            )
        )
    )
    
    // MARK: - UI Component
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input.init(
            viewWillAppear: self.rx.sentMessage(#selector(viewWillAppear(_:)))
                .map { _ in }
                .asSignal(onErrorJustReturn: ())
        )
        let output = viewModel.transform(input: input)
        
        output.isloggedIn
            .drive(
                onNext: { isloggedIn in
                    if isloggedIn {
                        self.loginButton.title = "로그아웃"
                    } else {
                        self.loginButton.title = "로그인"
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    
    @IBAction func didTapLoginButton(_ sender: UIBarButtonItem) {
        self.showLoginView()
    }
    
    private func showLoginView() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
