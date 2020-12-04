//
//  File.swift
//  
//
//  Created by masaki on 2020/12/02.
//

#if canImport(Combine)

import Foundation
import Combine

@available(iOS 13.0, *)
@available(OSX 10.15, *)
public extension PathObserver {
    
    struct Publisher: Combine.Publisher {
        
        public typealias Output = Path
        public typealias Failure = Never
        
        private let pathObserver: PathObserver

        public init(pathObserver: PathObserver) {
            self.pathObserver = pathObserver
        }
        
        public init(path: Path) {
            self.pathObserver = PathObserver(for: path)
        }
        
        public func receive<S>(subscriber: S) where S : Combine.Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = Subscription(pathObserver: pathObserver)
            subscriber.receive(subscription: subscription)
        }
    }
}

@available(iOS 13.0, *)
@available(OSX 10.15, *)
private extension PathObserver  {
    
    final class Subscription: Combine.Subscription {
        
        private let pathObserver: PathObserver

        init(pathObserver: PathObserver) {
            self.pathObserver = pathObserver
        }

        func request(_ demand: Subscribers.Demand) {
            
        }
            
        func cancel() {
            pathObserver.stop()
        }
    }
}
#endif
