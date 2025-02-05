import SwiftUI

struct LogProjectView: View {
    @ObservedObject var coreDataVM = ProjectViewModel()
    @ObservedObject var currentProject: ProjectEntity
    @StateObject private var logViewModel = LogViewModel()
    @State private var refreshID = UUID()

    @State private var showDeleteAlert = false
    @State private var logToDelete: LogEntity? // Armazena o log a ser deletado

    var logsArray: [LogEntity] {
        let set = currentProject.logs as? Set<LogEntity> ?? []
        return set.sorted { $0.date ?? Date() > $1.date ?? Date() } // Agora exibe os mais recentes primeiro
    }


    var body: some View {
        VStack {
            List {
                ForEach(logsArray, id: \.self) { log in
                    NavigationLink(destination: LogDetailView(log: log, onLogUpdated: {
                        refreshID = UUID()
                    })) {
                        VStack(alignment: .leading) {
                            Text(log.title ?? "Sem título")
                                .font(.headline)
                            Text(log.textContent ?? "Sem conteúdo")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            logToDelete = log  // Armazena o log para exclusão
                            showDeleteAlert = true
                        } label: {
                            Label("Deletar", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .id(refreshID)
        }
        .alert("Deletar Log", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Deletar", role: .destructive) {
                if let logToDelete = logToDelete {
                    logViewModel.deleteLog(logToDelete)
                    refreshID = UUID() // Atualiza a lista
                }
            }
        } message: {
            Text("Tem certeza que deseja deletar este log?")
        }
        .toolbar {
            NavigationLink(destination: AddLogView(currentProject: currentProject)) {
                Text("Adicionar Log")
            }
        }
    }
}
