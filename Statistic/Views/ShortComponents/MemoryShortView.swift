//
//  MemoryShortView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 20/10/25.
//

import SwiftUI

struct MemoryShortView: View {
    
    @Binding var usagePercent: Float
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Memory")
            HStack(spacing: 0.0) {
                Text("\(Int(usagePercent))")
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            .font(.system(size: 40, weight: .bold))
            
            Text("8 / 16 GB")
//                .font(.system(size: 30, weight: .bold))
        
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    MemoryShortView(usagePercent: .constant(50))
}
