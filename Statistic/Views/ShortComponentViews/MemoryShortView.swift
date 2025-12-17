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
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            Text("of \(formatFloatAsInt(memoryResponse?.totalCapacity)) GB")
        
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    MemoryShortView(memoryResponse: MemoryResponseModel(currentUsage: 50,totalCapacity: 100))
}
