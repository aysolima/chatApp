//
//  ViewController.swift
//  chatApp
//
//  Created by Ayso Lima Marques on 08/01/17.
//  Copyright © 2017 Ayso Lima marques. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        
        //if the user is not logged in, log out// putting it here cause every time the view appear it will check the user, avoind the bug of log out enter in another account and the title name still the name of the previous account
        
        checkIfTheUserIsLoggedIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout) )
        
        let image = UIImage(named: "Doge")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewChat))
    }
    
    func handleNewChat() {
        let navController = UINavigationController(rootViewController: NewChatController())
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfTheUserIsLoggedIn() {
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String : AnyObject] {
                    print(snapshot)
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
            }, withCancel: nil)
            
        }
    }
    
    func handleLogout()  {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        
        present(loginController, animated: true, completion: nil)
    }
}

