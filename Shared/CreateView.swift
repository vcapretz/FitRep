//
//  CreateView.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-08.
//

import SwiftUI

struct CreateView: View {
    @StateObject var viewModel = CreateChallengeViewModel()
    
    var dropdownList: some View {
        ForEach(viewModel.dropdowns.indices, id: \.self) { index in
            DropdownView(viewModel: $viewModel.dropdowns[index])
        }
        .onMove(perform: { indices, newOffset in
            viewModel.send(action: .moveExercise(from: indices, to: newOffset))
        })
        .onDelete(perform: { indexSet in
            viewModel.send(action: .deleteExercise(at: indexSet))
        })
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
        VStack(alignment: .leading) {
            Text("Start by adding a few exercises")
                .padding(.leading, 20)
            
            List {
                dropdownList
            }
            .listStyle(PlainListStyle())
        
            Button(action: {
                viewModel.send(action: .createWorkout)
            }, label: {
                HStack {
                    Spacer()
                    
                    Text("Create")
                        .font(.system(size: 24, weight: .medium))
                        .padding()
                    
                    Spacer()
                }
            })
            .accentColor(.primary)
            .padding(.bottom)
            .disabled(viewModel.dropdowns.count < 1)
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
        .navigationBarItems(leading: EditButton().accentColor(.primary), trailing: Button(action: {
            viewModel.dropdowns.append(.init(type: .exercise))
            
            guard let lastDropdown = viewModel.dropdowns.indices.last else { return }
            viewModel.dropdowns[lastDropdown].isSelected = true
            
        }, label: {
            Text("Add")
        }).accentColor(.primary))
        .navigationBarBackButtonHidden(true)
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateView()
        }
    }
}
