//
//  DataFetcher.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 29/08/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchComponentData(cpu: Bool, memory: Bool, disk: Bool) async throws -> ComponentResponseModel {
        guard let url = URL(string: "http://localhost:8000/components?cpu=\(cpu)&memory=\(cpu)&disk=\(cpu)") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(ComponentResponseModel.self, from: data)
    }
}
