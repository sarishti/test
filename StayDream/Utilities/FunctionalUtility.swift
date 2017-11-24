//
//  FunctionalUtility.swift
//  StayDream
//
//  Created by Sharisti on 01/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
import MBProgressHUD

struct FunctionalUtility {

    // To display the view type on serach screen
    static func viewTypeCodeString (code: String) -> String {
        switch code.lowercased() {
        case "c" :
            return Enums.ViewTypeCode.c.rawValue
        case "l" :
            return Enums.ViewTypeCode.l.rawValue
        case "m" :
            return Enums.ViewTypeCode.m.rawValue
        case "o" :
            return Enums.ViewTypeCode.o.rawValue
        case "p" :
            return Enums.ViewTypeCode.p.rawValue
        default:
            return Enums.ViewTypeCode.c.rawValue
        }
    }

}
