//
//  File.swift
//  
//
//  Created by Mindstix on 24/09/21.
//

import Foundation

struct commonStructExample {
    static func commonStructExampleFetchBuildVersion() -> String {
        if let buildversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return buildversion
        }
        return ""
    }
}
