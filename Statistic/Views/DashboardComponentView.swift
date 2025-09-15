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
                    let currentCpuUsage: Float = viewModel.componentResponse.cpu?.currentUsage ?? 0.0
                    
                    ShortComponentView(
                        titleText: .constant("CPU"),
                        subtitleText: .constant(getCpuString(percentage: currentCpuUsage)),
                        progress: .constant(CGFloat(currentCpuUsage)))
                }

                if (serverModel.components.contains("Disk")) {
                    let currentDiskUsage: Float = viewModel.componentResponse.disk?.currentUsage ?? 0.0
                    
                    ShortComponentView(
                        titleText: .constant("Disk"),
                        subtitleText: .constant(getCpuString(percentage: currentDiskUsage)),
                        progress: .constant(CGFloat(currentDiskUsage)))
                }
                
                if (serverModel.components.contains("Memory")) {
                    let currentMemoryUsage: Float = viewModel.componentResponse.memory?.currentUsage ?? 0.0
                    
                    ShortComponentView(
                        titleText: .constant("Memory"),
                        subtitleText: .constant(getCpuString(percentage: currentMemoryUsage)),
                        progress: .constant(CGFloat(currentMemoryUsage)))
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
    let vader = ServerModel(name: "vader", host: "http://vader.int", port: 8005, components: [.CPU, .Memory, .Disk])
    DashboardComponentView(serverModel: .constant(vader))
        .frame(height: 500)
}
