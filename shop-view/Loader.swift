//
//  Loader.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 19.04.2021.
//

import SwiftUI

struct Loader: View {
    
    @Binding var GPUS: [GPU]
    @State var loadingRotation = 0.0
    var screen =  UIScreen.main.bounds
    
    var body: some View {
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
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
