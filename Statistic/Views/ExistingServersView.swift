//
//  ExistingServersView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import SwiftUI
import SwiftData

struct ExistingServersView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var serverModel: [ServerModel]
    @State private var sortOrder = [KeyPathComparator(\ServerModel.name)]
    
    var sortedServers: [ServerModel] {
        serverModel.sorted(using: sortOrder)
    }
    
    var body: some View {
        Table(sortedServers, sortOrder: $sortOrder) {
            TableColumn("Name", value: \.name)
            TableColumn("Host", value: \.host)
            TableColumn("Port", value: \.port.description)
            TableColumn("Data") { server in
                Text(server.components.sorted().joined(separator: ", "))
            }
        }
    }
}

struct ExistingServersViewPreview: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Button("Add servers", systemImage: "plus") {
            for i in 1...3 {
                let model = ServerModel(name: "Hello", host: "192.168.1.10\(i)", port: i, components: [.CPU, .Memory, .Disk])
                modelContext.insert(model)
            }
        }
        ExistingServersView()
    }
}


#Preview {
    ExistingServersViewPreview()
        .modelContainer(for: [ServerModel.self], inMemory: true)
}
