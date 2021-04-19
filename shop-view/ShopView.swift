//
//  ShopView.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 17.04.2021.
//

import SwiftUI

struct ShopView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: GPUen.entity(),
                  sortDescriptors: [])  private var cdGPU: FetchedResults<GPUen>
    
    @EnvironmentObject var gpu: GPU
    
    @State var secondsWaited = 0
    @State var GPUS = [GPU]()
    @State private var showingSheet = false
    @State var loadingRotation = 0.0
    
    var screen =  UIScreen.main.bounds
    
    var body: some View {
            NavigationView {
                if GPUS.count > 0 {
                    Form {
                            ForEach(GPUS) { currGPU in
                                Section {
                                    Button(action: {
                                        self.showingSheet.toggle()
                                    }) {
                                        HStack {
                                            Image(systemName: "ant.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80)
                                            Spacer()
                                            VStack {
                                                Text("\(currGPU.name)")
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                Spacer()
                                                Text("\(currGPU.price, specifier: "%.f $")")
                                                    .fontWeight(.bold)
                                            }
                                        }
                                        .foregroundColor(.white)
                                        .padding(.vertical, 30)
                                        .frame(height: 150)
                                    }
                                    .sheet(isPresented: $showingSheet, onDismiss: {
                                        if cdGPU.count == 1 {
                                            cdGPU[0].setValue(gpu.name, forKey: "name")
                                            cdGPU[0].setValue(gpu.price, forKey: "price")
                                            cdGPU[0].setValue(Int64(gpu.benchmark), forKey: "benchmark")
                                        } else {
                                            let newGPU = GPUen(context: viewContext)
                                            newGPU.name = gpu.name
                                            newGPU.price = gpu.price
                                            newGPU.benchmark = Int64(gpu.benchmark)
                                        }
                                        do {
                                            try viewContext.save()
                                        } catch {
                                            let nsError = error as NSError
                                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                        }
                                    }) {
                                        GPUView(GPUItem: currGPU)
                                    }
                                }
                                    
                            }
                        }
                    .navigationBarTitle("Shop")
                }
                else {
                    if secondsWaited < 20 {
                                Circle()
                                    .stroke(Color.white, style: StrokeStyle(lineWidth: 3, dash: [10, 15]))
                                    .frame(width: 150, height: 150)
                                    .navigationBarTitle("Shop")
                                    .rotationEffect(.degrees(loadingRotation))
                                    .overlay(Text("Loading"))
                                    .position(x: screen.width / 2, y: screen.height / 3)
                                    .onAppear {
                                        if GPUS.count == 0 {
                                            withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                                                loadingRotation += 360
                                            }
                                        }
                                    }
                    }
                    else {
                        VStack(spacing: 20) {
                            Text("No internet connection")
                                .font(.title)
                            Button(action: {
                                self.secondsWaited = 0
                                Timer.scheduledTimer(withTimeInterval: 12, repeats: true) { timer in
                                    secondsWaited += 10
                                    getGPUs().forEach {
                                        GPUS.append(GPU(name: $0.name, price: $0.price, benchmark: $0.benchmark))
                                    }
                                    if secondsWaited == 20 || GPUS.count > 0 {
                                        timer.invalidate()
                                    }
                                }

                            }) {
                                Text("Try again")
                                    .font(.title)
                            }
                            
                        }
                    }
                    }
                
                }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    getGPUs().forEach {
                        GPUS.append(GPU(name: $0.name, price: $0.price, benchmark: $0.benchmark))
                    }
                    self.secondsWaited = 20
                }
        }
        
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
