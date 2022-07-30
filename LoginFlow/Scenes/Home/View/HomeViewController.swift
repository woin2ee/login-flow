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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear >>>>> \(readKeychain())")
    }
    
    @IBAction func didTapLoginButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    private func readKeychain() -> String {
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : "Service name",
                                 kSecAttrAccount : "Account",
                                  kSecMatchLimit : kSecMatchLimitOne,
                            kSecReturnAttributes : true,
                                  kSecReturnData : true]
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return "none" }
        
        guard let existingItem = item as? [CFString : Any],
              let token = existingItem[kSecAttrGeneric] as? String
        else { return "none" }
        
        return token
    }
}
