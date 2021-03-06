//
//  Process+Extensions.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 16/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Combine

public enum ProcessMessage {
    
    case standardOutput(_ data: Data)
    case standardError(_ data: Data)
    
}

public enum ProcessError: LocalizedError {
    
    case run(_ error: Error)
    case exit(_ process: Process, terminationStatus: Int32)
    case uncaughtSignal(_ process: Process, terminationStatus: Int32)
    
    public var errorDescription: String? {
        switch self {
        case .run(let error):
            return error.localizedDescription
        case .exit(_, let terminationStatus):
            return "Exit: Process terminated with status \(terminationStatus)"
        case .uncaughtSignal(_, let terminationStatus):
            return "Uncaught signal: Process terminated with status \(terminationStatus)"
        }
    }
    
}

extension Process {
    
    convenience init(executableURL: URL, arguments: [String] = []) {
        self.init()
        self.executableURL = executableURL
        self.arguments = arguments
    }
    
}

extension Process {
    
    fileprivate var standardInputPipe: Pipe? {
        get {
            return standardInput as? Pipe
        }
        set {
            standardInput = newValue
        }
    }
    
    fileprivate var standardOutputPipe: Pipe? {
        get {
            return standardOutput as? Pipe
        }
        set {
            standardOutput = newValue
        }
    }
    
    fileprivate var standardErrorPipe: Pipe? {
        get {
            return standardError as? Pipe
        }
        set {
            standardError = newValue
        }
    }
    
}

extension Process {
    
    public func publisher() -> AnyPublisher<ProcessMessage, ProcessError> {
        return ProcessPublisher(process: self).eraseToAnyPublisher()
    }
    
}

private class ProcessPublisher: Publisher {
    
    typealias Output = ProcessMessage
    
    typealias Failure = ProcessError
    
    private let process: Process
    
    init(process: Process) {
        self.process = process
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, ProcessPublisher.Failure == S.Failure, ProcessPublisher.Output == S.Input {
        let subscription = ProcessSubscription(subscriber: subscriber, process: process)
        subscriber.receive(subscription: subscription)
    }
    
}

private class ProcessSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == ProcessMessage, SubscriberType.Failure == ProcessError {
    
    private var subscriber: SubscriberType?
    
    private let process: Process
    
    init(subscriber: SubscriberType, process: Process) {
        self.subscriber = subscriber
        self.process = process
        self.process.standardOutputPipe = Pipe()
        self.process.standardOutputPipe?.fileHandleForReading.readabilityHandler = { [weak self] handle in
            _ = self?.subscriber?.receive(.standardOutput(handle.availableData))
        }
        self.process.standardErrorPipe = Pipe()
        self.process.standardErrorPipe?.fileHandleForReading.readabilityHandler = { [weak self] handle in
            _ = self?.subscriber?.receive(.standardError(handle.availableData))
        }
        self.process.terminationHandler = { [weak self] process in
            switch (process.terminationReason, process.terminationStatus) {
            case (.exit, 0):
                self?.subscriber?.receive(completion: .finished)
            case (.exit, let terminationStatus):
                self?.subscriber?.receive(completion: .failure(.exit(process, terminationStatus: terminationStatus)))
            case (.uncaughtSignal, let terminationStatus):
                self?.subscriber?.receive(completion: .failure(.uncaughtSignal(process, terminationStatus: terminationStatus)))
            default:
                fatalError()
            }
        }
        
        do {
            try self.process.run()
        } catch let error {
            self.subscriber?.receive(completion: .failure(.run(error)))
        }
    }
    
    func request(_ demand: Subscribers.Demand) {
        // Do nothing
    }
    
    func cancel() {
        process.terminate()
        subscriber = nil
    }
    
}
