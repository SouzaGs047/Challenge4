import SwiftUI

struct AddLogView: View {
    @StateObject var coreDataVM = LogViewModel()
    @ObservedObject var currentProject: ProjectEntity
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedOption: String?
    @State private var textContentLog: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false
    
    @State private var showDeleteAlert = false
    @State private var logToDelete: LogEntity?
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    
    let topics = [
        "Anotação", "Lousa", "Marca", "Pesquisa",
        "Progresso", "Referências", "Testes",
        "Visita Técnica", "Outros"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Divider()
            Menu {
                ForEach(topics, id: \.self) { topic in
                    Button(topic) {
                        selectedOption = topic
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption ?? "O que você quer registrar agora?")
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.primary)
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.linha, lineWidth: 1)
                )
                
            }
            
            .padding(.horizontal)
            
            Divider()
            
            VStack {
                ZStack(alignment: .topLeading) {
                   
                    TextEditor(text: $textContentLog)
                        .foregroundColor(Color(.white))
                        .padding(8)
                        .multilineTextAlignment(.leading)
                    if textContentLog.isEmpty {
                        Text("Clique aqui para digitar")
                            .foregroundColor(.gray)
                            .padding(.vertical,16)
                            .padding(.horizontal,11)
                    }
                }
                .frame(height: 200)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.rosaPreto)
                )
                .padding(.horizontal)

                Divider()
                    .padding()
                HStack{
                    Text("Imagens")
                        .foregroundStyle(.accent)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.trailing, 60.0)
                    Spacer()
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Clique aqui para adicionar")
                            .foregroundStyle(.gray)
                            .font(.system(size: 16))
                    }
                }
                .padding(.horizontal)
                
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
            
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(selectedImages: $selectedImages)
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationTitle("Escrever Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Registrar") {
                        guard let topic = selectedOption, !textContentLog.isEmpty else { return }
                        
                        let imagesData = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
                        
                        coreDataVM.addLog(to: currentProject,
                                          title: topic,
                                          textContent: textContentLog,
                                          imagesData: imagesData)
                        
                        dismiss()
                    }
                    .foregroundStyle(.accent)
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
