//
//  SettingsView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 13/09/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    
    func deleteServers() -> Void {
        do {
            try modelContext.delete(model: ServerModel.self)
        } catch {}
    }
    var body: some View {
        Button("Delete All Servers", action: deleteServers)
    }
}

#Preview {
    SettingsView()
}
