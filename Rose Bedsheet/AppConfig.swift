//
//  AppConfig.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/10/25.
//

import Foundation
import Common
import netfox

struct AppConfig {
    static let shared = AppConfig()
    
    init() {
        NFX.sharedInstance().start()
    }
}
