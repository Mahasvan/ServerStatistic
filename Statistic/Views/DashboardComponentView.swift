//
//  DashboardComponentView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import SwiftUI

struct DashboardComponentView: View {
    @StateObject private var viewModel = ComponentViewModel()
    
    private var serverModel = ServerModel(name: "", host: "", port: 1, components: [.CPU, .Disk, .Memory])
    
    func getCpuString(percentage: Float) -> String {
        return String(Int(percentage*100)) + "%"
    }
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack { 
                if (serverModel.components.contains("CPU")) {
                    let currentCpuUsage: Float = viewModel.componentResponse.cpu?.currentUsage ?? 0.0
                    
                    ShortComponentView(titleText: .constant("CPU"), subtitleText: .constant(getCpuString(percentage: currentCpuUsage)), progress: .constant(CGFloat(currentCpuUsage)))
                }
                
                if (serverModel.components.contains("Disk")) {
                    let currentDiskUsage: Float = viewModel.componentResponse.disk?.currentUsage ?? 0.0
                    
                    ShortComponentView(titleText: .constant("Disk"), subtitleText: .constant(getCpuString(percentage: currentDiskUsage)), progress: .constant(CGFloat(currentDiskUsage)))
                }
                
                if (serverModel.components.contains("Memory")) {
                    let currentMemoryUsage: Float = viewModel.componentResponse.memory?.currentUsage ?? 0.0
                    
                    ShortComponentView(titleText: .constant("Memory"), subtitleText: .constant(getCpuString(percentage: currentMemoryUsage)), progress: .constant(CGFloat(currentMemoryUsage)))
                }
                
                
            }
            .task {
                repeat {
                    try? await Task.sleep(for: .seconds(5))
                    await viewModel.loadComponentData(for: serverModel)
                } while (!Task.isCancelled)
            }
        }
    }
}

#Preview {
    DashboardComponentView()
}
