//
//  ServiceUtility.swift
//  DITY
//

import Foundation
import UIKit
import AVFoundation

struct  ServiceUtility {
    /// Logout service is done by backend we will remove user keys and move to signin screen
    static func callHandleLogout() {
        // Remove key token object
        KeychainWrapper.standard.removeObject(forKey: AppConstants.userTokenKeyChain)
//        AppUtility.removeUserDefaultKeys()
        // set the app token of application
        AppUtility.setAppToken()
        let navigationController = UINavigationController(rootViewController:  StoryboardScene.Main.loginOptionViewController.instantiate())
        AppUtility.appDelegate()?.window?.rootViewController = navigationController
    }

}
