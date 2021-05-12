//
//  UserService.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-10.
//

import Combine
import FirebaseAuth

protocol UserServiceProtocol {
    func currentUser() -> AnyPublisher<User?, Never>
    func signInAnonymously() -> AnyPublisher<User, FitRepError>
    func observeAuthChanges() -> AnyPublisher<User?, Never>
    func logout()
}

final class UserService: UserServiceProtocol {
    func currentUser() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser)
            .eraseToAnyPublisher()
    }
    
    func signInAnonymously() -> AnyPublisher<User, FitRepError> {
        return Future<User, FitRepError> { promise in
            Auth.auth().signInAnonymously { result, error in
                if let error = error {
                    return promise(.failure(.auth(description: error.localizedDescription)))
                }
                
                if let user = result?.user {
                    return promise(.success(user))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func observeAuthChanges() -> AnyPublisher<User?, Never> {
        Publishers.AuthPublisher().eraseToAnyPublisher()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
}
