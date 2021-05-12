//
//  QuerySnapshotPublisher.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-11.
//

import Combine
import Firebase

extension Publishers {
    struct QuerySnapshotPublisher: Publisher {
        typealias Output = QuerySnapshot
        typealias Failure = FitRepError
        
        private let query: Query
        
        init(query: Query) {
            self.query = query
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, FitRepError == S.Failure, QuerySnapshot == S.Input {
            let querySnapshotSubscription = QuerySnapshotSubscription(subscriber: subscriber, query: query)
            
            subscriber.receive(subscription: querySnapshotSubscription)
        }
    }
    
    class QuerySnapshotSubscription<S: Subscriber>: Subscription where S.Input == QuerySnapshot, S.Failure == FitRepError {
        private var subscriber: S?
        private var listener: ListenerRegistration?
        
        init(subscriber: S, query: Query) {
            listener = query.addSnapshotListener { querySnapshot, error in
                if let error = error {
                    subscriber.receive(completion: .failure(.default(description: error.localizedDescription)))
                    return
                }
                
                if let querySnapshot = querySnapshot {
                    _ = subscriber.receive(querySnapshot)
                    return
                }
                
                subscriber.receive(completion: .failure(.default()))
            }
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            listener = nil
        }
    }
}
