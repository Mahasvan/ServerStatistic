//
//  AppleCPUPopoverView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 17/12/25.
//

import SwiftUI

struct MemoryPopoverView: View {
    
    var memoryResponse: MemoryResponseModel?
    var staticData: StaticServerInformationModel?
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    VStack {
                        Text("\(formatFloatAsInt(memoryResponse?.currentUsage))%")
                            .font(.system(size: 25, weight: .bold))
                    }
                    
                    let percentFilled = (memoryResponse?.currentUsage ?? 0.0)
                    CircularProgressBar(
                        lineWidth: 10,
                        diameter: 100.0,
                        progress: .constant(CGFloat(percentFilled)))
                }
                
                VStack {
                    Text("of \(formatFloatAsInt(staticData?.memoryTotalCapacity)) GB")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("Speed: \(staticData?.memoryClockSpeed ?? 0) Hz")
                }
            }
            .padding(10)
        }
        .padding(20)
        
    }
}

#Preview {
    let memoryData = MemoryResponseModel(currentUsage: 50, totalCapacity: 200.0)
    let serverModel = ServerModel(scheme: "scheme", name: "Name", host: "host", port: 1000, components: [])
    let staticData = StaticServerInformationModel(
        for: serverModel,
        cpu: nil,
        memory: MemoryStaticInfo(totalCapacity: 16.0, clockSpeed: 5000),
        disk: nil
        )
    MemoryPopoverView(memoryResponse: memoryData, staticData: staticData)
}
