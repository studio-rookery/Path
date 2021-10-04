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
public extension FilePathObserver {
    
    struct Publisher: Combine.Publisher {
        
        public typealias Output = FilePath
        public typealias Failure = Never
        
        private let pathObserver: FilePathObserver

        public init(pathObserver: FilePathObserver) {
            self.pathObserver = pathObserver
        }
        
        public init(path: FilePath) {
            self.pathObserver = FilePathObserver(for: path)
        }
        
        public func receive<S>(subscriber: S) where S : Combine.Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = Subscription(pathObserver: pathObserver)
            subscriber.receive(subscription: subscription)
        }
    }
}

@available(iOS 13.0, *)
@available(OSX 10.15, *)
private extension FilePathObserver  {
    
    final class Subscription: Combine.Subscription {
        
        private let pathObserver: FilePathObserver

        init(pathObserver: FilePathObserver) {
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
