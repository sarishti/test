//
// StaticPage.swift
//

import Foundation
import ObjectMapper

struct StaticPage: Mappable {
/// StaticPage properties
    /** name of page */
    var name: String?
    /** content of page */
    var content: String?

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        content <- map["content"]
    }

    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}
