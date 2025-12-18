//
//  DataFetcher.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 29/08/25.
//

import Foundation
import SwiftData
import SwiftUI

struct ComponentOptions: Codable {
    var cpu: Bool = false
    var memory: Bool = false
    var disk: Bool = false
}

func queryItemsFromModel(_ model: ServerModel) async throws -> ComponentResponseModel {
    let scheme = model.host
    let host = model.host
    let port = model.port
    let options = model.components
    
    let componentOptions = ComponentOptions(
        cpu: options.contains("CPU"),
        memory: options.contains("Memory"),
        disk: options.contains("Disk")
    )
    return try await NetworkManager.shared.fetchComponentData(scheme: scheme, host: host, port: port, options: componentOptions)
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchStaticData(for server: ServerModel) async throws -> StaticServerInformationModel {
        var components = URLComponents()
        components.scheme = server.scheme
        components.host = server.host
        components.port = server.port
        components.path = "/components/static"
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response: StaticResponseModel? = try? JSONDecoder().decode(StaticResponseModel.self, from: data)
        
        if (response != nil) {
            return StaticServerInformationModel(for: server, cpu: response?.cpu, memory: response?.memory, disk: response?.disk)
        }
        
        throw URLError(.badServerResponse)
    }
    
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
