//
//  DropdownView.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-08.
//

import SwiftUI

struct DropdownView<T: DropdownItemProtocol>: View {
    @Binding var viewModel: T
    
    var body: some View {
        Button(action: { }) {
            HStack {
                Text(viewModel.dropdownTitle)
                    .font(.title2)
                
                Spacer()
            }
        }
        .buttonStyle(PrimaryButtonStyle(fillColor: .primaryButton))
    }
}

struct DropdownView_Previews: PreviewProvider {
    @State static var viewModel = CreateWorkoutViewModel()
    
    static var previews: some View {
        NavigationView {
            DropdownView(viewModel: $viewModel.exercises[0])
        }.environment(\.colorScheme, .dark)
        
        NavigationView {
            DropdownView(viewModel: $viewModel.exercises[0])
        }
        .environment(\.colorScheme, .light)
    }
}

