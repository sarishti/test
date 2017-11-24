//
//  TermsOfServiceViewController.swift
//  StayDream
//
//  Created by Sharisti on 30/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController, UIWebViewDelegate, UserAPI {
    // MARK: Outlet
    @IBOutlet weak var webView: UIWebView!
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.termsOfService()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Outlet Action
    @IBAction func btnBackTapped(_ sender: Any) {
        self.popViewController(animated: true)
    }
    // call web service
    func termsOfService() {
        //  value for sign up term and service
        self.termsOfService(Enums.TermsPage.memeber.rawValue) { (responseData) in
            guard let objPages = responseData?.response else {
                AppUtility.showAlert("", message: (responseData?.message)!, delegate: self)
                return
            }
            guard let contentOfPage = objPages.content else {
                return
            }
            print(contentOfPage)
            self.webView.loadHTMLString(contentOfPage, baseURL: nil)
        }
    }

}
