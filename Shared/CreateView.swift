//
//  CreateView.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-08.
//

import SwiftUI

struct CreateView: View {
    @StateObject var viewModel = CreateChallengeViewModel()
    
    @State private var isActive = false
    
    var dropdownList: some View {
        ForEach(viewModel.dropdowns.indices, id: \.self) { index in
            DropdownView(viewModel: $viewModel.dropdowns[index])
        }
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(
            title: Text("Select"),
            buttons: viewModel.displayedOptions.indices.map({ index in
                let option = viewModel.displayedOptions[index]
                
                return .default(Text(option.formatted)) {
                    viewModel.send(action: .selectOption(index: index))
                }
            })
        )
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 15) {
                    dropdownList
                }
            }
            
            NavigationLink(
                destination: RemindView(), isActive: $isActive) {
                Button(action: {
                    isActive = true
                }, label: {
                    HStack {
                        Spacer()
                        
                        Text("Next")
                            .font(.system(size: 24, weight: .medium))
                            .padding()
                        
                        Spacer()
                    }
                })
                .accentColor(.primary)
                .padding(.bottom)
            }
        }
        .actionSheet(isPresented: Binding<Bool>(
                        get: {
                            viewModel.hasSelectedDropdown
                        },
                        set: { _ in })
        ) {
            actionSheet
        }
        .navigationBarTitle(Text("New workout"))
        .navigationBarBackButtonHidden(true)
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
