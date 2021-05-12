//
//  DropdownViewProtocol.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-09.
//

import Foundation

protocol DropdownItemProtocol {
    var dropdownTitle: String { get }
    var selectedOption: Exercise { get set }
}

struct Exercise: Codable, Hashable {
    let name: String
}
