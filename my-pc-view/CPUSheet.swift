//
//  CPUSheet.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 17.04.2021.
//

import SwiftUI

struct CPUSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var cpu: CPU
    
    var screen =  UIScreen.main.bounds
    var CPUs = [
        CPU(name: "Ryzen 5 3600X", manufacturer: "AMD"),
        CPU(name: "Ryzen 5 5600X", manufacturer: "AMD"),
        CPU(name: "Core i7-7700FQ", manufacturer: "Intel"),
        CPU(name: "Core i7-9700FQ", manufacturer: "Intel")
    ]
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(CPUs) { currCPU in
                    Section {
                        Button(action: {
                            self.cpu.name = currCPU.name
                            self.cpu.manufacturer = currCPU.manufacturer
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "gamecontroller")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(currCPU.name)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(currCPU.manufacturer)
                                        .fontWeight(.bold)
                                }
                                
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 30)
                            .frame(height: 150)
                        }
                    }
                        
                }
            }
            .navigationBarTitle("Choose CPU")
        }
        .frame(
            width: screen.width,
            height: screen.height
        )
        .preferredColorScheme(.dark)
        .background(Color("bgcolor"))
    }
}
