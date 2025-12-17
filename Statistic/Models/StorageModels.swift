//
//  ServerModels.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import Foundation
import SwiftData
internal import Combine

enum ServerComponents: String, CaseIterable, Decodable {
    case CPU
    case Memory
    case Disk
}

enum Schemes: String, Hashable {
    case http
    case https
}

func getComponentImage(_ component: String) -> String {
    switch component {
    case "CPU":
        return "cpu.fill"
    case "Memory":
        return "memorychip.fill"
    case "Disk":
        return "internaldrive.fill"
    default:
        return "person.fill.questionmark"
    }
}

@Model
class ServerModel: Identifiable {
    @Attribute(.unique) var id = UUID()
    var scheme: String
    var name: String
    var host: String
    var port: Int
    var components: [String] = []
    var placeholder: Bool = false

    @Relationship(inverse: \StaticServerInformationModel.server)
    var staticInfo: StaticServerInformationModel?

    
    init(scheme: String, name: String, host: String, port: Int, components: [ServerComponents], placeholder: Bool = false) {
        self.scheme = scheme
        self.name = name
        self.host = host
        self.port = port
        self.components = components.map(\.self.rawValue)
        self.placeholder = placeholder
    }
}

extension ServerModel {
    static func getValidServers() -> Predicate<ServerModel> {
        return #Predicate<ServerModel> { server in
            !server.placeholder
        }
    }
    
    static func getInvalidServers() -> Predicate<ServerModel> {
        return #Predicate<ServerModel> { server in
            server.placeholder
        }
    }
}


@Model
class StaticServerInformationModel: Identifiable {
    @Attribute(.unique) var id: UUID
    
    var cpuName: String?
    var cpuCoreCount: Int?
    var cpuThreadCount: Int?
    
    var memoryTotalCapacity: Float?
    var memoryClockSpeed: Int?
    
    var diskVolumeName: String?
    var diskTotalCapacity: Float?
    
    @Relationship
    var server: ServerModel
    
    init(for server: ServerModel, cpu: CPUStaticInfo?, memory: MemoryStaticInfo?, disk: DiskStaticInfo?) {
        self.id = UUID()
        self.server = server
        self.cpuName = cpu?.name
        self.cpuCoreCount = cpu?.coreCount
        self.cpuThreadCount = cpu?.threadCount
        self.memoryTotalCapacity = memory?.totalCapacity
        self.memoryClockSpeed = memory?.clockSpeed
        self.diskVolumeName = disk?.volumeName
        self.diskTotalCapacity = disk?.totalCapacity
    }
}

extension StaticServerInformationModel {
    static func getStaticInformation(for server: ServerModel) -> Predicate<StaticServerInformationModel> {
        let serverID = server.id
        return #Predicate<StaticServerInformationModel> { staticInfo in
            staticInfo.id == serverID
        }
    }
}

struct StaticResponseModel: Decodable {
    var cpu: CPUStaticInfo?
    var memory: MemoryStaticInfo?
    var disk: DiskStaticInfo?
}

struct CPUStaticInfo: Decodable {
    var name: String?
    var coreCount: Int?
    var threadCount: Int?
}

struct MemoryStaticInfo: Decodable {
    var totalCapacity: Float?
    var clockSpeed: Int?
}

struct DiskStaticInfo: Decodable {
    var volumeName: String?
    var totalCapacity: Float?
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

