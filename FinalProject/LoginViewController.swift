//
//  ViewController.swift
//  FinalProject
//
//  Created by James Monahan 
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {
    
    var authUI: FUIAuth!
    var documentID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        FUIAuth.defaultAuthUI()?.shouldHideCancelButton = true
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }

    func signIn() {
        let providers: [FUIAuthProvider] = [
          FUIGoogleAuth(),
        ]
        
        if authUI.auth?.currentUser == nil { // user has not signed in
            self.authUI.providers = providers // show providers named after let providers: above
            let loginViewController = authUI.authViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        }else { // user is already logged in
            guard let currentUser = authUI.auth?.currentUser else {
                print("Error: Couldn't get currentUser")
                return
            }
            let profileUser = ProfileUser(user: currentUser)
            
            
            profileUser.saveIFNewUser { (success) in
                if success{
                    DispatchQueue.main.asyncAfter(deadline:.now() + 1.0, execute: {
                        self.performSegue(withIdentifier: "FirstShowSegue", sender: nil)
                    })
                } else {
                    print("Error: Tried to save a new SnackUser, but failed")
                }
            }
        }
    }
  

    func signOut() {
        do {
            try authUI!.signOut()
        } catch {
            print("😡 ERROR: couldn't sign out")
            performSegue(withIdentifier: "FirstShowSegue", sender: nil)
        }
    }
    
    @IBAction func unwindSignOutPressed(segue: UIStoryboardSegue) {
        if segue.identifier == "SignOutUnwind" {
            signOut()
        }
        
    }
}


extension LoginViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
      }
      // other URL handling goes here.
      return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard error == nil else {
            print("😡 ERROR: during signin \(error!.localizedDescription)")
            return
        }
        if let user = user {
            print("📝 We signed in with user \(user.email ?? "unknown e-mail")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let marginInsets: CGFloat = 50.0 // amount to indent UIImageView on each side
        let topSafeArea = self.view.safeAreaInsets.top
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        loginViewController.view.subviews[0].backgroundColor = UIColor.clear
        loginViewController.view.subviews[0].subviews[0].backgroundColor = UIColor.clear
        
        // Create a frame for a UIImageView to hold our logo
        let x = marginInsets
        let y = marginInsets + topSafeArea
        let width = self.view.frame.width - (marginInsets * 2)
        //        let height = loginViewController.view.subviews[0].frame.height - (topSafeArea) - (marginInsets * 2)
        let height = UIScreen.main.bounds.height - (topSafeArea) - (marginInsets * 2)
        
        let logoFrame = CGRect(x: x, y: y, width: width, height: height)
        
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}

