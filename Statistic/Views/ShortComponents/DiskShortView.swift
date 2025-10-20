//
//  DiskShortView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 20/10/25.
//

import SwiftUI

struct DiskShortView: View {
    
    @Binding var usagePercent: Float
    @Binding var usedSpace: Float
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Disk")
            HStack(spacing: 0.0) {
                Text("\(Int(usagePercent))")
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            .font(.system(size: 40, weight: .bold))
            
            Text("\(Int(usedSpace)) GB Used")
//                .font(.system(size: 30, weight: .bold))
        
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    DiskShortView(usagePercent: .constant(50), usedSpace: .constant(100))
}
