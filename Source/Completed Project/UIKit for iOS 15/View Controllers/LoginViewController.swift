//
//  LoginViewController.swift
//  UIKit for iOS 15
//
//  Created by Sai Kambampati on 1/4/22.
//

import UIKit
import FirebaseAuth
import Combine

class LoginViewController: UIViewController {
    enum Login {
        case signIn
        case signUp
    }

    @IBOutlet var loginCard: CustomView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var primaryBtn: UIButton!
    @IBOutlet var accessoryBtn: UIButton!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var status: Login = .signUp {
        didSet {
            if status == .signIn {
                self.titleLabel.text = "Sign in"
                self.primaryBtn.setTitle("Sign In", for: .normal)
                self.accessoryBtn.setTitle("Don't have an account?", for: .normal)
                self.passwordField.textContentType = .password
            } else {
                self.titleLabel.text = "Sign up"
                self.primaryBtn.setTitle("Create Account", for: .normal)
                self.accessoryBtn.setTitle("Already have an account?", for: .normal)
                self.passwordField.textContentType = .newPassword
            }
        }
    }
    
    var emailEmpty = true
    var passwordEmpty = true
    private var tokens: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut) {
            self.loginCard.alpha = 1.0
            self.loginCard.frame = self.loginCard.frame.offsetBy(dx: 0, dy: -400)
        }
        
        emailField.publisher(for: \.text)
            .sink { newValue in
                if newValue != nil && newValue != "" {
                    self.emailEmpty = false
                } else {
                    self.emailEmpty = true
                }
            }
            .store(in: &tokens)
        
        passwordField.publisher(for: \.text)
            .sink { newValue in
                if newValue != nil && newValue != "" {
                    self.passwordEmpty = false
                } else {
                    self.passwordEmpty = true
                }
            }
            .store(in: &tokens)
    }
    
    @IBAction func primaryAction(_ sender: Any) {
        if (emailEmpty || passwordEmpty) == true {
            let alert = UIAlertController(title: "Missing Information", message: "Please make sure to enter a valid email and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            if status == .signUp {
                Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { result, err in
                    if err != nil {
                        print(err!.localizedDescription)
                    } else {
                        self.goToHomeScreen()
                    }
                }
            } else {
                Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { result, err in
                    if err != nil {
                        print(err!.localizedDescription)
                    } else {
                        self.goToHomeScreen()
                    }
                }
            }
        }
    }
    
    @IBAction func accessoryAction(_ sender: Any) {
        status = (status == .signIn) ? .signUp : .signIn
    }
    
    func goToHomeScreen() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! CustomTabBarViewController
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
