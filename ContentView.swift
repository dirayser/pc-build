//
//  ContentView.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 17.04.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var currentScreen = 2
    @StateObject var gpu = GPU(name: "Integrated", price: 0, benchmark: 850)
    @StateObject var cpu = CPU(name: "Select CPU", manufacturer: "")
    
    var screen =  UIScreen.main.bounds
    
    var body: some View {
        GeometryReader {
            geo in
            VStack {
                VStack {
                    if currentScreen == 0 {
                        ShopView()
                    } else if currentScreen == 1 {
                        MyFarmView()
                    } else if currentScreen == 2 {
                        MyPCView()
                    }
                    
                    Spacer()
                }
                
                
                HStack(spacing: 40) {
                    Button(action: {
                        self.currentScreen = 0
                    }) {
                        VStack {
                            Image(systemName: "cart")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Shop")
                                .foregroundColor(currentScreen == 0 ? .black : .gray)
                                .fontWeight(.bold)                        }
                        
                    }
                    
                    Divider()
                    
                    Button(action: {
                        self.currentScreen = 1
                    }) {
                        VStack {
                            Image(systemName: "xserve")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("My farm")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(currentScreen == 1 ? .black : .gray)
                    }
                    
                    Divider()
                    
                    Button(action: {
                        self.currentScreen = 2
                    }) {
                        VStack {
                            Image(systemName: "desktopcomputer")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("My PC")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(currentScreen == 2 ? .black : .gray)
                    }
                    
                    
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .padding(.bottom, geo.safeAreaInsets.bottom)
                .fixedSize()
                .frame(maxWidth: geo.size.width)
                .foregroundColor(.black)
                .background(Color.white)
                
            }
            .background(Color.black)
        }
        .environmentObject(gpu)
        .environmentObject(cpu)
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
