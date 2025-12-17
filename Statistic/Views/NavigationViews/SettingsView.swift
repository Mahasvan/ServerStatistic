//
//  SettingsView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 13/09/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query var serverModels: [ServerModel]
    @Query var staticInfo: [StaticServerInformationModel]
    
    func deleteServers() -> Void {
        for model in serverModels {
            modelContext.delete(model)
        }
    }
    
    func deleteStaticData() -> Void {
        for model in staticInfo {
            modelContext.delete(model)
        }
    }
    
    var body: some View {
        Button("Delete Static Data", action: deleteStaticData)
        Button("Delete Server Data", action: deleteServers)
    }
}

#Preview {
    SettingsView()
}
