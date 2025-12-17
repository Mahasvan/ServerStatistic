//
//  DiskShortView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 20/10/25.
//

import SwiftUI

struct DiskShortView: View {
    
    var diskResponse: DiskResponseModel?
    

    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Image(systemName: "internaldrive")
                    .font(.title)
                Text("Disk")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            HStack(spacing: 0.0) {
                Text("\(formatFloatAsInt(diskResponse?.currentUsage))")
                    .font(.system(size: 40, weight: .bold))
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            Text("of \(formatFloatAsInt(diskResponse?.totalCapacity)) GB")
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    DiskShortView(diskResponse: DiskResponseModel())
}
