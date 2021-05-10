//
//  WorkoutTemplate.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-10.
//

import Foundation

struct WorkoutTemplate: Codable {
    let exercises: [Exercise]
    let userId: String
}
