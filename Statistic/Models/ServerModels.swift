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
class ServerModel {
    @Attribute(.unique) var id = UUID()
    private(set) var name: String
    private(set) var host: String
    private(set) var port: Int
    private(set) var components: [String] = []
    
    init(name: String, host: String, port: Int, components: [ServerComponents]) {
        self.name = name 
        self.host = host
        self.port = port
        self.components = components.map(\.self.rawValue)
    }
}

struct CPUResponseModel: Decodable {
    var currentUsage: Float
    var usageHistory: [Float]?
}

struct MemoryResponseModel: Decodable {
    var currentUsage: Float
    var usageHistory: [Float]?
}

struct DiskResponseModel: Decodable {
    var currentUsage: Float
    var usageHistory: [Float]?
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
        
        do {
            componentResponse = try await NetworkManager.shared.fetchComponentData(
                cpu: server.components.contains("CPU"),
                memory: server.components.contains("Memory"),
                disk: server.components.contains("Disk"))
        } catch {
            errorMessage = error.localizedDescription
//            let cpu = server.components.contains("CPU")
//            let memory = server.components.contains("Memory")
//            let disk = server.components.contains("Disk")
//            
//            let url = URL(string: "http://127.0.0.1:8000/components?cpu=\(cpu)&memory=\(memory)&disk=\(cpu)")
//            errorMessage = url?.absoluteString
        }
        isLoading = false
    }
}
