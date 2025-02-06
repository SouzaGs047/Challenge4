import SwiftUI
import PhotosUI

struct EditProjectFormView: View {
    @EnvironmentObject var coreDataVM: ProjectViewModel
    @Environment(\.presentationMode) var presentationMode // Adiciona o environment para controle de navegação
    @ObservedObject var currentProject: ProjectEntity
    @Binding var selectedImages: [UIImage]
    
    @State private var isEditing = false
    @State private var isBrandingExpanded = false
    @State private var isImagePickerPresented = false
    
    @State private var isShowingDeleteAlert = false // Estado para controlar o alerta

    private let projectTypes = [
        "UX/UI Design",
        "Design de Jogos",
        "Design de Interfaces",
        "Design de Marca",
        "Design de Motion",
        "Design de Animação",
        "Outros"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isEditing {
                    editingView
                } else {
                    viewingView
                }
            }
            .padding()
        }
        .navigationBarItems(trailing: Button(action: {
            if isEditing {
                saveData()
            }
            isEditing.toggle()
        }) {
            Text(isEditing ? "Salvar" : "Editar")
                .bold()
                .foregroundColor(.pink)
        })
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImages: $selectedImages)
        }
        .alert("Deletar Projeto", isPresented: $isShowingDeleteAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Deletar", role: .destructive) {
                    deleteProject() // Chama a função para deletar o projeto
                }
            } message: {
                Text("Tem certeza que deseja deletar este projeto? Esta ação não pode ser desfeita.")
            }
        .onAppear {
            loadProjectData()
        }
    }
    
    private func deleteProject() {
        coreDataVM.deleteProject(currentProject) // Deleta o projeto
        // Dismiss a tela e retorna à lista de projetos
        presentationMode.wrappedValue.dismiss()
    }
    
    private var editingView: some View {
        VStack(spacing: 20) {
            ImageView(selectedImages: $selectedImages)
                .onTapGesture {
                    isImagePickerPresented.toggle()
                }
            
            Group {
                HStack {
                       Text("Tipo")
                           .foregroundColor(.pink) // Cor da label, que pode ser personalizada conforme necessário
                       
                       Spacer()
                       
                       Picker("Tipo de Projeto", selection: $coreDataVM.type) {
                           Text("Escolha um tipo")
                               .foregroundColor(.gray) // Cor do texto de aviso
                               .tag("") // Valor de tag vazio para representar a opção inicial
                           
                           
                           ForEach(projectTypes, id: \.self) { type in
                               Text(type)
                                   .tag(type) // Associa as tags aos tipos de projeto
                           }
                       }
                       .pickerStyle(MenuPickerStyle()) // Estilo de menu para o Picker, ajustando automaticamente ao sistema
                       
                   }
                .padding()
                .background(Color.second)
                .cornerRadius(10)


                
                VStack(alignment: .leading) {
                    Text("Objetivo")
                        .foregroundColor(.pink)
                    
                    TextEditor(text: $coreDataVM.objective)
                        .frame(height: 100)
                        .scrollContentBackground(.hidden)
                        .foregroundColor(.white) // Garante que o texto seja branco

                        
                }
                .padding()
                .background(Color.second)
                .cornerRadius(10)

                
                HStack(spacing: 20) {
                    DatePickerField(title: "Data de início", date: $coreDataVM.startDate)
                        .padding()
                        .background(Color.second)
                        .cornerRadius(10)

                    DatePickerField(title: "Prazo Final", date: $coreDataVM.finalDate)
                        .padding()
                        .background(Color.second)
                        .cornerRadius(10)

                }
               
            }
            .padding()
            
            DisclosureGroup("Configurações de Branding", isExpanded: $isBrandingExpanded) {
                BrandingView()
            }
            .padding()
            .background(Color.second)
            .cornerRadius(10)
            
            Button(action: {
                isShowingDeleteAlert = true // Exibe o alerta de confirmação
            }) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(.white) // Cor do ícone ajustada para branco
                    Text("Deletar Projeto")
                        .foregroundColor(.white) // Cor do texto ajustada para branco
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red) // Cor de fundo vermelha
                .cornerRadius(10)
            }
            .padding(.horizontal)

        }
    }
    
    private func loadProjectData() {
        coreDataVM.type = currentProject.type ?? ""
        coreDataVM.objective = currentProject.objective ?? ""
        coreDataVM.startDate = currentProject.startDate ?? Date()
        coreDataVM.finalDate = currentProject.finalDate ?? Date()
        
        if let imageData = currentProject.image, let image = UIImage(data: imageData) {
            selectedImages = [image]
        }
    }
    
    private func saveData() {
        let imageData = selectedImages.first?.jpegData(compressionQuality: 1.0) // Qualidade máxima para evitar perda de detalhes
        coreDataVM.updateProject(
            currentProject,
            type: coreDataVM.type,
            objective: coreDataVM.objective,
            startDate: coreDataVM.startDate,
            finalDate: coreDataVM.finalDate,
            image: imageData
        )
    }

    private var viewingView: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let firstImage = selectedImages.first {
                Image(uiImage: firstImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal) // Adiciona um padding horizontal para centralizar
                    .frame(maxWidth: .infinity) // Faz com que o conteúdo ocupe toda a largura disponível
            } else {
                Image("DefaultImage") // Substitua pelo nome real da sua imagem padrão
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.gray) // Caso a imagem seja um SF Symbol
                    .padding(.horizontal) // Adiciona um padding horizontal para centralizar
                    .frame(maxWidth: .infinity) // Faz com que o conteúdo ocupe toda a largura disponível
            }
            
            Group {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tipo")
                        .foregroundColor(.pink)
                        .font(.headline)
                    Text(currentProject.type?.isEmpty == false ? currentProject.type! : "Não definido")
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Objetivo")
                        .foregroundColor(.pink)
                        .font(.headline)
                    Text(currentProject.objective?.isEmpty == false ? currentProject.objective! : "Não definido")
                }
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Data de início")
                            .foregroundColor(.pink)
                            .font(.headline)
                        Text(formatDate(currentProject.startDate))
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Prazo Final")
                            .foregroundColor(.pink)
                            .font(.headline)
                        Text(formatDate(currentProject.finalDate))
                    }
                }
            }
            .padding()
        }
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Não definida" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
}


// Componente para exibir a imagem com texto explicativo
struct ImageView: View {
    @Binding var selectedImages: [UIImage]
    
    var body: some View {
        VStack {
            ZStack {
                if let firstImage = selectedImages.first {
                    Image(uiImage: firstImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .contentShape(Rectangle()) // Garante que apenas a imagem é clicável

                } else {
                    Image("DefaultImage")
                        .resizable()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                        .frame(width: 200, height: 200)
                        .contentShape(Rectangle()) // Mesmo para a imagem padrão

                }
                
                if selectedImages.isEmpty {
                    Text("Clique para adicionar uma foto")
                        .foregroundColor(.white)
                        .font(.caption)
                        .bold()
                        .padding(5)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(5)
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

// Componente para o campo de DataPicker
struct DatePickerField: View {
    let title: String
    @Binding var date: Date
     
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.pink)
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}
