//
//  MemoryShortView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 20/10/25.
//

import SwiftUI

struct MemoryShortView: View {
    
    var memoryResponse: MemoryResponseModel?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "memorychip")
                    .scaleEffect(1.5)
                Text("Memory")
                    .font(.title2)
            }
            HStack(spacing: 0.0) {
                
                Text("\(formatFloatAsInt(memoryResponse?.currentUsage))")
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            .font(.system(size: 40, weight: .bold))
            
            Text("of \(formatFloatAsInt(memoryResponse?.totalCapacity)) GB")
//                .font(.system(size: 30, weight: .bold))
        
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    MemoryShortView(memoryResponse: MemoryResponseModel(currentUsage: 50,totalCapacity: 100))
}
