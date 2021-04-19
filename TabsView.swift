//
//  TabsView.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 19.04.2021.
//

import SwiftUI

struct TabsView: View {
    @Binding var screenIndex: Int
    var body: some View {
        
        HStack(spacing: 40) {
            Button(action: {
                self.screenIndex = 0
            }) {
                VStack {
                    Image(systemName: "cart")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("Shop")
                        .fontWeight(.bold)
                }
                .foregroundColor(screenIndex == 0 ? .black : .gray)
                
            }
            
            Divider()
            
            Button(action: {
                self.screenIndex = 1
            }) {
                VStack {
                    Image(systemName: "xserve")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("My farm")
                        .fontWeight(.bold)
                }
                .foregroundColor(screenIndex == 1 ? .black : .gray)
            }
            
            Button(action: {
                self.screenIndex = 2
            }) {
                VStack {
                    Image(systemName: "desktopcomputer")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("My PC")
                        .fontWeight(.bold)
                }
                .foregroundColor(screenIndex == 2 ? .black : .gray)
            }
            
            
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .foregroundColor(.black)
        .background(Color.white)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
