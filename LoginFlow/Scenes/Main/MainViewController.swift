//
//  MainViewController.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentLoginView()
    }
    
    func presentLoginView() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self))
        present(vc, animated: true)
    }
}
