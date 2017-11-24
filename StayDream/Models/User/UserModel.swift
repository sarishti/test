//
// User.swift
//

import Foundation
import ObjectMapper

class UserModel: NSObject, Mappable, NSCoding {
    /// User properties
    /** Id of user. */
    var id: Int?
    /** user email id. */
    var userEmailId: String?
    /** Email of user. */
    var corporateIndicator: Bool?
    /** Password of user. */
    var password: String?
    /** New Password of user. */
    var firstName: String?
    /** Birth date of user. */
    var birthDate: String?
    /** last name of user. */
    var lastName: String?
    /** middle name of user. */
    var middleName: String?
    /** alias name of user. */
    var aliasName: String?
    /** company name of user. */
    var companyName: String?
    /** address line_1_text of user. */
    var addressLine1Text: String?
    /** address line_2_text of user. */
    var addressLine2Text: String?
    /** address line_3_text of user */
    var addressLine3Text: String?
    /** address city_name of user */
    var addressCityName: String?
    /** address regional_area_code user */
    var addressRegionalAreaCode: String?
    /** address postal_code of user */
    var addressPostalCode: String?
    /** address country_code of user */
    var addressCountryCode: String?
    /** address country_name of user */
    var addressCountryName: String?
    /** mobile phone_number of user */
    var mobilePhoneNumber: String?
    /** main phone_number of user */
    var mainPhoneNumber: String?
    /** personal photo_path_text of user */
    var personalPhotoPathText: String?
    var accessToken: String?
    /** marketing communications consent indicator*/
    var marketingCommunicationsConsentIndicator: Bool?
    var governmentIdPhotoPathText: String?
    /** User Since Date*/
    var userSinceDate: String?
    /** Login Last time*/
    var lastLogin: String?

