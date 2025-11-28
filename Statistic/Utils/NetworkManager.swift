//
//  DataFetcher.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 29/08/25.
//

import Foundation

struct ComponentOptions: Codable {
    var cpu: Bool = false
    var memory: Bool = false
    var disk: Bool = false
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchComponentData(scheme: String, host: String, port: Int, options: ComponentOptions) async throws -> ComponentResponseModel {
        
        let cpu = options.cpu ? "true" : "false"
        let memory = options.memory ? "true" : "false"
        let disk = options.disk ? "true" : "false"
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        components.path = "/components"
        components.queryItems = [
            URLQueryItem(name: "cpu", value: cpu),
            URLQueryItem(name: "memory", value: memory),
            URLQueryItem(name: "disk", value: disk)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(ComponentResponseModel.self, from: data)
    }
}
