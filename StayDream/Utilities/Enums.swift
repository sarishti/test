//
//  Enums.swift
//  DITY
//

import Foundation
struct Enums {

    // user type On basis of logged in
    enum LanguageType: Int {
        case english = 0
        case franch = 1
        case spanish = 2
        case chines = 3
    }
    // LANGUAGE CODE
    enum LanguageCode: String {
        case english = "en"
        case franch = "fr"
        case spanish = "es"
        case chines = "zh"
    }
    // view code
    enum ViewTypeCode: String {
        case c = "City View"
        case l = "Lake View"
        case m = "Mountain View"
        case o = "Ocean View"
        case p = "Park View"
    }
    // property code
    enum PropertyTypeCode: String {
        case c = "Condo"
        case f = "Freehold Town"
        case h = "House"
        case s = "Semi detached"
        case t = "Condo town"
    }
    enum TermsPage: String {
        case booking = "booking"
        case memeber = "member"
    }

}
