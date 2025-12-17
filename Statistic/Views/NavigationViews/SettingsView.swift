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
        do {
            try modelContext.delete(model: ServerModel.self)
        } catch {}
    }
    
    func deleteStaticData() -> Void {
        do {
            try modelContext.delete(model: StaticServerInformationModel.self)
        } catch {}
    }
    
    var body: some View {
        Text("These settings are meant only for development.")
        Button("Delete Static Data", action: deleteStaticData)
        Button("Delete Server Data", action: deleteServers)
    }
}

#Preview {
    SettingsView()
}
