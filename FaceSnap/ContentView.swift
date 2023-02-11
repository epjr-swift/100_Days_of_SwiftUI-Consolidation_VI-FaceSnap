//
//  ContentView.swift
//  FaceSnap
//
//  Created by Edwin Przeźwiecki Jr. on 11/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var users = SharedPeople()
    
    @State private var showingImagePicker = false
    @State private var askingForUsername = false
    
    @State private var inputImage: UIImage?
    
    @State private var photoID: String?
    @State private var username: String?
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedFaces")
    
    var body: some View {
        NavigationView {
            Form {
                List(users.personDetails.sorted()) { person in
                    HStack {
                        Image("\(person.photoID)")
                        
                        Text(person.name)
                    }
                }
                .padding()
            }
            .navigationTitle("FaceSnap")
            .toolbar {
                Button {
                    addUser()
                } label: {
                    Label("Add User", systemImage: "plus")
                }
            }
            .onChange(of: inputImage) { _ in
                if let jpegData = inputImage?.jpegData(compressionQuality: 0.8) {
                    let uuid = UUID().uuidString
                    
                    photoID = uuid
                    
                    try? jpegData.write(to: savePath.appendingPathComponent(uuid), options: [.atomic, .completeFileProtection])
                    
                    askingForUsername = true
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .sheet(isPresented: $askingForUsername) {
                PersonNameView()
            }
        }
    }
    
    func addUser() {
        users.personDetails.append(Person.example)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
