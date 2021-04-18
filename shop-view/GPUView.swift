//
//  GPUView.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 17.04.2021.
//

import SwiftUI

struct GPUView: View {
    var GPUItem: GPU
    var screen =  UIScreen.main.bounds
    
    var koef: CGFloat {
        screen.width / 530
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GPUen.name, ascending: true)],
        animation: .default)  private var cdGPU: FetchedResults<GPUen>
    
    @State var circleScale: CGFloat = 1
    @State var circleOpacity: Double = 1
    
    @EnvironmentObject var gpu: GPU
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(GPUItem.name)
                        .foregroundColor(.white)
                        .font(.custom("hey", size: 30))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(20)
                .padding(.top, geo.safeAreaInsets.bottom)
                .background(Color("gpuview-bgcolor"))
                
                VStack(spacing: 75 * koef) {
                    VStack {
                        Text("Price")
                            .foregroundColor(.white)
                            .font(.custom("Arial", size: 30))
                            .fontWeight(.bold)
                        VStack(spacing: 25) {
                            Image(systemName: "dollarsign.circle")
                                .resizable()
                                .foregroundColor(Color("dollar-color"))
                                .frame(width: 100 * koef, height: 100 * koef)
                            Text("\(GPUItem.price, specifier: "%.f") $")
                                .foregroundColor(.white)
                                .font(.custom("Arial", size: 50 * koef))
                                .fontWeight(.bold)
                        }
                        
                    }
                    
                    VStack {
                        Text("Benchmark")
                            .foregroundColor(.white)
                            .font(.custom("Arial", size: 30))
                            .fontWeight(.bold)
                        VStack(spacing: 25) {
                            Image(systemName: "bolt.circle")
                                .resizable()
                                .foregroundColor(.yellow)
                                .frame(width: 100 * koef, height: 100 * koef)
                                .overlay(
                                    Circle()
                                        .scale(circleScale)
                                        .stroke(Color.yellow, lineWidth: 4)
                                        .opacity(circleOpacity)
                                        .onAppear(perform: {
                                            withAnimation(
                                                Animation.linear(duration: 1)
                                                    .repeatForever(autoreverses: false)
                                            ) {
                                                self.circleScale = 2
                                                self.circleOpacity = 0
                                            }
                                        })
                                )
                            Text("\(GPUItem.benchmark, specifier: "%d points")")
                                .foregroundColor(.white)
                                .font(.custom("Arial", size: 50 * koef))
                                .fontWeight(.bold)
                        }
                        
                    }
                    
                    Button(action: {
                        if cdGPU.count == 1 {
                            cdGPU[0].setValue(GPUItem.name, forKey: "name")
                            cdGPU[0].setValue(GPUItem.price, forKey: "price")
                            cdGPU[0].setValue(GPUItem.benchmark, forKey: "benchmark")
                        } else {
                            let newGPU = GPUen(context: viewContext)
                            newGPU.name = GPUItem.name
                            newGPU.price = GPUItem.price
                            newGPU.benchmark = Int64(GPUItem.benchmark)
                        }
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                        self.gpu.benchmark = GPUItem.benchmark
                        self.gpu.name = GPUItem.name
                        self.gpu.price = GPUItem.price
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black)
                            .frame(width: 150, height: 50)
                            .overlay(
                                HStack(spacing: 20) {
                                    Image(systemName: "cart.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                    Text("Buy")
                                        .foregroundColor(.white)
                                        .font(.custom("hey", size: 30))
                                        .fontWeight(.bold)
                                })
                    }
                }
                .padding(.top, 10)
                Spacer()
            }
            .frame(
                width: screen.width,
                height: geo.size.height
            )
            .background(Color("bgcolor").edgesIgnoringSafeArea(.bottom))
        }
        
    }
}

struct GPUView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
