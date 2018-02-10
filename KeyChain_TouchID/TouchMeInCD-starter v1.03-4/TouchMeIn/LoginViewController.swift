/*
* Copyright (c) 2017 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreData

// Keychain configuration
struct KeychainConfiguration {
    static let serviceName = "TouchMeIn"
    static let accessGroup: String? = nil
}

class LoginViewController: UIViewController {
  
  var managedObjectContext: NSManagedObjectContext?
  var passwordItems: [KeychainPasswordItem] = []
  //determine if the Login button is being used to create some credentials, or to log in
  let createLoginButtonTag = 0
  let loginButtonTag = 1
  
    @IBOutlet var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var createInfoLabel: UILabel!  
    @IBOutlet var touchIDButton: UIButton!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // 1
    let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
    
    // 2
    if hasLogin {
        loginButton.setTitle("Login", for: .normal)
        loginButton.tag = loginButtonTag
        createInfoLabel.isHidden = true
    } else {
        loginButton.setTitle("Create", for: .normal)
        loginButton.tag = createLoginButtonTag
        createInfoLabel.isHidden = false
    }
    
    // 3
    if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
        usernameTextField.text = storedUsername
    }
  }
  
  // MARK: - Action for checking username/password
  @IBAction func loginAction(_ sender: AnyObject) {
    // 1
    // Check that text has been entered into both the username and password fields.
    // If either the username or password is empty, you present an alert to the user and return from the method.
    guard let newAccountName = usernameTextField.text,
        let newPassword = passwordTextField.text,
        !newAccountName.isEmpty,
        !newPassword.isEmpty else {
            showLoginFailedAlert()
            return
    }
    
    // 2 Dismiss the keyboard if it’s visible.
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    
    // 3.If the login button’s tag is createLoginButtonTag, then proceed to create a new login.
    if sender.tag == createLoginButtonTag {
        // 4 Next, you read hasLoginKey from UserDefaults which you use to indicate whether a password has been saved to the Keychain. If hasLoginKey is false and the username field has any text, then you save that text as username to UserDefaults.
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if !hasLoginKey && usernameTextField.hasText {
            UserDefaults.standard.setValue(usernameTextField.text, forKey: "username")
        }
        
        // 5 You create a KeychainPasswordItem with the serviceName, newAccountName (username) and accessGroup. Using Swift’s error handling, you try to save the password. The catch is there if something goes wrong.
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: newAccountName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword(newPassword)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        // 6You then set hasLoginKey in UserDefaults to true to indicate a password has been saved to the keychain. You set the login button’s tag to loginButtonTag to change the button’s text, so it will prompt the user to log in the next time they run your app, rather than prompting the user to create a login. Finally, you dismiss loginView.
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
        loginButton.tag = loginButtonTag
        performSegue(withIdentifier: "dismissLogin", sender: self)
    } else if sender.tag == loginButtonTag {
        // 7 If the user is logging in (as indicated by loginButtonTag), you call checkLogin to verify the user-provided credentials; if they match then you dismiss the login view.
        if checkLogin(username: newAccountName, password: newPassword) {
            performSegue(withIdentifier: "dismissLogin", sender: self)
        } else {
            // 8 If the login authentication fails, then present an alert message to the user.
            showLoginFailedAlert()
        }
    }
  }
    
    @IBAction func touchIDLoginAction() {
        
    }
    
    
    func checkLogin(username: String, password: String) -> Bool {
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    
    //tell the user if the login fails
    private func showLoginFailedAlert() {
        let alertView = UIAlertController(title: "Login Problem",
                                          message: "Wrong username or password.",
                                          preferredStyle:. alert)
        let okAction = UIAlertAction(title: "Foiled Again!", style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
  
}
