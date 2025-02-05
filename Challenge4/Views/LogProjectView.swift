import SwiftUI

struct LogProjectView: View {
    @ObservedObject var coreDataVM = ProjectViewModel()
    @ObservedObject var currentProject: ProjectEntity
    @StateObject private var logViewModel = LogViewModel()
    @State private var refreshID = UUID()
    @State private var searchText = ""
    @State private var sortOption: String = "Data, mais recente"
    @State private var showDeleteAlert = false
    @State private var logToDelete: LogEntity?
    
    let sortOptions = [
        "Data, mais recente",
        "Data, mais antiga",
        "Título (A-Z)",
        "Título (Z-A)"
    ]
    
    var logsArray: [LogEntity] {
        let set = currentProject.logs as? Set<LogEntity> ?? []
        let sortedLogs: [LogEntity]
        
        switch sortOption {
        case "Data, mais recente":
            sortedLogs = set.sorted { $0.date ?? Date() > $1.date ?? Date() }
        case "Data, mais antiga":
            sortedLogs = set.sorted { $0.date ?? Date() < $1.date ?? Date() }
        case "Título (A-Z)":
            sortedLogs = set.sorted { ($0.title ?? "").localizedCaseInsensitiveCompare($1.title ?? "") == .orderedAscending }
        case "Título (Z-A)":
            sortedLogs = set.sorted { ($0.title ?? "").localizedCaseInsensitiveCompare($1.title ?? "") == .orderedDescending }
        default:
            sortedLogs = set.sorted { $0.date ?? Date() > $1.date ?? Date() }
        }
        
        return sortedLogs.filter { log in
            searchText.isEmpty || (log.title?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    var groupedLogs: [String: [LogEntity]] {
        Dictionary(grouping: logsArray) { log in
            let logDate = log.date ?? Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: logDate) == formatter.string(from: Date()) ? "Hoje" : "Ontem"
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Picker("Organizar por", selection: $sortOption) {
                    ForEach(sortOptions, id: \..self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
            
                
                TextField("Buscar...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            ScrollView {
                ForEach(["Hoje", "Ontem"], id: \..self) { section in
                    if let logs = groupedLogs[section], !logs.isEmpty {
                        Text(section)
                            .font(.title2)
                            .bold()
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(logs, id: \.self) { log in
                            NavigationLink(destination: LogDetailView(log: log, onLogUpdated: {
                                refreshID = UUID()
                            })) {
                                VStack(alignment: .leading) {
                                    Text(log.title ?? "Sem título")
                                        .font(.headline)
                                    Text(log.textContent ?? "Sem conteúdo")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                    
                                    if let images = log.images as? Set<LogImageEntity>, !images.isEmpty {
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(Array(images), id: \.self) { imageEntity in
                                                    if let imageData = imageEntity.imageData, let uiImage = UIImage(data: imageData) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 100, height: 100)
                                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    }
                                                }
                                            }
                                        }
                                        .frame(height: 110)
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
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
                
                if logsArray.isEmpty {
                    Text("Nenhum log encontrado.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .id(refreshID)
        }
        .alert("Deletar Log", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Deletar", role: .destructive) {
                if let logToDelete = logToDelete {
                    logViewModel.deleteLog(logToDelete)
                    refreshID = UUID()
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
