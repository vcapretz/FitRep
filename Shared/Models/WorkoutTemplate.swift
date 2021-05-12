//
//  WorkoutTemplate.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-10.
//

import Foundation

struct WorkoutTemplate: Codable, Hashable {
    let name: String
    let exercises: [Exercise]
    let userId: String
    let createdAt: Date
}
