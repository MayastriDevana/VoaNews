//
//  String+ExtDate.swift
//  VoaNews
//
//  Created by User on 23/04/24.
//

import Foundation

extension String{
    // case "19 menit yang lalu" -> relativeToCurrentDate
    func relativeToCurrentDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        //butuh string dari Date
        guard let date = dateFormatter.date(from: self) else {
            return""
        }
        
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute], from: date, to: now)
        
        //Logic 19 menit yang lalu
        if let year = components.year, year > 0 {
            return "\(year) tahun yang lalu"
        } else if let month = components.month, month > 0 {
            return "\(month) bulan yang lalu"
        } else if let week = components.weekOfMonth, week > 0 {
            return "\(week) minggu yang lalu"
        } else if let day = components.day, day > 0 {
            return "\(day) hari yang lalu"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) jam yang lalu"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) menit yang lalu"
        } else {
            return "Baru saja"
        }
    }
}
