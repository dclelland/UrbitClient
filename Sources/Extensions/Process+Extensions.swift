//
//  Process+Extensions.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 16/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

extension Process {
    
    convenience init(executableURL: URL, arguments: [String] = []) {
        self.init()
        self.executableURL = executableURL
        self.arguments = arguments
    }
    
}

extension Process {
    
    public var standardInputPipe: Pipe? {
        get {
            return standardInput as? Pipe
        }
        set {
            standardInput = newValue
        }
    }
    
    public var standardOutputPipe: Pipe? {
        get {
            return standardOutput as? Pipe
        }
        set {
            standardOutput = newValue
        }
    }
    
    public var standardErrorPipe: Pipe? {
        get {
            return standardError as? Pipe
        }
        set {
            standardError = newValue
        }
    }
    
}

extension Process {
    
    public enum ProcessError: Error {
        case runFailure(_ error: Error)
        case nonzeroExitStatus(_ process: Process, terminationStatus: Int32)
        case uncaughtSignal(_ process: Process, terminationStatus: Int32)
    }
    
    public func run(completion: @escaping (Result<Process, ProcessError>) -> Void) {
        terminationHandler = { process in
            switch (process.terminationReason, process.terminationStatus) {
            case (.exit, 0):
                completion(.success(process))
            case (.exit, let terminationStatus):
                completion(.failure(.nonzeroExitStatus(process, terminationStatus: terminationStatus)))
            case (.uncaughtSignal, let terminationStatus):
                completion(.failure(.uncaughtSignal(process, terminationStatus: terminationStatus)))
            default:
                fatalError()
            }
        }
        
        do {
            try run()
        } catch let error {
            completion(.failure(.runFailure(error)))
        }
    }
    
}
