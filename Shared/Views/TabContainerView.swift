//
//  TabContainerView.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-11.
//

import SwiftUI

struct TabContainerView: View {
    @StateObject private var tabContainerViewModel = TabContainerViewModel()
    
    var body: some View {
        TabView(selection: $tabContainerViewModel.selectedTab) {
            ForEach(tabContainerViewModel.tabItemViewModels, id: \.self) { viewModel in
                tabView(for: viewModel.type)
                    .tabItem {
                        Image(systemName: viewModel.imageName)
                        
                        Text(viewModel.title)
                    }
                    .tag(viewModel.type)
            }
        }
        .accentColor(.primary)
    }
    
    @ViewBuilder
    func tabView(for tabItemType: TabItemViewModel.TabItemType) -> some View {
        switch tabItemType {
        case .log:
            Text("Log")
        case .workoutList:
            NavigationView {
                WorkoutListView()
            }
        case .settings:
            Text("Settings")
        }
    }
}

final class TabContainerViewModel: ObservableObject {
    @Published var selectedTab: TabItemViewModel.TabItemType = .workoutList
    
    let tabItemViewModels: [TabItemViewModel] = [
        .init(imageName: "book", title: "Log", type: .log),
        .init(imageName: "list.bullet", title: "Routines", type: .workoutList),
        .init(imageName: "gear", title: "Settings", type: .settings)
    ]
}

struct TabItemViewModel: Hashable {
    let imageName: String
    let title: String
    let type: TabItemType
    
    enum TabItemType {
        case log
        case workoutList
        case settings
    }
}

struct TabContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TabContainerView()
    }
}
