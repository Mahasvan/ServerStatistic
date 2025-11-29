//
//  DashboardComponentView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import SwiftUI

struct DashboardComponentView: View {
    @StateObject private var viewModel = ComponentViewModel()

    @Binding var serverModel: ServerModel
    
    func getCpuString(percentage: Float) -> String {
        return String(Int(percentage*100)) + "%"
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if (serverModel.components.contains("CPU")) {
                    let currentCpuUsage: Float? = viewModel.componentResponse.cpu?.currentUsage
                    let currentCpuTemp: Float? = viewModel.componentResponse.cpu?.currentTemp
                    CPUShortView(usage: .constant(currentCpuUsage), temp: .constant(currentCpuTemp))
                }

                if (serverModel.components.contains("Disk")) {
                    let currentDiskUsage: Float? = viewModel.componentResponse.disk?.currentUsage
                    let totalDiskCapacity: Float? = viewModel.componentResponse.disk?.totalCapacity
                    
                    DiskShortView(usagePercent: .constant(currentDiskUsage), totalCapacity: .constant(totalDiskCapacity))
                }
                
                if (serverModel.components.contains("Memory")) {
                    let currentMemoryUsage: Float? = viewModel.componentResponse.memory?.currentUsage
                    let totalMemoryCapacity: Float? = viewModel.componentResponse.memory?.totalCapacity
                    MemoryShortView(usagePercent: .constant(currentMemoryUsage), totalCapacity: .constant(totalMemoryCapacity))
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
