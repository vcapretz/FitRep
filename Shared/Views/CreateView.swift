//
//  CreateView.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-08.
//

import SwiftUI

struct CreateView: View {
    @StateObject var viewModel = CreateWorkoutViewModel()
    @State private var isAdding = false
    
    var dropdownList: some View {
        ForEach(viewModel.exercises.indices, id: \.self) { index in
            Text(viewModel.exercises[index].dropdownTitle)
                .fontWeight(.medium)
        }
        .onMove(perform: { indices, newOffset in
            viewModel.send(action: .moveExercise(from: indices, to: newOffset))
        })
        .onDelete(perform: { indexSet in
            viewModel.send(action: .deleteExercise(at: indexSet))
        })
    }
    
    var mainContentView: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Exercises")) {
                    List {
                        dropdownList
                    }
                    .padding(.vertical)
                }
                
                Section {
                    TextField("Routine name", text: $viewModel.newWorkoutRoutine)
                }
            }
            Button(action: {
                viewModel.send(action: .createWorkout)
            }, label: {
                HStack {
                    Spacer()
                    
                    Text("Create routine")
                        .font(.system(size: 24, weight: .medium))
                        .padding()
                    
                    Spacer()
                }
            })
            .accentColor(viewModel.exercises.count < 1 ? .secondary : .primary)
            .padding(.bottom)
            .disabled(viewModel.exercises.count < 1)
        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.exercises.isEmpty {
                VStack(alignment: .leading) {
                    Text("Start by adding some exercises in one of your routines.")
                        .font(.title3)
                        .padding(.bottom)
                    
                    Text("Tip: Don't skip leg days!")
                        .font(.footnote)
                        .fontWeight(.medium)
                    
                    Spacer()
                }
                .padding(.vertical)
            } else {
                mainContentView
            }
        }
        .alert(isPresented: Binding<Bool>.constant($viewModel.error.wrappedValue != nil)) {
            Alert(title: Text("Error"), message: Text($viewModel.error.wrappedValue?.localizedDescription ?? ""), dismissButton: .default(Text("Ok"), action: {
                viewModel.error = nil
            }))
        }
        .sheet(isPresented: $isAdding, content: {
            SelectWorkoutsView()
                .environmentObject(viewModel)
        })
        .navigationBarTitle(Text("Workout routine"))
        .navigationBarItems(leading: EditButton().accentColor(.primary), trailing: Button(action: {
            isAdding = true
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
