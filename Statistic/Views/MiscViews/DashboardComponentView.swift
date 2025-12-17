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
    @Binding var serverModel: ServerModel

    
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
                if self.serverModel.staticInfo == nil {
                    do {
                        let model = try await NetworkManager.shared.fetchStaticData(for: serverModel)
                        if model != nil {
                            modelContext.insert(model!)
                        }
                    } catch {
                    }
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
    DashboardComponentView(serverModel: .constant(vader))
        .frame(height: 500)
}
