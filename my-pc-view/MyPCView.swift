//
//  MyPCView.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 17.04.2021.
//

import SwiftUI

struct MyPCView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CPUen.name, ascending: true)],
        animation: .default)  private var cdCPU: FetchedResults<CPUen>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GPUen.name, ascending: true)],
        animation: .default)  private var cdGPU: FetchedResults<GPUen>
    
    @EnvironmentObject var cpu: CPU // = CPU(name: "No CPU", manufacturer: "")
    @EnvironmentObject var gpu: GPU
    
    @State var CPUIndex: Int = 0
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
        .onAppear {
            if cdCPU.count == 1 {
                self.cpu.name = cdCPU[0].name!
                self.cpu.manufacturer = cdCPU[0].manufacturer!
            
            }
            if cdGPU.count == 1 {
                self.gpu.name = cdGPU[0].name!
                self.gpu.price = cdGPU[0].price
                self.gpu.benchmark = UInt(cdGPU[0].benchmark)
            }
        }
    }
        
}

struct MyPCView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
