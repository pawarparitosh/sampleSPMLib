//
//  Utils.swift
//  Native-iOS-Baselione
//
//  Created by Mindstix on 26/07/21.
//

import Foundation
import SwiftUI
import UIKit

public class CommonUtils {
    
    static let hapticFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    //MARK:- UserDefaults
    
    static func saveToUserDefaults(key : String, val : Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(val, forKeyPath: key)
    }
    
    
    static func getStringFromUserDefaults(key : String) -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: key)
    }
    
    
    static func getBoolFromUserDefaults(key : String) -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: key)
    }
    
    public func fetchBuildVersion() -> String {
        if let buildversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return buildversion
        }
        return ""
    }
    
   public static func getAppBuildNo() -> String? {
        guard let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return nil
        }
        return build
    }
    
    static func getURLFromString(urlString : String) -> String {
        return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    //MARK:- UI Alert Pop up
    /// action determines if the OK button is visible
    static func showOKAlertPopUp(title : String, message : String, action : Bool, controller : UIViewController, completion : @escaping () -> Void ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if action {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        }
        DispatchQueue.main.async {
            controller.present(alert, animated: true, completion: completion)
        }
    }
    
    ///Returns Default Alert with 1 Button
    static func showDefaultAlert(title : String, message : String, OKButtonText : String) -> Alert {
        
        return Alert(title: Text(title), message: Text(message), dismissButton: .default(Text(OKButtonText)))
    }
    
    ///Returns Default Alert with 2 Buttons and actions closure
    static func showDefaultAlert(title : String, message : String, primaryButtonText : String, secondaryButtonText : String, primaryButtonAction: @escaping () -> Void, secondaryButtonAction : @escaping () -> Void) -> Alert {
        
        return Alert(title: Text(title), message: Text(message), primaryButton: .default(Text(primaryButtonText), action: primaryButtonAction), secondaryButton: .default(Text(secondaryButtonText), action: secondaryButtonAction))
    }
    
    
    //MARK:- Date & Time
    /// Get greeting for the current time
    /// - Returns: String > Good morning if its day and so on
    static func getGreetingForCurrentTime() -> String {
        
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12 : return "good_morning"
        case 12..<17 : return "good_afternoon"
        default:
            return "good_evening"
        }
    }
    
    /// Gets the Date formatted string from provided UTC string and mentioned UTC format
    static func getDateTimeFromUTC(utcDateString : String, utcDateFormat : DateType = .UTCFormat, expectedOutputDateFormat : DateType ) -> String {
        
        // get the date format and convert it into UTC
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = utcDateFormat.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: utcDateString) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = expectedOutputDateFormat.rawValue
            
            let dateString = dateFormatter.string(from: date)
            return dateString.replacingOccurrences(of: "suffix", with: date.daySuffix())
            //return dateString
        }
        return "NO_DATE"
    }
    
    /// Returns the Difference in days string based on inFuture Value. If in future > 2 days ago. Else 2 days ago
    static func getDifferenceInDaysText(numberofDaysString: String, inFuture: Bool ) -> String {
        
        // Remove the negative sign if difference is -ve
        let noOfDaysString = numberofDaysString.replacingOccurrences(of: "-", with: "")
        
        switch noOfDaysString {
        
        case "0" :
            return "today"
        case "1":
            return  "1 " + (inFuture ? "day_to_go" : "day_ago")
        default:
            return  "\(noOfDaysString) " + (inFuture ? "days_to_go" : "days_ago")
        }
    }
    
    /// gets the date object from the provided utc string
    static func getDateObject(utcDateString : String, dateFormat : DateType = .UTCFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: utcDateString) {
            return date
        }
        return nil
    }
    
    //    static func getDateFormatFromDate(date: Date, dateFormat: DateType) {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = dateFormat.rawValue
    //        return date.getFormattedDate()
    //
    //    }
    
    // Fetch Dictionary from Json files
    static func fetchDataFromLocalJson(name : String)-> NSDictionary? {
        
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return (jsonResult as! NSDictionary)
            } catch {
                // handle error
            }
        }
        return nil
    }
    
    static func openInSafari(url : String) {
        if let urlString = URL(string: url) {
            UIApplication.shared.open(urlString)
        }
    }
    
    static func openMail(emailId: String) {
        let mailURL = URL(string: "mailto:\(emailId)")!
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
        }
    }
    
    static func openPhone(phoneString : String) {
        let numberString = phoneString.replacingOccurrences(of: " ", with: "")
        guard let url = URL(string: "telprompt://\(numberString)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func getSecKeyFromString(keyBase64 : String) -> SecKey {
        // Sample KeyBase64
        //    let keyBase64 = "MIIEpAIBAAKCAQEA5B7lqLrwVCFNUiCmwMr5Q48iuArOolxb7DAuclGnoZVX0SaJ8mrvCOtd6qY/VeBw227txWEPH7840qX/yGxxqTngdNCuDATqYrrbxFOGV30GZmg6NpZYKShTlsftkhiCsoXW0A7m5MCZUkH2/sNBC8oRHCNDXRlsU5bq/yPaAMt6xlBsUgLt/++INcuw+rx1Rm7LJv0FeukQmlekUOL/DMJXcLXCa05StTbvHPiAHOLej07pThCZoX3XHFpOTQ6379EsjvSZHtNhr67qrtRb8or2rX7wt5NWzXHbhUDlyzEcIBB/7G8ygqWhyZTEIMFiRMWSa3KGYZE3nZe5weC7SQIDAQABAoIBAQCjjxehA+++kmYK5YhKIP3Zl64QAQeo18m8rcsPgkZLj3V4a0Zq/orGfWNIE8zDePnSC1YFuBKM86D9P7IGdOKFsA6kEt9HlNqs0UczG6Pt5KGLGV3rt54cXGKacFyA7HwBHf8oDBc2mnUTymIaxcpEdqwP3aS2Ar1trX5uUrlC6UcZyspBZVYvMlU+uAKL1ZtFxjsv0EzuQQW1HX7b2WPUAoxp/yBC/EBRM9K8WbG9i7NB4FTFHAdTMt/EZLGUESizFgrai6lp3s96Apz5GvncRUI+UVP/7zbUaFYdRMW5lrcR8+PL9NACkL2rnQuLoyLKWZWPPlD3WEE9EzY4bH6FAoGBAPu8hL8goEbWMFDZuox04Ouy6EpXR8BDTq8ut6hmad6wpFgZD15Xu7pYEbbsPntdYODKDDAIJCBsiBgf2emL50BpiQkzMPhxyMsN5Pzry9Ys+AzPkJcQ7g+/Wbto9lCC+JmgxtGQ7JIibo1QH7BTsuK9+k72HnZne6oIfaYKbBZfAoGBAOf7/D2Q7NiNcEgxpZRn06+mnkHMb8PfCKfJf/BFf5WKXSkDBZ3XhWSPnZyQnE3gW3lzJjzUwHS+YDk8A0Xl2piAHa/d5O/8eoijB8wa6UGVDBIXqUnfM3Udfry78rM71FOpbzV3H48G7u4CUJMGwOpEqF0TfgtQr4uf8OurdH9XAoGAbdNhVsE1K7Jmgd97s6uKNUpobYaGlyrGOUd4eM+1gKIwEP9d5RsBm9qwX83RtKCYk3mSt6HVoQ+4kE3VFD8lNMTWNF1REBMUNwJo1K9KzrXvwicMPdv1AInK7ChuzdFWBDBQjT1c+KRs9tnt+U+Ky8F2Ytydjaq4GQZ7SuVhIqECgYBMsS+IovrJ9KhkFZWp5FFFRo4XLqDcXkWcQq87HZ66L03xGwCmV/PPdPMkKWKjFELpebnwbl1Zuv5QrZhfaUfFFsW5uF/RPuS7ezo+rb7jYYTmDlB3DYUTeLbHalMoEeV16xPK1yDlxeMDaFx+3sK0MBKBAsqurvP58txQ7RPMbQKBgQCzRcURopG0DF4VF4+xQJS8FpTcnQsQnO/2MJR35npA2iUb+ffs+0lgEdeWs4W46kvaF1iVEPbr6She+aKROzE9Bs25ZCgGLv97oUxDQo0IPvURX7ucN+xOUU1hw9oQDVdGKl1JZh93fn+bjtMTe+26asGLmM0r9YQX1P8qaw3KOg=="
        
        let keyData = Data(base64Encoded: keyBase64)!
        let key = SecKeyCreateWithData(keyData as NSData, [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
        ] as NSDictionary, nil)!
        
        return key
    }
}



enum DateType : String {
    case UTCFormat = "yyyy-MM-dd'T'HH:mm:ss"
    case RegularDateNoSuffix = "dd MMM yyyy"
    case RegularDate = "dd'suffix' MMM yyyy"
    case RegularDateDay = "dd'suffix' MMM yyyy, EEE"
    case Time = "KK:mm a"
    case UTCFormat_Space = "yyyy-MM-dd HH:mm:ss"
}

extension Date {

    func dateFormatWithSuffix() -> String {
        return "dd'\(self.daySuffix())' MMMM yyyy"
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}
