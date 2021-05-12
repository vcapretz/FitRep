//
//  ContentView.swift
//  Shared
//
//  Created by Vitor Capretz on 2021-05-08.
//

import SwiftUI

struct LandingView: View {
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Get stronger")
                    .font(.system(size: 64, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                Spacer()
                
                NavigationLink(
                    destination: CreateView(), isActive: $isActive) {
                    Button(action: {
                        isActive = true
                    }, label: {
                        HStack(spacing: 15) {
                            Spacer()
                            
                            Image(systemName: "plus.circle")
                            
                            Text("Start now")
                            
                            Spacer()
                        }
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                    })
                    .buttonStyle(PrimaryButtonStyle())
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .overlay(Color.black.opacity(0.5))
                    .frame(minWidth: 10) // ??? weird bug, remove for a surprise
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .accentColor(.primary)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
