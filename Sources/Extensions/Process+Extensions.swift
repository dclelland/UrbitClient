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
    
    case standardOutput(_ message: String)
    case standardError(_ message: String)
    
}

public enum ProcessError: Error {
    
    case runFailure(_ error: Error)
    case nonzeroExitStatus(_ process: Process, terminationStatus: Int32)
    case uncaughtSignal(_ process: Process, terminationStatus: Int32)
    
}

private class ProcessSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == ProcessMessage, SubscriberType.Failure == ProcessError {
    
    private var subscriber: SubscriberType?
    
    private let process: Process
    
    init(subscriber: SubscriberType, process: Process) {
        self.subscriber = subscriber
        self.process = process
        self.process.standardOutputPipe = Pipe()
        self.process.standardOutputPipe?.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let string = String(data: handle.availableData, encoding: .utf8) else {
                return
            }
            _ = self?.subscriber?.receive(.standardOutput(string))
        }
        self.process.standardErrorPipe = Pipe()
        self.process.standardErrorPipe?.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let string = String(data: handle.availableData, encoding: .utf8) else {
                return
            }
            _ = self?.subscriber?.receive(.standardError(string))
        }
        self.process.terminationHandler = { [weak self] process in
            switch (process.terminationReason, process.terminationStatus) {
            case (.exit, 0):
                self?.subscriber?.receive(completion: .finished)
            case (.exit, let terminationStatus):
                self?.subscriber?.receive(completion: .failure(.nonzeroExitStatus(process, terminationStatus: terminationStatus)))
            case (.uncaughtSignal, let terminationStatus):
                self?.subscriber?.receive(completion: .failure(.uncaughtSignal(process, terminationStatus: terminationStatus)))
            default:
                fatalError()
            }
        }
        
        do {
            try self.process.run()
        } catch let error {
            self.subscriber?.receive(completion: .failure(.runFailure(error)))
        }
    }
    
    func request(_ demand: Subscribers.Demand) {
        // Do nothing
    }
    
    func cancel() {
        subscriber = nil
        process.terminate()
        process.terminationHandler = nil
    }
    
}

public class ProcessPublisher: Publisher {
    
    public typealias Output = ProcessMessage
    
    public typealias Failure = ProcessError
    
    private let process: Process
    
    public init(process: Process) {
        self.process = process
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, ProcessPublisher.Failure == S.Failure, ProcessPublisher.Output == S.Input {
        let subscription = ProcessSubscription(subscriber: subscriber, process: process)
        subscriber.receive(subscription: subscription)
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
    
    public func publisher() -> ProcessPublisher {
        return ProcessPublisher(process: self)
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
