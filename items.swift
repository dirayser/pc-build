//
//  items.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 18.04.2021.
//

import Foundation

class Hardware: ObservableObject, Identifiable {
    var id = UUID()
    @Published var name: String
    
    init(name: String) {
        self.name = name
    }
}
class GPU: Hardware {
    @Published var price: Double
    @Published var benchmark: UInt
    
    init(name: String, price: Double, benchmark: UInt) {
        self.price = price
        self.benchmark = benchmark
        super.init(name: name)
    }
}

class CPU: Hardware {
    @Published var manufacturer: String
    
    init(name: String, manufacturer: String) {
        self.manufacturer = manufacturer
        super.init(name: name)
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
