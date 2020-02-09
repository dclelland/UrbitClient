//
//  Pipe+Extensions.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 9/02/20.
//

import Foundation
import Combine

@available(OSX 10.15, *) private class PipeSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == String {
    
    private var subscriber: SubscriberType?
    
    private let pipe: Pipe
    
    init(subscriber: SubscriberType, pipe: Pipe) {
        self.subscriber = subscriber
        self.pipe = pipe
        self.pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let string = String(data: handle.availableData, encoding: .utf8) else {
                return
            }
            
            _ = self?.subscriber?.receive(string)
        }
    }
    
    func request(_ demand: Subscribers.Demand) {
        // Do nothing
    }
    
    func cancel() {
        subscriber = nil
        pipe.fileHandleForReading.readabilityHandler = nil
    }

}

@available(OSX 10.15, *) private class PipePublisher: Publisher {
    
    typealias Output = String
    
    typealias Failure = Never
    
    private let pipe: Pipe
    
    init(pipe: Pipe) {
        self.pipe = pipe
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, PipePublisher.Failure == S.Failure, PipePublisher.Output == S.Input {
        let subscription = PipeSubscription(subscriber: subscriber, pipe: pipe)
        subscriber.receive(subscription: subscription)
    }

}

@available(OSX 10.15, *) extension Pipe {
    
    public func publisher() -> AnyPublisher<String, Never> {
        return PipePublisher(pipe: self).eraseToAnyPublisher()
    }
    
}
