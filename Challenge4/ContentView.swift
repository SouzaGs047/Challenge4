//
//  ContentView.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 29/01/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var coreDataVM = ProjectViewModel()
    @State var showAddProjectSheet = false
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var showDeleteAlert = false
    @State private var projectToDelete: ProjectEntity?
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                if coreDataVM.savedEntities.isEmpty {
                    Text("Você não está trabalhando em nenhum projeto. Que tal começar um novo?")
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 30)
                        .multilineTextAlignment(.center)

                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(coreDataVM.savedEntities) { entity in
                                NavigationLink(destination: ProjectView(coreDataVM: coreDataVM, currentProject: entity)) {
                                    VStack {
                                        if let imageData = entity.image,
                                           let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                                .clipped()
                                        } else {
                                            Image("DefaultImage")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        Text(entity.name ?? "Sem Nome")
                                            .bold()
                                    }
                                    .padding()
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        projectToDelete = entity
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Excluir", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }

                }
            }
            .navigationTitle("Projetos")
            .alert("Deletar Projeto", isPresented: $showDeleteAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Deletar", role: .destructive) {
                    if let projectToDelete = projectToDelete {
                        coreDataVM.deleteProject(projectToDelete)
                    }
                }
            } message: {
                Text("Tem certeza que deseja deletar este projeto?")
            }
            .toolbar {
                Button("Criar projeto") {
                    showAddProjectSheet.toggle()
                }
            }
            .sheet(isPresented: $showAddProjectSheet) {
                AddProjectView(coreDataVM: coreDataVM)
            }
            .onAppear {
                coreDataVM.fetchProjects() 
            }
        }
    }
}

//    #Preview {
//        ContentView()
//    }
