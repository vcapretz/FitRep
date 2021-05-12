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
    func observeTemplates(userId: UserId) -> AnyPublisher<[WorkoutTemplate], FitRepError>
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
    
    func observeTemplates(userId: UserId) -> AnyPublisher<[WorkoutTemplate], FitRepError> {
        let query = db.collection("templates").whereField("userId", isEqualTo: userId)
        
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[WorkoutTemplate], FitRepError> in
                do {
                    let templates = try snapshot.documents.compactMap {
                        try $0.data(as: WorkoutTemplate.self)
                    }
                    
                    return Just(templates)
                        .setFailureType(to: FitRepError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
