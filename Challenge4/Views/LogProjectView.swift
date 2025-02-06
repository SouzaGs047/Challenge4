import SwiftUI

struct LogProjectView: View {
    @ObservedObject var coreDataVM = ProjectViewModel()
    @ObservedObject var currentProject: ProjectEntity
    @StateObject private var logViewModel = LogViewModel()

    @State private var showDeleteAlert = false
    @State private var logToDelete: LogEntity? // Armazena o log a ser deletado

    var logsArray: [LogEntity] {
        let set = currentProject.logs as? Set<LogEntity> ?? []
        return set.sorted { $0.date ?? Date() > $1.date ?? Date() } // Exibe os mais recentes primeiro
    }

    var body: some View {
        VStack {
            List {
                ForEach(logsArray, id: \.self) { log in
                    NavigationLink(destination: LogDetailView(log: log)) {
                        VStack(alignment: .leading) {
                            Text(log.title ?? "Sem título")
                                .font(.headline)
                            Text(log.textContent ?? "Sem conteúdo")
                                .font(.subheadline)
                                .foregroundStyle(.gray)

                            // Verificar se existem imagens associadas ao log
                            if let imagesSet = log.images as? Set<LogImageEntity>, !imagesSet.isEmpty {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(imagesSet.sorted { $0.imageData?.count ?? 0 > $1.imageData?.count ?? 0 }, id: \.self) { imageEntity in
                                            if let imageData = imageEntity.imageData,
                                               let uiImage = UIImage(data: imageData) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 75, height: 75)
                                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                                    .clipped()
                                            }
                                        }
                                    }
                                }
                            }
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
        }
        .alert("Deletar Log", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Deletar", role: .destructive) {
                if let logToDelete = logToDelete {
                    logViewModel.deleteLog(logToDelete)
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
