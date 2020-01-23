//
//  Bundle+Extensions.swift
//  Urbit
//
//  Created by Daniel Clelland on 23/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

extension Bundle {
    
    public static var urbitClientBundle: Bundle {
        return Bundle(identifier: "org.cocoapods.UrbitClient")!
    }
    
    public static var urbitClientResourceBundle: Bundle {
        return Bundle(url: urbitClientBundle.url(forResource: "UrbitClient", withExtension: "bundle")!)!
    }
    
}

extension Bundle {
    
    public var urbitExecutableURL: URL {
        return url(forResource: "king-darwin-dynamic-06934959caa286c2778f034fca346a7b790c12e9", withExtension: nil)!
    }
    
    public var urbitPillURL: URL {
        return url(forResource: "urbit-v0.10.1", withExtension: "pill")!
    }
    
}
