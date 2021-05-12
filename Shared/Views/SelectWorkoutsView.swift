//
//  SelectWorkoutsView.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-10.
//

import SwiftUI

struct SelectWorkoutsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: CreateWorkoutViewModel
    
    @State private var selectedExercises: [Exercise] = []
    @State private var searchTerm = ""
    
    var filteredExercises: [Exercise] {
        CreateWorkoutViewModel.exerciseOptions.filter { exerciseOption in
            searchTerm.isEmpty ? true : exerciseOption.name.lowercased().contains(searchTerm.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                SearchBar(text: $searchTerm, placeholder: "Search exercise")
                
                ForEach(filteredExercises.indices, id: \.self) { index in
                    HStack {
                        Text(filteredExercises[index].name)
                        
                        Spacer()
                        
                        Image(systemName: selectedExercises.first(where: { option in
                            option.name == filteredExercises[index].name
                        }) != nil ? "checkmark.circle.fill" : "circle")
                        .font(.body.weight(.medium))
                    }
                    .padding()
                    .background(selectedExercises.first(where: { option in
                        option.name == filteredExercises[index].name
                    }) != nil ? Color.primaryButton : Color.primaryButton.opacity(0.2))
                    .onTapGesture {
                        if let index = selectedExercises.firstIndex(where: { option in
                            return option.name == filteredExercises[index].name
                        }) {
                            selectedExercises.remove(at: index)
                            return
                        }
                        
                        selectedExercises.append(filteredExercises[index])
                    }
                }
            }
            .navigationBarTitle(Text("Select exercises"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }).accentColor(.primary),
                trailing: Button(action: {
                    viewModel.exercises.append(contentsOf: selectedExercises.map({
                        CreateWorkoutViewModel.ExerciseViewModel.init(selectedOption: $0)
                    }))
                    
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Add")
                })
                .accentColor(.primary)
            )
        }
    }
}

struct SelectWorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CreateWorkoutViewModel()
        
        return SelectWorkoutsView()
            .environmentObject(viewModel)
    }
}
