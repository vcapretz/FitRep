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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
    }
}
