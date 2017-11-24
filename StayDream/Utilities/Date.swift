//
//  Date.swift
//  StayDream
//
//  Created by Sharisti on 06/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
struct DateUtility {

    // MARK: Date time calculation
    static func calculateDateTime(_ dateStr: String) -> Date {
        // Convert string to date object
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        let date = dateFormat.date(from: dateStr)
        return date!

    }

    static func getDateStr(from date: Date) -> Date? {
        let dateFormatter = DateFormatter()
        //dateFormatCalender
        dateFormatter.dateFormat = AppConstants.dateFormatServer
        let strDate = dateFormatter.string(from: date)
        //dateFormatter.dateFormat = "yyyy/MM/dd"
        return  dateFormatter.date(from: strDate)
    }

    static func getStrDate(from date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: date)
        //dateFormatter.dateFormat = "yyyy/MM/dd"
        return  strDate
    }
}
