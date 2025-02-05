//
//  EditProjectView.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 03/02/25.
//

import SwiftUI

struct EditProjectView: View {
    @ObservedObject var currentProject: ProjectEntity
    @State private var selectedImages: [UIImage] = []
    @StateObject private var coreDataVM = ProjectViewModel()

    var body: some View {
        VStack {
            EditProjectFormView(selectedImages: $selectedImages)
                .environmentObject(coreDataVM)
        }
    }
}
