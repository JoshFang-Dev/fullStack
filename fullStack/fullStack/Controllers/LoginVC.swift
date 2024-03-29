//
//  LoginVC.swift
//  fullStack
//
//  Created by Yilei Huang on 2019-10-06.
//  Copyright © 2019 Joshua Fang. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD
import UIKit

class LoginVC: LBTAFormController {

    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "startup"), contentMode: .scaleAspectFit)
       let logoLabel = UILabel(text: "FullStack Social", font: .systemFont(ofSize: 32, weight: .heavy), textColor: .black, numberOfLines: 0)
       
       let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress)
       let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25)
       lazy var loginButton = UIButton(title: "Login", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: .black, target: self, action: #selector(handleLogin))
       
       let errorLabel = UILabel(text: "Your login credentials were incorrect, please try again.", font: .systemFont(ofSize: 14), textColor: .red, textAlignment: .center, numberOfLines: 0)
       
       lazy var goToRegisterButton = UIButton(title: "Need an account? Go to register.", titleColor: .black, font: .systemFont(ofSize: 16), target: self, action: #selector(goToRegister))
       
       @objc fileprivate func goToRegister() {
      //  let controller = RegisterVC()
        //navigationController?.pushViewController(controller, animated: true)
        let controller = RegisterVC(alignment: .center)
        navigationController?.pushViewController(controller, animated: true)
       }
    
       
       @objc fileprivate func handleLogin() {
           let hud = JGProgressHUD(style: .dark)
           hud.textLabel.text = "Logging in"
           hud.show(in: view)
           
           guard let email = emailTextField.text else { return }
           guard let password = passwordTextField.text else { return }
           
           errorLabel.isHidden = true
        
        //let url = "http://localhost:1337/api/v1/entrance/login"
        let params = ["emailAddress": email, "password": password]
        
        
        Service.shared.login(email: email, password: password) { (res) in
            hud.dismiss()
            switch res{
            case .success:
                print("Finally sent request to server..lets see what we have..")
                self.dismiss(animated: true)
            case .failure(let err):
                self.errorLabel.isHidden = false
                self.errorLabel.text = err.localizedDescription
            }
        }
           
           
//           Alamofire.request(url, method: .put, parameters: params, encoding: URLEncoding())
//                .validate(statusCode:200..<300)
//               .responseData { (dataResponse) in
//
//                   hud.dismiss()
//                if let _ = dataResponse.error{
//                    self.errorLabel.isHidden = false
//                    return
//                }
//
//                   print("Finally sent request to server..lets see what we have..")
//                   self.dismiss(animated: true)
//
//           }
       }
    
    override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .init(white: 0.95, alpha: 1)
           
           emailTextField.autocapitalizationType = .none
           emailTextField.backgroundColor = .white
           passwordTextField.backgroundColor = .white
           passwordTextField.isSecureTextEntry = true
           loginButton.layer.cornerRadius = 25
           navigationController?.navigationBar.isHidden = true
           errorLabel.isHidden = true
           
           let formView = UIView()
           formView.stack(
               formView.stack(formView.hstack(logoImageView.withSize(.init(width: 80, height: 80)), logoLabel.withWidth(160), spacing: 16, alignment: .center).padLeft(12).padRight(12), alignment: .center),
               UIView().withHeight(12),
               emailTextField.withHeight(50),
               passwordTextField.withHeight(50),
               loginButton.withHeight(50),
               errorLabel,
               goToRegisterButton,
               UIView().withHeight(80),
               spacing: 16).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
           
           formContainerStackView.padBottom(-24)
           formContainerStackView.addArrangedSubview(formView)
       }

}
