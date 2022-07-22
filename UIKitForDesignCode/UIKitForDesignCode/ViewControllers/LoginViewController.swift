//
//  LoginViewController.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/22.
//

import UIKit
import FirebaseAuth
import Combine

class LoginViewController: UIViewController {
    @IBOutlet var loginCard: CustomView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var primaryBtn: UIButton!
    @IBOutlet var accessoryBtn: UIButton!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    private var emailIsEmpty = true
    private var passwordIsEmpty = true
    private var tokens: Set<AnyCancellable> = []
    
    private var loginStatus: LoginStatus = .signUp {
        didSet {
            self.titleLabel.text = loginStatus == .signUp ? "Sign up" : "Sign in"
            self.primaryBtn.setTitle(loginStatus == .signUp ? "Create account" : "Sign in", for: .normal)
            self.accessoryBtn.setTitle(loginStatus == .signUp ? "Already hava an account" : "Dont't hava an account", for: .normal)
            self.accessoryBtn.subtitleLabel?.text = loginStatus == .signUp ? "Sign in" : "Sign up"
            self.passwordTextfield.textContentType = loginStatus == .signUp ? .newPassword : .password
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut) {
            self.loginCard.alpha = 1
            self.loginCard.frame = self.loginCard.frame.offsetBy(dx: 0, dy: -400)
        }
        
        emailTextfield.publisher(for: \.text)
            .sink { newValue in
                self.emailIsEmpty = newValue == "" || newValue == nil
            }
            .store(in: &tokens)
        
        passwordTextfield.publisher(for: \.text)
            .sink { newValue in
                self.passwordIsEmpty = newValue == "" || newValue == nil
            }
            .store(in: &tokens)
    }
    
    @IBAction func primaryBtnAction(_ sender: Any) {
        if (emailIsEmpty || passwordIsEmpty) {
            let alert = UIAlertController(title: "Missing Information", message: "Please make sure to enter a valid email address and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        if loginStatus == .signUp {
            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { result, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                self.goToHomeScreen()
            }
        } else {
            Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { result, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                self.goToHomeScreen()
            }
        }
    }
    
    @IBAction func accessoryBtnAction(_ sender: Any) {
        self.loginStatus = self.loginStatus == .signUp ? .signIn : .signUp
        
    }
    
    func goToHomeScreen() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

enum LoginStatus {
    case signUp
    case signIn
}
