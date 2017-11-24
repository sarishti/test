//
//  ProfileViewController.swift
//  StayDream
//
//  Created by Sharisti on 27/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UserAPI {

    // MARK: Outlet
    @IBOutlet weak var lblLastLogIn: UILabel!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var imgLanguage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var btnProfileImage: UIButton!
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Initialize View
    func initializeView() {
        btnProfileImage.layer.borderColor = #colorLiteral(red: 0.4675287604, green: 0.4606551528, blue: 0, alpha: 1)
        lblUserName.text = UserUtility.getUserName()
    }
    // MARK: Action

    @IBAction func btnChangePswdTapped(_ sender: Any) {
    }
    @IBAction func btnMemberTermsTapped(_ sender: Any) {
    }
    @IBAction func btnLanguageTapped(_ sender: Any) {
    }
    @IBAction func btnMemberInfoTapped(_ sender: Any) {
    }
    @IBAction func btnEditProfileTapped(_ sender: Any) {
    }
    @IBAction func btnEditGovIdTapped(_ sender: Any) {
    }
    @IBAction func btnLogoutTapped(_ sender: Any) {
        if let _ = UserUtility.getUserToken() {
            self.signOutService()
         } else {
            AppUtility.showAlert("", message: "No user is logged in", delegate: self)
        }

    }
    func signOutService() {
        self.signOut { (responseData) in
            guard let emailSuccess = responseData?.response as? Dictionary<String, Any> else {
                AppUtility.showAlert("", message: (responseData?.message)!, delegate: self)
                return
            }
            if let extraKey = emailSuccess[AppConstants.extrasKey] as? [String:Any], let messageOfSuccess = extraKey[AppConstants.messageKey] as? String {
                self.showAlertWithAction(messageOfSuccess:messageOfSuccess)
            }
        }
    }
    // Pop the screen afetr success message
    func showAlertWithAction(messageOfSuccess: String) {
        let alertController = UIAlertController(title: "", message: messageOfSuccess, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OkTitle".localized, style: .cancel) { (_) in
            ServiceUtility.callHandleLogout()
        }
        alertController.addAction(okAction)

        AppUtility.appDelegate()?.window?.rootViewController?.present(alertController, animated: true, completion: {})
    }

    @IBAction func btnUploadTapped(_ sender: Any) {
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
