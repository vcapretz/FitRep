//
//  RemindView.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-09.
//

import SwiftUI

struct RemindView: View {
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
//            DropdownView()
            
            Spacer()
            
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    
                    Text("Next")
                        .font(.system(size: 24, weight: .medium))
                        .padding()
                    
                    Spacer()
                }
            })
            .accentColor(.primary)
            
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    
                    Text("Skip")
                        .font(.system(size: 24, weight: .medium))
                        .padding()
                    
                    Spacer()
                }
            })
            .accentColor(.primary)
            .padding(.bottom)
        }
        .navigationBarTitle(Text("Remind"))
    }
}

struct RemindView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RemindView()
        }
    }
}
