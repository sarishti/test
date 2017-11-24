//
//  Constants.swift

import Foundation

struct AppConstants {
    static let isAppUninstallKey = "isAppUninstall"

    static let errorDescription =  "error_description"
    static let error =  "error"
    static let errorDetail = "detail"
    static let statusKey = "status"
    static let  extrasKey = "extras"
    static let  messageKey = "message"
    static let accessDenied = 422
    // validation
    static let lengthFifty = 50
    static let lengthTwelve = 12
    static let lengthFifteen = 15
    static let lengthTwently = 20
    // language
    static let languageKey = "USER-LANG-CODE"
    static let languageDefaultKey = "userLanguage"
    static let userEmailDefaultKey = "userEmail"
    static let userTokenKeyChain = "userToken"
   static let appTokenKeyChain =  "appTokenKey"
    static let isDisplayLanguage = "isDisplayLanguage"
    // Time stamp
    static let timeFormatDisplay = "hh:mm a"
    static let timeFormatServer = "yyyy-MM-dd HH:mm:ss"
    static let localIdentifier = "en_US_POSIX"
    static let dateFormatServer = "yyyy-MM-dd"
    static let dateFormatCalender = "yyyy-MM-dd HH:mm:ss Z"
    static let timeZoneAbbreviation = "UTC"
}