    override init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        userEmailId <- map["user_email_id"]
        corporateIndicator <- map["corporate_indicator"]
        password <- map["password"]
        firstName <- map["first_name"]
        middleName <- map["middle_name"]
        aliasName <- map["alias_name"]
        birthDate <- map["birth_date"]
        lastName <- map["last_name"]
        companyName <- map["company_name"]
        addressLine1Text <- map["address_line_1_text"]
        addressLine2Text <- map["address_line_2_text"]
        addressLine3Text <- map["address_line_3_text"]
        addressCityName <- map["address_city_name"]
        addressRegionalAreaCode <- map["address_regional_area_code"]
        addressPostalCode <- map["address_postal_code"]
        addressCountryCode <- map["address_country_code"]
        addressCountryName <- map["address_country_name"]
        mobilePhoneNumber <- map["mobile_phone_number"]
        mainPhoneNumber <- map["main_phone_number"]
        personalPhotoPathText <- map["personal_photo_path_text"]
        marketingCommunicationsConsentIndicator <- map ["marketing_communications_consent_indicator"]
        accessToken <- map["access_token"]
        governmentIdPhotoPathText <- map["government_id_photo_path_text"]
        userSinceDate <- map["user_since_date"]
        lastLogin <- map["last_login"]

    }

    func encode(with aCoder: NSCoder) {

        aCoder.encode(self.accessToken, forKey: "access_token")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.userEmailId, forKey: "user_email_id")
        aCoder.encode(self.corporateIndicator, forKey: "corporate_indicator")
        aCoder.encode(self.firstName, forKey: "first_name")
        aCoder.encode(self.middleName, forKey: "middle_name")
        aCoder.encode(self.aliasName, forKey: "alias_name")
        aCoder.encode(self.birthDate, forKey: "birth_date")
        aCoder.encode(self.lastName, forKey: "last_name")
        aCoder.encode(self.companyName, forKey: "company_name")
        aCoder.encode(self.addressLine1Text, forKey: "address_line_1_text")
        aCoder.encode(self.addressLine2Text, forKey: "address_line_2_text")
        aCoder.encode(self.addressLine3Text, forKey: "address_line_3_text")
        aCoder.encode(self.addressCityName, forKey: "address_city_name")
        aCoder.encode(self.addressRegionalAreaCode, forKey: "address_regional_area_code")
        aCoder.encode(self.addressPostalCode, forKey: "address_postal_code")
        aCoder.encode(self.addressCountryCode, forKey: "address_country_code")
        aCoder.encode(self.addressCountryName, forKey: "address_country_name")
        aCoder.encode(self.mobilePhoneNumber, forKey: "mobile_phone_number")
        aCoder.encode(self.mainPhoneNumber, forKey: "main_phone_number")
        aCoder.encode(self.personalPhotoPathText, forKey: "personal_photo_path_text")
        aCoder.encode(self.marketingCommunicationsConsentIndicator, forKey: "marketing_communications_consent_indicator")
        aCoder.encode(self.governmentIdPhotoPathText, forKey: "government_id_photo_path_text")
        aCoder.encode(self.lastLogin, forKey:"last_login")
        aCoder.encode(self.userSinceDate, forKey:"user_since_date")

    }

    required init?(coder aDecoder: NSCoder) {

        if let userEmail = aDecoder.decodeObject(forKey: "user_email_id") as? String {
            self.userEmailId = userEmail
        }
        if let userId = aDecoder.decodeObject(forKey: "id") as? Int {
            self.id = userId
        }
        if let cooperateIndicator = aDecoder.decodeObject(forKey: "corporate_indicator") as? Bool {
            self.corporateIndicator = cooperateIndicator
        }

        if let accessTokenStr = aDecoder.decodeObject(forKey: "access_token") as? String {
            self.accessToken = accessTokenStr
        }

        if let firstNameStr = aDecoder.decodeObject(forKey: "first_name") as? String {
            self.firstName = firstNameStr
        }

        if let middleNameStr = aDecoder.decodeObject(forKey: "middle_name") as? String {
            self.middleName = middleNameStr
        }

        if let lastNameStr = aDecoder.decodeObject(forKey: "last_name") as? String {
            self.lastName = lastNameStr
        }
        if let aliasNameStr = aDecoder.decodeObject(forKey: "alias_name") as? String {
            self.aliasName = aliasNameStr
        }
        if let birthDateStr = aDecoder.decodeObject(forKey: "birth_date") as? String {
            self.birthDate = birthDateStr
        }
        if let companyNameStr = aDecoder.decodeObject(forKey: "company_name") as? String {
            self.companyName = companyNameStr
        }
        if let addressLine1Str = aDecoder.decodeObject(forKey: "address_line_1_text") as? String {
            self.addressLine1Text = addressLine1Str
        }
        if let addressLine2Str = aDecoder.decodeObject(forKey: "address_line_2_text") as? String {
            self.addressLine2Text = addressLine2Str
        }
        if let addressLine3Str = aDecoder.decodeObject(forKey: "address_line_3_text") as? String {
            self.addressLine3Text = addressLine3Str
        }
        if let addressCityName = aDecoder.decodeObject(forKey: "address_city_name") as? String {
            self.addressCityName = addressCityName
        }
        if let addressRegional = aDecoder.decodeObject(forKey: "address_regional_area_code") as? String {
            self.addressRegionalAreaCode = addressRegional
        }
        if let addressPostal = aDecoder.decodeObject(forKey: "address_postal_code") as? String {
            self.addressPostalCode = addressPostal
        }
        if let addressCountry = aDecoder.decodeObject(forKey: "address_country_code") as? String {
            self.addressCountryCode = addressCountry
        }
        if let mobilePhone = aDecoder.decodeObject(forKey: "mobile_phone_number") as? String {
            self.mobilePhoneNumber = mobilePhone
        }
        if let mainPhoneNumber = aDecoder.decodeObject(forKey: "main_phone_number") as? String {
            self.mainPhoneNumber = mainPhoneNumber
        }
        if let personalPhotoPath = aDecoder.decodeObject(forKey: "personal_photo_path_text") as? String {
            self.personalPhotoPathText = personalPhotoPath
        }
        if let govPhotoPath = aDecoder.decodeObject(forKey: "government_id_photo_path_text") as? String {
            self.governmentIdPhotoPathText = govPhotoPath
        }
        if let marketCommunicationIndicator = aDecoder.decodeObject(forKey: "marketing_communications_consent_indicator") as? Bool {
            self.marketingCommunicationsConsentIndicator = marketCommunicationIndicator
        }
        if let addressCountryName = aDecoder.decodeObject(forKey: "address_country_name") as? String {
            self.addressCountryName = addressCountryName
        }
        if let lastLoginStr = aDecoder.decodeObject(forKey: "last_login") as? String {
            self.lastLogin = lastLoginStr
        }
        if let userSinceDateStr = aDecoder.decodeObject(forKey: "user_since_date") as? String {
            self.userSinceDate = userSinceDateStr
        }

    }

    //    func encodeToJSON() -> [String : Any] {
    //        return self.toJSON()
    //    }
}
