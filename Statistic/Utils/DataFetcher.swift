//
//  DataFetcher.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 29/08/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchComponentData(host: String, port: Int, cpu: Bool, memory: Bool, disk: Bool) async throws -> ComponentResponseModel {
        let query = "\(host):\(port)/components?cpu=\(cpu)&memory=\(cpu)&disk=\(cpu)"
        guard let url = URL(string: query) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(ComponentResponseModel.self, from: data)
    }
}
