//
//  ContentView.swift
//  Paws
//
//  Created by Nicola Buompane on 28/03/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var pets: [Pet]
    var body: some View {
        NavigationStack {
            ScrollView {
                EmptyView()
            } //: SCROLLVIEW
            .overlay {
                if pets.isEmpty {
                    CustomContentUnavailableView(icon: "dog.circle", title: "No pets found", description: "Add your first pet")
                }
            }
        } //: NAVSTAK
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Pet.self)
}
