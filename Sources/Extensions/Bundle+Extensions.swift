//
//  Bundle+Extensions.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 23/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

extension Bundle {
    
    public static var urbitKitBundle: Bundle {
        return Bundle(identifier: "org.cocoapods.UrbitKit")!
    }
    
    public static var urbitKitResourceBundle: Bundle {
        return Bundle(url: urbitKitBundle.url(forResource: "UrbitKit", withExtension: "bundle")!)!
    }
    
}

extension Bundle {
    
    public var urbitExecutableURL: URL {
        return url(forResource: "king-darwin-dynamic-6f8a248d67fd3f0123d887c1f5838b84a201022f", withExtension: nil)!
    }
    
    public var urbitPillURL: URL {
        return url(forResource: "urbit-v0.10.1", withExtension: "pill")!
    }
    
}
