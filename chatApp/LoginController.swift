//
//  LoginController.swift
//  chatApp
//
//  Created by Ayso Lima Marques on 08/01/17.
//  Copyright © 2017 Ayso Lima marques. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let nameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "e-mail"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let emailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let profileImageView: UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "naty")
        btn.setImage(image, for: UIControlState.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 75
        btn.layer.masksToBounds = true
        
        
        //part the handle the interaction with the profile image
        btn.imageView?.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(handleSelectProfileImageView), for: .touchUpInside)

        
        return btn
    } ()
    
    
    
   lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        
        return button
    }()
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else {
            handleRegister()
        }
    }
    
    
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        registerButton.setTitle(title, for: .normal)
        
        //this changes the height of the container according to the index selected
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //excluding the name text field and adapting the others two when pressing login
        //DELETING THE NAME TEXT FIELD IN CASE OF INDEX = 0
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = true
        
        //PUTTING E-MAIL AND PASSWORD TO FIT PERFECTLY THE CONTAINER WHEN INDEX 0
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(registerButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl()  {
        //need x, y , width, height constraints
        view.addConstraints([
            loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12),
            loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    
    func setupProfileImageView() {
        view.addConstraints([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -60),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
            ])
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        //need x, y , width, height constraints
        
        view.addConstraints([
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24)
            ])
        
            //this anchor needs to be dynamic (the container height anchor)
            inputsContainerViewHeightAnchor =  inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
            inputsContainerViewHeightAnchor?.isActive = true
        
            inputsContainerView.addSubview(nameTextField)
            inputsContainerView.addSubview(nameSeparator)
            inputsContainerView.addSubview(emailTextField)
            inputsContainerView.addSubview(emailSeparator)
            inputsContainerView.addSubview(passwordTextField)
        
            //inputs, also need x, y , width, height constraints
            //#NAME TEXT FIELD
            view.addConstraints([
                nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
                nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor),
                nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor)
                ])
        
                nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
                nameTextFieldHeightAnchor?.isActive = true
        
            //NAME SEPARATOR
            view.addConstraints([
                nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
                nameSeparator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor),
                nameSeparator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
                nameSeparator.heightAnchor.constraint(equalToConstant: 1)
                ])
            //E-MAIL TEXT FIELD
            view.addConstraints([
                emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
                emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
                emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor)
                ])
        
                emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
                emailTextFieldHeightAnchor?.isActive = true
        
            //E-MAIL SEPARATOR
            view.addConstraints([
            emailSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailSeparator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor),
            emailSeparator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            emailSeparator.heightAnchor.constraint(equalToConstant: 1)
            ])
            //PASSWORD FIELD
        view.addConstraints([
            passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor)
            ])
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func setupRegisterButton() {
        //need x, y, width, height constraints 
        
        view.addConstraints([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12),
            registerButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
