//
//  items.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 18.04.2021.
//

import Foundation

class GPU: ObservableObject, Identifiable {
    var id = UUID()
    @Published var name: String
    @Published var price: Double
    @Published var benchmark: UInt
    
    init(name: String, price: Double, benchmark: UInt) {
        self.name = name
        self.price = price
        self.benchmark = benchmark
    }
}

class CPU: ObservableObject, Identifiable {
    var id = UUID()
    @Published var name: String
    @Published var manufacturer: String
    
    init(name: String, manufacturer: String) {
        self.name = name
        self.manufacturer = manufacturer
    }
}

func getGPUs() -> [GPUItemC] {
        var res = [GPUItemC]()
        guard let url = URL(string: "https://build-pc-api.herokuapp.com")
            else { return [] }
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                semaphore.signal()
            }
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([GPUItemC].self, from: data) {
                        res = decodedResponse
                        semaphore.signal()
                    }
            }
        }
        task.resume()
        semaphore.wait()
        return res
}

struct GPUItemC: Codable {
    var name: String
    var price: Double
    var benchmark: UInt
}
