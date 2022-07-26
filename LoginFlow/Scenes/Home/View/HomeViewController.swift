//
//  HomeViewController.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/25.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapLoginButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
