//
//  EditProjectView.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 03/02/25.
//

import SwiftUI

struct EditProjectView: View {
    
    @ObservedObject var currentProject: ProjectEntity
    @State private var isEditing = false
    @State private var selectedDesignType: String = "Design de Jogos"
    
    let designTypes = [
        "Design de Jogos",
        "Design de Interfaces",
        "Design de Marca",
        "Design de Motion",
        "Design de Animação"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Placeholder da Imagem do Projeto
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray.opacity(0.3))
                
                // Picker para Seleção do Tipo de Design
                Picker("Tipo de Design", selection: $selectedDesignType) {
                    ForEach(designTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                // Datas de Início e Finalização do Projeto
                HStack {
                    VStack(alignment: .leading) {
                        Text("Data de Criação")
                        DatePicker("", selection: Binding(
                            get: { currentProject.startDate ?? Date() },
                            set: { currentProject.startDate = $0 }
                        ), displayedComponents: .date)
                        .disabled(!isEditing)
                    }
                    
                    VStack {
                        Text("Prazo Final")
                        DatePicker("", selection: Binding(
                            get: { currentProject.finalDate ?? Date() },
                            set: { currentProject.finalDate = $0 }
                        ), displayedComponents: .date)
                        .disabled(!isEditing)
                    }
                }
                
                // Branding View
                BrandingView()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Editar Projeto")
            .toolbar {
                Button(isEditing ? "Salvar" : "Editar") {
                    isEditing.toggle()
                    if !isEditing {
                        // Aqui você pode adicionar a lógica para salvar os dados editados
                    }
                }
            }
        }
    }
}
