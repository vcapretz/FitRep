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
        VStack(spacing: 10) {
            HStack {
                Text(viewModel.headerTitle)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Button(action: {
                viewModel.isSelected = true
            }) {
                HStack {
                    Text(viewModel.dropdownTitle)
                    Spacer()
                    
                    Image(systemName: "arrowtriangle.down.circle")
                        .font(.system(size: 24, weight: .medium))
                }
                .font(.title)
            }
            .buttonStyle(PrimaryButtonStyle(fillColor: .primaryButton))
        }
        .padding(.horizontal)
    }
}

//struct DropdownView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            DropdownView()
//        }.environment(\.colorScheme, .dark)
//
//        NavigationView {
//            DropdownView()
//        }
//        .environment(\.colorScheme, .light)
//    }
//}

