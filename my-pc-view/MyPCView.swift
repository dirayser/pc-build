//
//  MyPCView.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 17.04.2021.
//

import SwiftUI

struct MyPCView: View {
    @State var CPUIndex: Int = 0
    @EnvironmentObject var cpu: CPU // = CPU(name: "No CPU", manufacturer: "")
    @EnvironmentObject var gpu: GPU
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("GPU").font(.title)) {
                    HStack {
                        Image(systemName: "gamecontroller")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(gpu.name)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            HStack {
                                Text("Benchmark points:")
                                    .fontWeight(.bold)
                                Text("\(gpu.benchmark)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.pink)
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 30)
                    .frame(height: 150)
                }
                
                Section(header: Text("CPU").font(.title)) {
                    Button(action: {
                        self.showingSheet.toggle()
                    }) {
                        HStack {
                            Image(systemName: "gamecontroller")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(cpu.name)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                Text(cpu.manufacturer)
                                    .fontWeight(.bold)
                            }
                            
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 30)
                        .frame(height: 150)
                    }
                    .sheet(isPresented: $showingSheet) {
                        CPUSheet(cpu: self.cpu)
                    }
                    
                 }
            }
            .padding(.top, 30)
            .navigationTitle("My PC")
        }
    }
        
}

struct MyPCView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
