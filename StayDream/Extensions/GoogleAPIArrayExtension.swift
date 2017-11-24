//
//  GoogleAPIArrayExtension.swift
//  StayDream
//
//  Created by Sharisti on 03/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Array where Element: Mappable {

    init(json: Any?) {
        self.init()

        var result = [Element]()
        if let array = json as? [[String: Any]] {
            for item in array {
                if let profile = Element(JSON: item) {
                    result.append(profile)
                }
            }
        }
        self = result
    }
}
