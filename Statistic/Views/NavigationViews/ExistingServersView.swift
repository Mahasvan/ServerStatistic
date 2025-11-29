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
    
    @State private var selectedServerID: ServerModel.ID?
    
    private var selectedServer: ServerModel? {
        guard let selectedServerID else { return nil }
        return serverModel.first { $0.id == selectedServerID }
    }
    
    var sortedServers: [ServerModel] {
        serverModel.sorted(using: sortOrder)
    }
    
    func deleteServer(server: ServerModel) {
        modelContext.delete(server)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Table(sortedServers, selection: $selectedServerID, sortOrder: $sortOrder) {
                    TableColumn("Name", value: \.name)
                    TableColumn("Scheme", value: \.scheme)
                    TableColumn("Host", value: \.host)
                    TableColumn("Port", value: \.port.description)
                    
                    TableColumn("Components") { server in
                        HStack {
                            ForEach(server.components, id: \.self) { component in
                                Image(systemName: getComponentImage(component))
//                                    .border(.blue)
                            }
//                            ForEach(server.components, id: \.self) { component in
//                                
//                            }
                        }
                    }
                }
                
                if selectedServer != nil {
                    VStack {
                        Spacer()
                        HStack {
                            // this is the container for the Edit and Delete Buttons
                            Spacer()
                            
                            Button(action: {}) {
                                Text("Edit")
//                                    .scaleEffect(1.5)
                                    .padding(10)
                            }
                            .buttonBorderShape(.capsule)
                            
                            Button(action: {
                                isShowingDeleteAlert = true
                            }) {
                                Text("Delete")
//                                    .scaleEffect(1.5)
                                    .padding(10)
                            }
//                            .background(Color(.red).opacity(0.5))
                            .foregroundStyle(.red)
                            .buttonBorderShape(.capsule)
                            .alert("Delete \(selectedServer?.name ?? "Server")?", isPresented: $isShowingDeleteAlert) {
                                Button("Yes", role: .destructive) {
                                    deleteServer(server: selectedServer!)
                                }
                                
                                Button("Cancel", role: .cancel) {}
                            }
                            
                            
                                

                            Spacer()
                        }
                        .padding(.bottom, 10)
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
