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
            ),
            userDefaultRepository: UserDefaultsRepository()
        ),
        userLogoutUseCase: UserLogoutUseCase(
            keychainRepository: KeychainRepository(),
            userDefaultRepository: UserDefaultsRepository()
        )
    )
    
    // MARK: - UI Component
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.addAction(
                UIAction.init(handler: { _ in
                    self.showLoginView()
                }),
                for: .touchUpInside
            )
        }
    }
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input.init(
            viewWillAppear: self.rx.sentMessage(#selector(viewWillAppear(_:)))
                .map { _ in }
                .asSignal(onErrorJustReturn: ()),
            logoutRequest: logoutButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        output.isloggedIn
            .drive(
                onNext: { isloggedIn in
                    if isloggedIn {
                        self.loginButton.isHidden = true
                        self.logoutButton.isHidden = false
                    } else {
                        self.loginButton.isHidden = false
                        self.logoutButton.isHidden = true
                    }
                }
            )
            .disposed(by: disposeBag)
        
        output.logout
            .drive(
                onNext: {
                    self.loginButton.isHidden = false
                    self.logoutButton.isHidden = true
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    
    private func showLoginView() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false)
    }
}
