//
//  LaunchViewController.swift
//  StayDream
//
//  Created by Sharisti on 23/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       self.setNavBarHide(hide: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.delay(5.0) {
            AppUtility.dismissLoaderOnView()
            if let _ = UserUtility.getUserToken() {
                //KeychainWrapper.standard.string(forKey:AppConstants.userTokenKeyChain) != nil {
                self.changeNavBarAppearanceLight(color:#colorLiteral(red: 0.4823529412, green: 0.3176470588, blue: 0.7647058824, alpha: 1))
                AppUtility.appDelegate()?.window?.rootViewController = StoryboardScene.Property.initialScene.instantiate()
            } else if let _ = AppUtility.getValueFromUserDefaultsForKey(AppConstants.isDisplayLanguage) {
                self.changeNavBarAppearanceLight()
                let navigationController = UINavigationController(rootViewController:  StoryboardScene.Main.loginOptionViewController.instantiate())
                AppUtility.appDelegate()?.window?.rootViewController = navigationController
            } else {
                self.performSegue(withIdentifier: StoryboardSegue.Main.showLanguage.rawValue, sender: self)
            }
        }
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
