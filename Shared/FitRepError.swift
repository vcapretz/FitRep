//
//  FitRepError.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-10.
//

import Foundation

enum FitRepError: LocalizedError {
    case auth(description: String)
    case `default`(description: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case let .auth(description):
            return description
        case let .default(description):
            return description ?? "Something went wrong"
        }
    }
}
