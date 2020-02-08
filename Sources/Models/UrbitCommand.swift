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

extension UrbitCommand {
    
//        let outputPipe = Pipe()
//        let errorPipe = Pipe()
        
//        process.standardOutput = outputPipe
//        process.standardError = errorPipe
//        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
//        errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
//        outputPipe.fileHandleForReading.readabilityHandler = { file in
//            let string = String(data: file.availableData, encoding: .utf8)!
//            print("output (readabilityHandler):", string)
//        }
//        errorPipe.fileHandleForReading.readabilityHandler = { file in
//            let string = String(data: file.availableData, encoding: .utf8)!
//            print("error (readabilityHandler):", string)
//        }

//        NotificationCenter.default.addObserver(forName: .NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading, queue: nil) { notification in
//            let string = String(data: outputPipe.fileHandleForReading.availableData, encoding: .utf8)!
//            print("OUTPUT:")
//            print(string)
//        }
//
//        NotificationCenter.default.addObserver(forName: .NSFileHandleDataAvailable, object: errorPipe.fileHandleForReading, queue: nil) { notification in
//            let string = String(data: errorPipe.fileHandleForReading.availableData, encoding: .utf8)!
//            print("ERROR:")
//            print(string)
//        }
        
//        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
    
}
