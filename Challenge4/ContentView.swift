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
                Text("Nenhum projeto cadastrado")
                    .foregroundColor(.gray)
                    .padding()
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
            Button("Adicionar Projeto"){
                showAddProjectSheet.toggle()
            }
            .sheet(isPresented: $showAddProjectSheet) {
                AddProjectView(coreDataVM: coreDataVM)
            }
        }
    }
}

#Preview {
    ContentView()
}
