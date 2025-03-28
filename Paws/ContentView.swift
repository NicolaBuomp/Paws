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
    
    let layout = [
        GridItem(.flexible(minimum: 120)),
        GridItem(.flexible(minimum: 120))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: layout) {
                    GridRow {
                        ForEach(pets) { pet in
                            NavigationLink(destination: EmptyView()) {
                                VStack {
                                    if let imageData = pet.photo {
                                        if let image = UIImage(data: imageData) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 120, height: 120)
                                        }
                                    } else {
                                        Image(systemName: "pawprint.circle")
                                             .resizable()
                                             .scaledToFit()
                                             .padding(40)
                                             .foregroundStyle(.quaternary)
                                     }
                                    
                                    
                                    Spacer()
                                    
                                    Text(pet.name)
                                        .font(.title.weight(.light))
                                        .padding(.vertical)
                                    
                                    Spacer()
                                } //: VSTACK
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                            } //: NAVLINK
                            .foregroundStyle(.primary)
                        } //: LOOP
                    } //: GRIDROW
                } //: GRID LAYOUT
                .padding(.horizontal)
            } //: SCROLLVIEW
            .navigationTitle(pets.isEmpty ? "" : "Paws")
            .overlay {
                if pets.isEmpty {
                    CustomContentUnavailableView(icon: "dog.circle", title: "No pets found", description: "Add your first pet")
                }
            }
        } //: NAVSTAK
    }
}

#Preview("Empty View") {
    ContentView()
        .modelContainer(for: Pet.self)
}

#Preview("Simple List") {
    ContentView()
        .modelContainer(Pet.preview)
}
