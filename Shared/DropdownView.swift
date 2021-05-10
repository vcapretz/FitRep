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
        Button(action: {
            viewModel.isSelected = true
        }) {
            HStack {
                Text(viewModel.dropdownTitle)
                
                Spacer()
                
                Image(systemName: "arrowtriangle.down.circle")
                    .font(.title2.weight(.medium))
            }
            .font(.title2)
        }
        .buttonStyle(PrimaryButtonStyle(fillColor: .primaryButton))
    }
}

struct DropdownView_Previews: PreviewProvider {
    @State static var viewModel = CreateChallengeViewModel()
    
    static var previews: some View {
        NavigationView {
            DropdownView(viewModel: $viewModel.dropdowns[0])
        }.environment(\.colorScheme, .dark)
        
        NavigationView {
            DropdownView(viewModel: $viewModel.dropdowns[0])
        }
        .environment(\.colorScheme, .light)
    }
}

