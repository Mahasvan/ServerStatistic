//
//  AppleCPUPopoverView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 17/12/25.
//

import SwiftUI

struct AppleCPUPopoverView: View {
    
    var cpuName: String?
    var cpuCores: Int?
    
    var usage: Float?
    var temperature: Float?
    
    var body: some View {
        VStack {
            Text(cpuName ?? "?")
            Text("\(cpuName ?? "?") Cores")
            
            Text("Usage: \(formatFloatAsInt(usage))%")
            Text("Temperature: \(formatFloatAsInt(temperature))%")
        }
        .padding(20)
        
    }
}

#Preview {
    AppleCPUPopoverView(cpuName: "Apple M3", cpuCores: 8)
}
