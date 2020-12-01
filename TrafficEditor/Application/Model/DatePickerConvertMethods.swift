//
//  DatePickerConvertMethods.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 12/1/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import Foundation

class DatePickerConvertMethods {
    func stringToDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: string)!
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
