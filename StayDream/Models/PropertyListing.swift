//
// PropertyListing.swift
//

import Foundation
import ObjectMapper

struct PropertyListing: Mappable {
/// PropertyListing properties
    /** building tag name */
    var next: String?
    /** building tag name */
    var previous: String?
    /** results of list */
    var results: [PropertyList]?

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        next <- map["next"]
        previous <- map["previous"]
        results <- map["results"]
    }

    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}
