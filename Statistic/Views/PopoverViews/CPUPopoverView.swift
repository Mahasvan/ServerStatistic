//
//  AppleCPUPopoverView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 17/12/25.
//

import SwiftUI

struct CPUPopoverView: View {
    
    var cpuResponse: CPUResponseModel?
    var staticData: StaticServerInformationModel?
    
    var body: some View {
        
        VStack {
            HStack {
                
                ZStack {
                    VStack {
                        Text("\(formatFloatAsInt(cpuResponse?.currentUsage))%")
                            .font(.system(size: 25, weight: .bold))
                        Text("\(formatFloatAsInt(cpuResponse?.currentTemp))°C")
                            .font(.system(size: 15, weight: .regular))
                    }
                    .contentTransition(.numericText())
                    .animation(.snappy, value: cpuResponse?.currentUsage)
                    
                    CircularProgressBar(
                        lineWidth: 10,
                        diameter: 100.0,
                        progress: .constant(CGFloat(cpuResponse?.currentUsage ?? 0.0)))
                }
                
                VStack {
                    Text(staticData?.cpuName ?? "?")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("\(staticData?.cpuCoreCount?.description ?? "?") Cores")
                    Text("\(staticData?.cpuThreadCount?.description ?? "?") Threads")
                }
            }
            .padding(10)
            
            
            
        }
        .padding(20)
        
    }
}

#Preview {
    let CPUData = CPUResponseModel(currentUsage: 0.3, currentTemp: 100)
    let serverModel = ServerModel(scheme: "scheme", name: "Name", host: "host", port: 1000, components: [])
    let staticData = StaticServerInformationModel(
        for: serverModel,
        cpu: CPUStaticInfo(name: "Apple M3", coreCount: 8, threadCount: 8),
        memory: nil,
        disk: nil
        )
    CPUPopoverView(cpuResponse: CPUData, staticData: staticData)
}
