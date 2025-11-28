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
    
    @State private var isShowingDeleteAlert: Bool = false

    var sortedServers: [ServerModel] {
        serverModel.sorted(using: sortOrder)
    }
    
    func deleteServer(server: ServerModel) {
        modelContext.delete(server)
    }
    
    var body: some View {
        NavigationStack {
            Table(sortedServers, sortOrder: $sortOrder) {
                TableColumn("Name", value: \.name)
                TableColumn("Scheme", value: \.scheme)
                TableColumn("Host", value: \.host)
                TableColumn("Port", value: \.port.description)
                TableColumn("Data") { server in
                    Text(server.components.sorted().joined(separator: ", "))
                }
                
                TableColumn("Actions") { (server: ServerModel)  in
                    HStack {
                        NavigationLink(destination: EditServerView(server: .constant(server))) {
                            Text("Edit")
                                .foregroundStyle(.blue)
                        }
                        
                        Button("Delete") {
                            isShowingDeleteAlert = true
                        }
                        .alert("Delete \(server.name)?", isPresented: $isShowingDeleteAlert) {
                            Button("Yes", role: .destructive) {
                                deleteServer(server: server)
                            }
                            
                            Button("Cancel", role: .cancel) {}
                        }
                        .foregroundStyle(.blue)
                        
                        
                    }
                }
            }
        }
        .navigationTitle("View Configured Servers")
    }
}

struct ExistingServersViewPreview: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Button("Add servers", systemImage: "plus") {
            for i in 1...3 {
                let model = ServerModel(scheme: "http", name: "Hello", host: "192.168.1.10\(i)", port: i, components: [.CPU, .Memory, .Disk])
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
