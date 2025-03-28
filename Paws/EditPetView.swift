//
//  EditPetView.swift
//  Paws
//
//  Created by Nicola Buompane on 28/03/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditPetView: View {
    @Bindable var pet: Pet
    @State private var photosPickerItem: PhotosPickerItem?
    var body: some View {
        Form {
            // MARK: IMAGE
            if let imageData = pet.photo {
                if let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                        .frame(minWidth: 0,maxWidth: .infinity, minHeight: 0, maxHeight: 300)
                        .padding(.top)
                }
            } else {
                CustomContentUnavailableView(icon: "pawprint.circle", title: "No Photo", description: "Add a photo of your pet")
                    .padding(.top)
            }
            
            // MARK: PHOTO PICKER
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                Label("Select a Photo", systemImage: "photo.badge.plus")
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .listRowSeparator(.hidden)
            
            // MARK: TEXT FIELD
            TextField("Name", text: $pet.name)
                .textFieldStyle(.roundedBorder)
                .font(.largeTitle.weight(.light))
                .padding(.vertical)
            
            // MARK: BUTTON
            Button {
                
            } label: {
                Text("Save")
                    .font(.title3.weight(.medium))
                    .padding(8)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .listRowSeparator(.hidden)
            .padding(.bottom)

        } //: FORM
        .listStyle(.plain)
        .navigationTitle("Edit \(pet.name)")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: photosPickerItem) {
            Task {
                pet.photo = try? await photosPickerItem?.loadTransferable(type: Data.self)
            }
        }
    }
}

#Preview {
    NavigationStack {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Pet.self, configurations: config)
            let samplePets = Pet(name: "Max")
            
            return EditPetView(pet: samplePets)
                .modelContainer(container)
        } catch {
            fatalError("Cloud not load data: \(error.localizedDescription)")
        }
    }
}
