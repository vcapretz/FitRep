//
//  TemplateItemViewModel.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-11.
//

import Foundation

struct TemplateItemViewModel: Hashable {
    private let template: WorkoutTemplate
    
    var exercises: [Exercise] {
        template.exercises
    }
    
    var name: String {
        template.name
    }
    
    init(template: WorkoutTemplate) {
        self.template = template
    }
}
