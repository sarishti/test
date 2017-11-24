//
//  VLTConfiguration.swift

import UIKit

struct Configuration {

    static var config: String?
    static var variables: NSDictionary?
    static var customHeaders: [String: String] = ["content-type": "application/json"]
    static var customHeadersToken: [String: String] = ["content-type": "application/x-www-form-urlencoded"]

    /**
     Set the configuartion variables from plist
     */

    static func setConfiguaration() {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            let configValue = configuration.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            self.config = configValue.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            if let path = Bundle.main.path(forResource: "Configuration", ofType: "plist") {
                // use swift dictionary as normal
                let dict = NSDictionary(contentsOfFile: path)
                self.variables = dict!.object(forKey: self.config!) as? NSDictionary
            }
        }
    }

    /**
     Get the base Url according to  configuration

     - returns: base url in string
     */

    static func BaseURL() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let url = self.variables!.object(forKey: "BaseURL") as? String {
                return url
            }
        }
        return ""
    }
    /**
     Get the clientSecret according to  configuration
     - returns: clientSecret for App in string
     */

    static func clientSecret() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let clientSecret = self.variables!.object(forKey: "clientSecret") as? String {
                return clientSecret
            }
        }
        return ""
    }
    /**
     Get the googleAPI according to  configuration
     - returns: googleAPI for User in string
     */

    static func googleMapsAPIKey() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let url = self.variables!.object(forKey: "googleMapsAPIKey") as? String {
                return url
            }
        }
        return ""
    }
    /**
     Get the placesClientKey according to  configuration
     - returns: placesClientKey for User in string
     */

    static func placesClientKey() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let url = self.variables!.object(forKey: "placesClientKey") as? String {
                return url
            }
        }
        return ""
    }
    /**
     Get the clientId according to  configuration
     - returns: clientId for App in string
     */

    static func clientId() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let clientId = self.variables!.object(forKey: "clientId") as? String {
                return clientId
            }
        }
        return ""
    }
    /**
     Get the userPassword according to  configuration
     - returns: clientId for App in string
     */

    static func userPassowrd() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let userPassword = self.variables!.object(forKey: "userPassword") as? String {
                return userPassword
            }
        }
        return ""
    }
    /**
     Get the userName according to  configuration
     - returns: clientId for App in string
     */

    static func userName() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let userName = self.variables!.object(forKey: "userName") as? String {
                return userName
            }
        }
        return ""
    }
    /**
     Get the grantType according to  configuration
     - returns: grantType for App in string
     */

    static func grantType() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let grantType = self.variables!.object(forKey: "grantType") as? String {
                return grantType
            }
        }
        return ""
    }
    /**
     Get the s3PoolId according to  configuration
     - returns: s3PoolId
     */

    static func s3PoolId() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let s3PoolId = self.variables!.object(forKey: "s3PoolId") as? String {
                return s3PoolId
            }
        }
        return ""
    }
    /**
     Get the s3BucketName according to  configuration
     - returns: s3BucketName
     */
    static func s3BucketName() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let s3BucketName = self.variables!.object(forKey: "s3BucketName") as? String {
                return s3BucketName
            }
        }
        return ""
    }
    /**
     Get the s3Path according to  configuration
     - returns: s3Path
     */
    static func s3Path() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let s3Path = self.variables!.object(forKey: "s3BasicPath") as? String {
                return s3Path
            }
        }
        return ""
    }
    /**
     Get the s3Path according to  configuration
     - returns: s3Path
     */
    static func s3profilePhoto() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let s3profilePhoto = self.variables!.object(forKey: "s3profilePhoto") as? String {
                return s3profilePhoto
            }
        }
        return ""
    }
    /**
     Get the s3Path according to  configuration
     - returns: s3Path
     */
    static func s3GovPhoto() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let s3GovPhoto = self.variables!.object(forKey: "s3GovPhoto") as? String {
                return s3GovPhoto
            }
        }
        return ""
    }
    /**
     Get the s3PropertyThumb according to  configuration
     - returns: s3PropertyThumb
     */
    static func s3PropertyThumb() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let s3PropertyThumb = self.variables!.object(forKey: "s3PropertyThumb") as? String {
                return s3PropertyThumb
            }
        }
        return ""
    }
    /**
     Get the s3PropertyFull according to  configuration
     - returns: s3PropertyFull
     */
    static func s3PropertyFull() -> String! {
        self.setConfiguaration()
        if (self.variables) != nil {
            if let s3PropertyFull = self.variables!.object(forKey: "s3PropertyFull") as? String {
                return s3PropertyFull
            }
        }
        return ""
    }
}
