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
