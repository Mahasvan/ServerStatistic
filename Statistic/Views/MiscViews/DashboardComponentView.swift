//
//  DashboardComponentView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

// This view also populates Static Data for the server when it loads, if not present.

import SwiftUI
import SwiftData

struct DashboardComponentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ComponentViewModel()
    var serverModel: ServerModel
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(serverModel.components, id: \.self) { component in
                    switch String(describing: component) {
                        case "CPU":
                            CPUShortView(cpuResponse: viewModel.componentResponse.cpu, staticData: serverModel.staticInfo)
                        case "Disk":
                            DiskShortView(diskResponse: viewModel.componentResponse.disk, staticData: serverModel.staticInfo)
                        case "Memory":
                            MemoryShortView(memoryResponse: viewModel.componentResponse.memory, staticData: serverModel.staticInfo)
                        default:
                            EmptyView()
                    }
                }
            }
            .task {
                if serverModel.staticInfo == nil, let model = try? await NetworkManager.shared.fetchStaticData(for: serverModel) { modelContext.insert(model)
                }
                
                repeat {
                    await viewModel.loadComponentData(for: serverModel)
                    try? await Task.sleep(for: .seconds(5))
                } while (!Task.isCancelled)
            }
        }
    }
}

#Preview {
    let vader = ServerModel(scheme: "http", name: "vader", host: "localhost", port: 8000, components: [.CPU, .Memory, .Disk])
    DashboardComponentView(serverModel: vader)
        .frame(height: 500)
}
