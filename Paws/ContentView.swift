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
    
    @State private var path = [Pet]()
    @State private var isEditing: Bool = false
    
    let layout = [
        GridItem(.flexible(minimum: 120)),
        GridItem(.flexible(minimum: 120))
    ]
    
    func addPet() {
        isEditing = false
        let pet = Pet(name: "New Pet", photo: nil)
        modelContext.insert(pet)
        path = [pet]
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVGrid(columns: layout) {
                    GridRow {
                        ForEach(pets) { pet in
                            NavigationLink(value: pet) {
                                VStack {
                                    if let imageData = pet.photo {
                                        if let image = UIImage(data: imageData) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))                                        }
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
                                .overlay(alignment: .topTrailing) {
                                    if !isEditing {
                                        Menu {
                                            Button("Delete", systemImage: "trash", role: .destructive) {
                                                withAnimation {
                                                    modelContext.delete(pet)
                                                    do {
                                                        try modelContext.save()
                                                    } catch {
                                                        print("Error saving context after deletion: \(error)")
                                                    }
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "trash.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 32, height: 32)
                                                .foregroundStyle(.red)
                                                .symbolRenderingMode(.multicolor)
                                                .padding(5)
                                        }
                                    }
                                }
                            } //: NAVLINK
                            .foregroundStyle(.primary)
                        } //: LOOP
                    } //: GRIDROW
                } //: GRID LAYOUT
                .padding(.horizontal)
            } //: SCROLLVIEW
            .navigationTitle(pets.isEmpty ? "" : "Paws")
            .navigationDestination(for: Pet.self, destination: EditPetView.init)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            isEditing.toggle()
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add a New Pet", systemImage: "plus.circle", action: addPet)
                }
            }
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
