//
//  WorkoListView.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-11.
//

import SwiftUI

struct WorkoutListView: View {
    @StateObject private var viewModel = WorkoutListViewModel()
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let error = viewModel.error {
            VStack {
                Text(error.localizedDescription)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Button(action: {
                    viewModel.send(action: .retry)
                }, label: {
                    Text("Retry")
                        .padding()
                        .background(Rectangle().fill(Color.red).cornerRadius(5))
                })
                .padding()
                .accentColor(.primary)
            }
            .padding()
        } else {
            mainContentView
        }
    }
    
    var mainContentView: some View {
        ScrollView {
            ForEach(viewModel.itemViewModels, id: \.self) { itemViewModel in
                NavigationLink(
                    destination: Text("Destination")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(itemViewModel.name)
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Text(itemViewModel.exercises.map { $0.name }.joined(separator: ", "))
                                .lineLimit(1)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(Text(viewModel.title))
        .navigationBarItems(trailing: Button(action: {
            viewModel.send(action: .createRoutine)
        }, label: {
            Text("Add")
        }))
        .sheet(isPresented: $viewModel.showingCreateModal, content: {
            NavigationView {
                CreateView()
            }
        })
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView()
    }
}
