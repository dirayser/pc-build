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
    @StateObject var delegate = NotificationDelegate()
    @ObservedObject var gpu = GPU(name: "Integrated", price: 0, benchmark: 850)
    @ObservedObject var cpu = CPU(name: "Select CPU", manufacturer: "")
    
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
                }
                TabsView(screenIndex: $currentScreen)
                    .padding(.bottom, geo.safeAreaInsets.bottom)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .background(Color.black)
        }
        .environmentObject(gpu)
        .environmentObject(cpu)
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (_, _) in
            }
            
            UNUserNotificationCenter.current().delegate = delegate
        }
        
    }
}

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
