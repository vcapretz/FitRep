//
//  WorkoutService.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-10.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol WorkoutServiceProtocol {
    func createTemplate(_ template: WorkoutTemplate) -> AnyPublisher<Void, FitRepError>
}

final class WorkoutService: WorkoutServiceProtocol {
    private let db = Firestore.firestore()
    
    func createTemplate(_ template: WorkoutTemplate) -> AnyPublisher<Void, FitRepError> {
        return Future<Void, FitRepError> { promise in
            do {
                _ = try self.db.collection("templates").addDocument(from: template) { error in
                    if let error = error {
                        promise(.failure(.default(description: error.localizedDescription)))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(.default()))
            }
        }
        .eraseToAnyPublisher()
    }
}
