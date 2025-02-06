//
//  EditProjectView.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 03/02/25.
//

import SwiftUI

struct EditProjectView: View {
    @ObservedObject var currentProject: ProjectEntity
    @StateObject private var coreDataVM: ProjectViewModel
    @State private var selectedImages: [UIImage] = []
    
    init(currentProject: ProjectEntity) {
        self.currentProject = currentProject
        _coreDataVM = StateObject(wrappedValue: ProjectViewModel())
    }

    var body: some View {
        EditProjectFormView(
            currentProject: currentProject, selectedImages: $selectedImages
            
        )
        .environmentObject(coreDataVM)
        .onAppear {
        
            coreDataVM.loadProjectData(project: currentProject)
           
            if let imageData = currentProject.image {
                selectedImages = [UIImage(data: imageData)].compactMap { $0 }
            }
        }
    }
}
