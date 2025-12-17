//
//  MemoryShortView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 20/10/25.
//

import SwiftUI

struct MemoryShortView: View {
    
    var memoryResponse: MemoryResponseModel?
    var staticData: StaticServerInformationModel?
    
    @State private var isPopoverShown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0.0) {
                Image(systemName: "memorychip")
                    .font(.title)
                Text("Memory")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            HStack(spacing: 0.0) {
                Text("\(formatFloatAsInt(memoryResponse?.currentUsage))")
                    .font(.system(size: 40, weight: .bold))
                    .contentTransition(.numericText())
                    .animation(.snappy, value: memoryResponse?.currentUsage)
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            Text("of \(formatFloatAsInt(staticData?.memoryTotalCapacity)) GB")
        }
        .frame(width: 120, height: 120)
        .onTapGesture {
            isPopoverShown = true
        }
        .popover(isPresented: $isPopoverShown, arrowEdge: .trailing) {
            MemoryPopoverView(memoryResponse: memoryResponse, staticData: staticData)
        }
    }
}

#Preview {
    let memoryData = MemoryResponseModel(currentUsage: 50, totalCapacity: 5)
    let serverModel = ServerModel(scheme: "scheme", name: "Name", host: "host", port: 1000, components: [])
    let staticData = StaticServerInformationModel(
        for: serverModel,
        cpu: CPUStaticInfo(name: "Apple M3", coreCount: 8, threadCount: 8),
        memory: MemoryStaticInfo(totalCapacity: 16.0, clockSpeed: 5000),
        disk: nil
        )
    
    MemoryShortView(memoryResponse: memoryData, staticData: staticData)
}
