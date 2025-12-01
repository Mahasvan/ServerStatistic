//
//  DiskShortView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 20/10/25.
//

import SwiftUI

struct DiskComponentView: View {
    
    @Binding var usagePercent: Float?
    @Binding var totalCapacity: Float?
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "internaldrive")
                    .scaleEffect(1.5)
                Text("Disk")
                    .font(.title2)
            }
            
            HStack(spacing: 0.0) {
                Text("\(formatFloatAsInt(usagePercent))")
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            .font(.system(size: 40, weight: .bold))
            
            Text("of \(formatFloatAsInt(totalCapacity)) GB")
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    DiskComponentView(usagePercent: .constant(50), totalCapacity: .constant(100))
}
