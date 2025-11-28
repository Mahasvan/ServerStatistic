//
//  ServerModels.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import Foundation
import SwiftData

enum ServerComponents: String, CaseIterable, Decodable {
    case CPU
    case Memory
    case Disk
}

@Model
class ServerModel: Identifiable {
    @Attribute(.unique) var id = UUID()
    var scheme: String
    var name: String
    var host: String
    var port: Int
    var components: [String] = []
    
    init(scheme: String, name: String, host: String, port: Int, components: [ServerComponents]) {
        self.scheme = scheme
        self.name = name
        self.host = host
        self.port = port
        self.components = components.map(\.self.rawValue)
    }
}

struct CPUResponseModel: Decodable {
    var currentUsage: Float?
    var currentTemp: Float?
}

struct MemoryResponseModel: Decodable {
    var currentUsage: Float?
    var totalCapacity: Float?
}

struct DiskResponseModel: Decodable {
    var currentUsage: Float?
    var totalCapacity: Float?
}


struct ComponentResponseModel: Decodable {
    var cpu: CPUResponseModel?
    var memory: MemoryResponseModel?
    var disk: DiskResponseModel?
}

@MainActor
class ComponentViewModel: ObservableObject {
    @Published var componentResponse: ComponentResponseModel = ComponentResponseModel()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadComponentData(for server: ServerModel) async {
        isLoading = true
        errorMessage = nil
        
        var componentOptions = ComponentOptions()
        componentOptions.cpu = server.components.contains("CPU")
        componentOptions.memory = server.components.contains("Memory")
        componentOptions.disk = server.components.contains("Disk")
        
        do {
            componentResponse = try await NetworkManager.shared.fetchComponentData(
                scheme: server.scheme,
                host: server.host,
                port: server.port,
                options: componentOptions
            )
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
