//
//  DashboardComponentView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import SwiftUI
import SwiftData

struct DashboardComponentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ComponentViewModel()
    @Binding var serverModel: ServerModel
    private let serverID: UUID

    @Query(filter: ServerModel.getValidServers())
    private var serverModels: [ServerModel]
    
    @Query private var staticServerInformation: [StaticServerInformationModel]

    init(serverModel: Binding<ServerModel>) {
        self._serverModel = serverModel
        self.serverID = serverModel.wrappedValue.id
        // Configure the query with a predicate that captures serverID
        self._staticServerInformation = Query(filter: StaticServerInformationModel.getStaticInformation(for: serverModel.wrappedValue))
    }
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if (serverModel.components.contains("CPU")) {
                    CPUShortView(cpuResponse: viewModel.componentResponse.cpu)
                }

                if (serverModel.components.contains("Disk")) {
                    DiskShortView(diskResponse: viewModel.componentResponse.disk)
                }
                
                if (serverModel.components.contains("Memory")) {
                    MemoryShortView(memoryResponse: viewModel.componentResponse.memory)
                }
            }
            .task {
                repeat {
                    await viewModel.loadComponentData(for: serverModel)
                    try? await Task.sleep(for: .seconds(5))
                } while (!Task.isCancelled)
            }
//            .frame(width: 750, height: 250)
//            .scrollTargetLayout()
        }
    }
}

#Preview {
    let vader = ServerModel(scheme: "http", name: "vader", host: "localhost", port: 8000, components: [.CPU, .Memory, .Disk])
    DashboardComponentView(serverModel: .constant(vader))
        .frame(height: 500)
}
