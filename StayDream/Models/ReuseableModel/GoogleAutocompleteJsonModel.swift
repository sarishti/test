//
//  GoogleAutocompleteJsonModel.swift
//  StayDream
//
//  Created by Sharisti on 03/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
import ObjectMapper

class GoogleAutocompleteJSONModel: Mappable, CustomStringConvertible {

    public fileprivate(set) var placeId: String?
    public fileprivate(set) var reference: String?
    public fileprivate(set) var title: String?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {

        title                       <- map["description"]
        placeId                     <- map["place_id"]
        reference                   <- map["reference"]
    }

    var description: String {
        return "\(toJSON())"
    }
}
