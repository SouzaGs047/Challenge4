import SwiftUI

struct AddLogView: View {
    @StateObject var coreDataVM = LogViewModel()
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
                        .stroke(.white, lineWidth: 1)
                )
                
            }
            .padding(.horizontal)
            
            // TextEditor para digitar o log
            Divider()
            
            VStack {
                ZStack(alignment: .topLeading) {
                    // Placeholder: só é exibido se o texto estiver vazio
                    
                    
                    // TextEditor para entrada de texto multilinha
                    TextEditor(text: $textContentLog)
                        .foregroundColor(.black)
                        .padding(8)
                    // Opcional: para alinhar o texto à esquerda (iOS 16+)
                        .multilineTextAlignment(.leading)
                    if textContentLog.isEmpty {
                        Text("Clique aqui para digitar")
                            .foregroundColor(.gray)
                            .padding(.vertical,16)
                            .padding(.horizontal,11)
                    }
                }
                .frame(height: 200)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("rosaPreto")) // Certifique-se de ter essa cor definida ou substitua por outra
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
                
                //           TextEditor(text: $textContentLog)
                //              .placeholder(when: textContentLog.isEmpty) {
                //                  Text("Clique aqui para digitar")
                //                        .foregroundStyle(.white)
                //}
                //               .padding(.vertical, 5)
                //               .padding(.horizontal)
                //               .scrollContentBackground(.hidden)
                //              .background(
                //                   RoundedRectangle(cornerRadius: 8)
                //                        .fill(.rosaPreto) // Fundo com canto arredondado
                //)
                //              .frame(height: 250)
                //                .padding(.horizontal)
                
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
