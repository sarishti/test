//
//  LoginOptionViewController.swift
//  StayDream
//
//  Created by Sharisti on 23/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class LoginOptionViewController: UIViewController {

    @IBOutlet weak var btnGuest: UIButton!
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGuest.setBorder(with: #colorLiteral(red: 0.5699723363, green: 0.1442027688, blue: 0.6577451825, alpha: 1))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         self.setNavBarHide(hide: true)
         UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Outlet Action
    @IBAction func btnMemberTapped(_ sender: Any) {
         self.performSegue(withIdentifier: StoryboardSegue.Main.showSignUp.rawValue, sender: self)
    }
    @IBAction func btnMemberLoginTapped(_ sender: Any) {
        self.performSegue(withIdentifier: StoryboardSegue.Main.showLogin.rawValue, sender: self)
    }

    @IBAction func btnUseGuestTapped(_ sender: Any) {
        self.changeNavBarAppearanceLight(color: #colorLiteral(red: 0.4823529412, green: 0.3176470588, blue: 0.7647058824, alpha: 1))
        AppUtility.appDelegate()?.window?.rootViewController = StoryboardScene.Property.initialScene.instantiate()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
