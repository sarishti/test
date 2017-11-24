//
//  UserUtility.swift
//  StayDream
//
//  Created by Sharisti on 15/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
struct UserUtility {
    /// Get user Type from keychain
    ///
    /// - Returns: email Id
    static func getUserName() -> String {
        var strValue = ""
        if let userObject = KeychainWrapper.standard.object(forKey: AppConstants.userTokenKeyChain), let userObj = userObject as? UserModel, let nameValue = userObj.firstName {
            let arrString = nameValue.components(separatedBy: " ")
            for string in arrString {
                strValue = strValue + String(string.characters.first!)
            }

            return strValue
        }
        return ""
    }

    /// Get user id from keychain
    ///
    /// - Returns: email Id
    static func getUserId() -> String {
        if let userObject = KeychainWrapper.standard.object(forKey: AppConstants.userTokenKeyChain), let userObj = userObject as? UserModel, let idValue = userObj.id {
            return "\(idValue)"
        }
        return ""
    }
    /// Get user email token from keychain
    ///
    /// - Returns: email Id
    static func getUserToken() -> String? {
        if let userObject = KeychainWrapper.standard.object(forKey: AppConstants.userTokenKeyChain), let userObj = userObject as? UserModel, let tokenValue = userObj.accessToken {
            return "\(tokenValue)"
        }
        return nil
    }
}
