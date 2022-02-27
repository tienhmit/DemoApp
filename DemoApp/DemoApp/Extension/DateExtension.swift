//
//  DateExtension.swift
//  WindyDemo2
//
//  Created by Đào Mỹ Đông on 25/02/2022.
//


import Foundation

extension Date {
    public static let gregorianCalendar = Calendar(identifier: .gregorian)
    
    func toString()-> String {
        //Thurday, Jan - 20th 2022
        return self.toStringWithFormat("hh:mm")
    }
    
    func toStringWithFormat(_ format: String)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        let locale = "en_us"
        formatter.locale = Locale(identifier: locale)
        return formatter.string(from: self).capitalized
    }
    
    func nextMonth()-> Date {
        let cal = Date.gregorianCalendar
        if let newDate = cal.date(byAdding: .month, value: 1, to: self) {
            return newDate
        }
        return self
    }
    
    func nextDay()-> Date {
        let cal = Date.gregorianCalendar
        if let newDate = cal.date(byAdding: .day, value: 1, to: self) {
            return newDate
        }
        return self
    }
    
    func previousMonth()-> Date {
        let cal = Date.gregorianCalendar
        if let newDate = cal.date(byAdding: .month, value: -1, to: self) {
            return newDate
        }
        return self
    }
    
    func previousYear()-> Date {
        let cal = Date.gregorianCalendar
        if let newDate = cal.date(byAdding: .year, value: -1, to: self) {
            return newDate
        }
        return self
    }
    
    func nextYear()-> Date {
        let cal = Date.gregorianCalendar
        if let newDate = cal.date(byAdding: .year, value: 1, to: self) {
            return newDate
        }
        return self
    }
    
    func getDay()-> String {
        return self.toStringWithFormat("dd")
    }
    
    func getMonth()-> String {
        return self.toStringWithFormat("MM")
    }
    
    func getYear()-> String {
        return self.toStringWithFormat("yyyy")
    }
    
    func getDayInWeek()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let locale = "en_us"
        dateFormatter.locale = Locale(identifier: locale)
        
        return dateFormatter.string(from: self).capitalized
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func isThisMonth()-> Bool {
        let date = Date()
        if self.getYear() == date.getYear(), self.getMonth() == date.getMonth() {
            return true
        }
        return false
    }
    
    var keyMonthYear: String {
        return "\(self.getMonth())-\(self.getYear())"
    }
    
    var keyDayMonthYear: String {
        return "\(self.getDay())-\(self.getMonth())-\(self.getYear())"
    }
    
    var isSunday: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let str = dateFormatter.string(from: self).uppercased()
        return str == "SUN"
    }
    
    var isInYesterday: Bool { Date.gregorianCalendar.isDateInYesterday(self) }
    var isInToday:     Bool { Date.gregorianCalendar.isDateInToday(self) }
    var isInTomorrow:  Bool { Date.gregorianCalendar.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
    
    func isEqual(to date: Date,
                 toGranularity component: Calendar.Component,
                 in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    func isInSameYear (date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameDay  (date: Date) -> Bool { isEqual(to: date, toGranularity: .day) }
    func isInSameWeek (date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    var isInThisYear:  Bool { isInSameYear(date: Date()) }
    var isInThisMonth: Bool { isInSameMonth(date: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(date: Date()) }
    
    static func getDate(_ day: Int, _ month: Int, _ year: Int)-> Date? {
        let str = "\(day)/\(month)/\(year)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        
        let locale = "en_us"
        dateFormatter.locale = Locale(identifier: locale) // set locale to reliable US_POSIX
        return dateFormatter.date(from: str)
    }
    
    static func getDateValue(_ day: Int, _ month: Int, _ year: Int)-> Date {
        let str = "\(day)/\(month)/\(year)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        
        let locale = "en_us"
        dateFormatter.locale = Locale(identifier: locale) // set locale to reliable US_POSIX
        return dateFormatter.date(from: str)!
    }
    
    var getSolarDay: Int {
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.day, from: self)
        return month
    }
    
    var getSolarMonth: Int {
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.month, from: self)
        return month
    }
    
    var getSolarYear: Int {
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.year, from: self)
        return month
    }
    
    var getHour: Int {
        let calendar = Date.gregorianCalendar
        let month = calendar.component(.hour, from: self)
        return month
    }
    
    var getMinute: Int {
        let calendar = Date.gregorianCalendar
        let month = calendar.component(.minute, from: self)
        return month
    }
    
    var startOfDay: Date {
        return Date.gregorianCalendar.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Date.gregorianCalendar.date(byAdding: components, to: startOfDay)!
    }
    
    func startOfMonth() -> Date {
        let cal = Date.gregorianCalendar
        let date = cal.date(from: cal.dateComponents([.year, .month], from: cal.startOfDay(for: self)))!
        return date.startOfDay
    }

    func endOfMonth() -> Date {
        let cal = Date.gregorianCalendar
        let date = cal.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
        return date.endOfDay
    }
    
    var startOfYear: Date {
        let cal = Date.gregorianCalendar
        if let firsDayOfYear = cal.date(from: DateComponents(year: self.getSolarYear, month: 1, day: 1)) {
            return firsDayOfYear.startOfDay
        }
        return self
    }
    
    var endOfYear: Date {
        let cal = Date.gregorianCalendar
        if let firstOfNextYear = cal.date(from: DateComponents(year: self.getSolarYear + 1, month: 1, day: 1)) {
            // Get the last day of the current year
            if let lastOfYear = cal.date(byAdding: .day, value: -1, to: firstOfNextYear) {
                return lastOfYear.endOfDay
            }
            return self
        }
        return self
    }
    
    var startOfQuater: Date {
        let solarMonth = self.getSolarMonth
        let solarYear = self.getSolarYear
        let map: [Int: Int] = [1:1, 2:1, 3:1,
                               4:4, 5:4, 6:4,
                               7:7, 8:7, 9:7,
                               10:10, 11:10, 12:10]
        let monthStartQuater = map[solarMonth]!
        let date = Date.getDate(1, monthStartQuater, solarYear)!
        return date.startOfMonth().startOfDay
    }
    
    var endOfQuater: Date {
        let solarMonth = self.getSolarMonth
        let solarYear = self.getSolarYear
        let map: [Int: Int] = [1:3, 2:3, 3:3,
                               4:6, 5:6, 6:6,
                               7:9, 8:9, 9:9,
                               10:12, 11:12, 12:12]
        let monthEndQuater = map[solarMonth]!
        let date = Date.getDate(1, monthEndQuater, solarYear)!
        return date.endOfMonth().endOfDay
    }
    
    var thisQuater: Date {
        return self.startOfQuater
    }
    
    var nextQuater: Date {
        let cal = Date.gregorianCalendar
        if let newDate = cal.date(byAdding: .month, value: 3, to: self) {
            return newDate.startOfQuater
        }
        return self
    }
    
    var prevQuater: Date {
        let cal = Date.gregorianCalendar
        if let newDate = cal.date(byAdding: .month, value: -3, to: self) {
            return newDate.startOfQuater
        }
        return self
    }
    
    func newMonthWithAdded(_ step: Int)-> Date {
        let cal = Date.gregorianCalendar
        if let newDate = cal.date(byAdding: .month, value: step, to: self) {
            return newDate
        }
        return self
    }
    
    func newYearWithAdded(_ step: Int)-> Date {
        let cal = Date.gregorianCalendar
        if let newDate = cal.date(byAdding: .year, value: step, to: self) {
            return newDate
        }
        return self
    }
}
