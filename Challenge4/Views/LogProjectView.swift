import SwiftUI

struct LogProjectView: View {
    @ObservedObject var currentProject: ProjectEntity
    @StateObject private var logViewModel = LogViewModel()
    
    @State private var showDeleteAlert = false
    @State private var logToDelete: LogEntity?
    @State private var searchText = ""
    
    var logsArray: [LogEntity] {
        let set = currentProject.logs as? Set<LogEntity> ?? []
        return set.sorted { $0.date ?? Date() > $1.date ?? Date() }
    }
    
    var filteredLogs: [LogEntity] {
        guard !searchText.isEmpty else { return logsArray }
        return logsArray.filter {
            ($0.title?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            ($0.textContent?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    var groupedLogs: [String: [LogEntity]] {
        Dictionary(grouping: filteredLogs) { log in
            formattedDate(log.date ?? Date())
        }
    }
    
    var body: some View {
        VStack {
            TextField("Buscar logs", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List {
                ForEach(groupedLogs.keys.sorted(by: { $0 > $1 }), id: \ .self) { dateKey in
                    Section(header: Text(dateKey).font(.headline)) {
                        ForEach(groupedLogs[dateKey] ?? [], id: \ .self) { log in
                            NavigationLink(destination: LogDetailView(log: log)) {
                                VStack(alignment: .leading) {
                                    Text(log.title ?? "Sem título")
                                        .font(.headline)
                                    Text(log.textContent ?? "Sem conteúdo")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                    
                                    if let imagesSet = log.images as? Set<LogImageEntity>, !imagesSet.isEmpty {
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(imagesSet.sorted { $0.imageData?.count ?? 0 > $1.imageData?.count ?? 0 }, id: \ .self) { imageEntity in
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
                                    logToDelete = log
                                    showDeleteAlert = true
                                } label: {
                                    Label("Deletar", systemImage: "trash")
                                }
                            }
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
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "d 'de' MMMM 'de' yyyy"
        return dateFormatter.string(from: date)
    }
}
