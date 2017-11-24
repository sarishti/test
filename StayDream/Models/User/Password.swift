//
// Password.swift
//

import Foundation
import ObjectMapper

struct Password: Mappable {
/// Password properties
    /** Password of user. */
    var oldPassword: String?
    /** Password of user. */
    var newPassword: String?

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        oldPassword <- map["old_password"]
        newPassword <- map["new_password"]
    }

    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}
