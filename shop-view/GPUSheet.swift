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
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding(.top, geo.safeAreaInsets.bottom)
                .padding(20)
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
                        self.gpu.benchmark = GPUItem.benchmark
                        self.gpu.name = GPUItem.name
                        self.gpu.price = GPUItem.price
                        createNotification()
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
    
    func createNotification() {
        let content = UNMutableNotificationContent()
        content.title = "GPU updated"
        content.subtitle = "\(gpu.name) selected"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "IN-APP", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

struct GPUView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
