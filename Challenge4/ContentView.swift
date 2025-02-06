import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var coreDataVM = ProjectViewModel()
    @State var showAddProjectSheet = false
    @State private var isShowingDeleteAlert = false // Para controlar o alerta de confirmação
    @State private var projectToDelete: ProjectEntity? = nil // Projeto a ser deletado
    
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
                    .onDelete { indexSet in
                        // Captura o projeto que será deletado
                        if let firstIndex = indexSet.first {
                            projectToDelete = coreDataVM.savedEntities[firstIndex]
                            isShowingDeleteAlert = true // Exibe o alerta
                        }
                    }
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
        .alert("Deletar Projeto", isPresented: $isShowingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Deletar", role: .destructive) {
                if let project = projectToDelete {
                    coreDataVM.deleteProject(project) // Deleta o projeto selecionado
                }
            }
        } message: {
            Text("Tem certeza que deseja deletar este projeto? Esta ação não pode ser desfeita.")
        }
    }
}
