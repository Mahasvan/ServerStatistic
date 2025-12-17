//
//  AppleCPUPopoverView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 17/12/25.
//

import SwiftUI

struct DiskPopoverView: View {
    
    var diskResponse: DiskResponseModel?
    var staticData: StaticServerInformationModel?
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    VStack {
                        Text("\(formatFloatAsInt(diskResponse?.currentUsage))%")
                            .font(.system(size: 25, weight: .bold))
                    }
                    
                    let percentFilled = (diskResponse?.currentUsage ?? 0.0)
                    CircularProgressBar(
                        lineWidth: 10,
                        diameter: 100.0,
                        progress: .constant(CGFloat(percentFilled)))
                }
                
                VStack {
                    Text(staticData?.diskVolumeName ?? "?")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("Capacity: \(formatFloatAsInt(staticData?.diskTotalCapacity)) GB")
                }
            }
            .padding(10)
            
            
            
        }
        .padding(20)
        
    }
}

#Preview {
    let diskData = DiskResponseModel(currentUsage: 100.0, totalCapacity: 200.0)
    let serverModel = ServerModel(scheme: "scheme", name: "Name", host: "host", port: 1000, components: [])
    let staticData = StaticServerInformationModel(
        for: serverModel,
        cpu: CPUStaticInfo(name: "Apple M3", coreCount: 8, threadCount: 8),
        memory: nil,
        disk: DiskStaticInfo(volumeName: "My Volume", totalCapacity: 200.0)
        )
    DiskPopoverView(diskResponse: diskData, staticData: staticData)
}
