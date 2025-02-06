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
    
    var body: some View {
        VStack(spacing: 20) {
            if coreDataVM.savedEntities.isEmpty {
                Text("Você não está trabalhando em nenhum projeto. Que tal começar um novo?")
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 30)
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
                                        Text(entity.name ?? "NO NAME")
                                            .bold()
                                    } else {
                                        Color.gray
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        coreDataVM.deleteProject(entity)
                                    } label: {
                                        Label("Excluir", systemImage: "trash")
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                .navigationTitle("Projetos")
                .toolbar {
                    Button("Criar projeto"){
                        showAddProjectSheet.toggle()
                    }
                    .sheet(isPresented: $showAddProjectSheet) {
                        AddProjectView(coreDataVM: coreDataVM)
                    }
                    
                }
            }
        }
    }
}

//    #Preview {
//        ContentView()
//    }
