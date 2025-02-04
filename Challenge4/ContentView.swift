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
    
    var body: some View {
        VStack(spacing: 20) {
            if coreDataVM.savedEntities.isEmpty {
                Text("Você não está trabalhando em nenhum projeto. Que tal começar um novo?")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 30)
            } else {
                List {
                    ForEach(coreDataVM.savedEntities) { entity in
                        NavigationLink(destination: ProjectView(coreDataVM: coreDataVM, currentProject: entity)) {
                            Text(entity.name ?? "NO NAME")
                        }
                    }
                    .onDelete(perform: coreDataVM.deleteProject)
                }
                .listStyle(PlainListStyle())
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
    
    #Preview {
        ContentView()
    }

