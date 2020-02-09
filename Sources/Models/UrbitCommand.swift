//
//  UrbitProcessCommand.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 11/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

public class UrbitCommand {
    
    public let process: Process
    
    public required init(arguments: [String] = []) {
        self.process = Process(executableURL: Bundle.urbitKitResourceBundle.urbitExecutableURL, arguments: arguments)
    }
    
}

extension UrbitCommand {
    
    public static func help() -> Self {
        return Self.init(arguments: ["--help"])
    }
    
}

extension UrbitCommand {
    
    public var script: String? {
        guard let executableURL = process.executableURL, let arguments = process.arguments else {
            return nil
        }
        
        return "\(executableURL.path) \(arguments.joined(separator: " "))"
    }
    
}
