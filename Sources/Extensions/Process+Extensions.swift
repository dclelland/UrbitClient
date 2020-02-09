//
//  Process+Extensions.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 16/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Combine

extension Process {
    
    convenience init(executableURL: URL, arguments: [String] = []) {
        self.init()
        self.executableURL = executableURL
        self.arguments = arguments
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

#warning("TODO: Merge message publisher with completion publisher; find way to publish termination status/reason (or just publish the process at each stage...?)")

//extension Process {
//    
//    public func publisher() -> AnyPublisher<Process, ProcessError> {
//        return Future<Process, ProcessError> { promise in
//            self.run { result in
//                promise(result)
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//}

extension Process {
    
    public enum Message {
        
        case standardOutput(String)
        case standardError(String)
        
    }
    
    public func publisher(standardOutput: Pipe = Pipe(), standardError: Pipe = Pipe()) -> AnyPublisher<Message, Never> {
        self.standardOutput = standardOutput
        self.standardError = standardError
        
        return Publishers.Merge(
            standardOutput.publisher().map { string in
                return .standardOutput(string)
            },
            standardError.publisher().map { string in
                return .standardError(string)
            }
        ).eraseToAnyPublisher()
    }
    
}
