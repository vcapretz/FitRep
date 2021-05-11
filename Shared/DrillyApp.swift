//
//  DrillyApp.swift
//  Shared
//
//  Created by Vitor Capretz on 2021-05-08.
//

import SwiftUI
import Firebase

@main
struct DrillyApp: App {
    
    @StateObject private var appState = AppState()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                TabView {
                    Text("logged in")
                        .tabItem {
                            Image(systemName: "book")
                        }
                }
                .accentColor(.primary)
            } else {
                LandingView()
            }
        }
    }
}

class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        
        userService
            .observeAuthChanges()
            .map { $0 != nil }
            .assign(to: &$isLoggedIn)
    }
}
