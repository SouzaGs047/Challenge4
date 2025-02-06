//
//  EditProjectView.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 03/02/25.
//

import SwiftUI

struct EditProjectView: View {
    @State private var selectedImages: [UIImage] = []  // Alterado para um array de UIImage
    @StateObject private var coreDataVM = ProjectViewModel()

    var body: some View {
        VStack {
            EditProjectFormView(selectedImages: $selectedImages)  // Alteração aqui também para passar selectedImages
                .environmentObject(coreDataVM)
        }
    }
}

#Preview {
    EditProjectView()
}
