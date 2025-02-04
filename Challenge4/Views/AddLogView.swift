import SwiftUI

struct AddLogView: View {
    var coreDataVM = LogViewModel()
    @ObservedObject var currentProject: ProjectEntity
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedOption: String?
    @State private var textContentLog: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false
    
    @State private var showDeleteAlert = false // Novo state para o alerta
        @State private var logToDelete: LogEntity? // Novo state para armazenar o log a ser deletado
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    
    let topics = [
        "Anotação", "Lousa", "Marca", "Pesquisa",
        "Progresso", "Referências", "Testes",
        "Visita Técnica", "Outros"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Menu de tópicos
                Menu {
                    ForEach(topics, id: \.self) { topic in
                        Button(topic) {
                            selectedOption = topic
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedOption ?? "O que você quer registrar agora?")
                            .foregroundColor(.pink)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // TextEditor para digitar o log
                TextEditor(text: $textContentLog)
                    .placeholder(when: textContentLog.isEmpty) {
                        Text("Clique aqui para digitar")
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: 200)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // Imagens
                VStack(spacing: 0) {
                    HStack(spacing: 4) {
                        Text("Imagens")
                            .foregroundColor(.pink)
                            .font(.system(size: 20, weight: .bold))
                            .padding(.trailing, 60.0)
                        Spacer()
                        
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Clique aqui para adicionar")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                    .clipped()
                            }
                        }
                        .padding()
                    }
                }
                .padding(.bottom)
            }
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(selectedImages: $selectedImages)
            }
            .navigationTitle("Adicionar Log") // Título da navegação
            .toolbar {
                // Adiciona o botão "Salvar Log" na toolbar, alinhado à direita
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar Log") {
                        guard let topic = selectedOption, !textContentLog.isEmpty else { return }
                        
                        let imagesData = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
                        
                        coreDataVM.addLog(to: currentProject,
                                          title: topic,
                                          textContent: textContentLog,
                                          imagesData: imagesData)
                        
                        dismiss()
                    }
                    .foregroundColor(.pink)
                }
            }
        }
        .alert("Deletar Log", isPresented: $showDeleteAlert) {
                        Button("Cancelar", role: .cancel) {}
                        Button("Deletar", role: .destructive) {
                            if let logToDelete = logToDelete {
                                coreDataVM.deleteLog(logToDelete)
                            }
                        }
                    } message: {
                        Text("Tem certeza que deseja deletar este log?")
                    }
    }
    
    
}



extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    AddLogView(currentProject: ProjectEntity())
}
