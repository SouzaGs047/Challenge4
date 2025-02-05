import SwiftUI
import PhotosUI

struct EditProjectFormView: View {
    @EnvironmentObject var coreDataVM: ProjectViewModel
    @ObservedObject var currentProject: ProjectEntity  // Adiciona o currentProject aqui
    @Binding var selectedImages: [UIImage]  // Alteração para um array de UIImage
    
    @State private var isBrandingExpanded = false
    @State private var isSaved = false  // Novo estado para alternar entre editar e salvar
    @State private var isImagePickerPresented = false  // Para controlar a exibição do ImagePicker
    
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
                // Exibição da Imagem com texto explicativo
                ImageView(selectedImages: $selectedImages)
                    .onTapGesture {
                        // Lógica para selecionar uma nova foto
                        isImagePickerPresented.toggle()
                    }
                
                // Formulário
                Group {
                    // Tipo do Projeto
                    HStack {
                        Text("Tipo")
                            .foregroundColor(.pink)
                        
                        Spacer()
                        
                        Picker("Tipo de Projeto", selection: $coreDataVM.type) {
                            ForEach(projectTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(.primary)
                        .disabled(isSaved) // Desabilita o Picker quando estiver no modo de visualização
                    }
                    
                    // Objetivo do Projeto
                    VStack(alignment: .leading) {
                        Text("Objetivo")
                            .foregroundColor(.pink)
                        
                        TextEditor(text: $coreDataVM.objective)
                            .frame(height: 100)
                            .scrollContentBackground(.hidden)
                            .disabled(isSaved) // Desabilita o TextEditor quando estiver no modo de visualização
                    }
                    
                    // Data de início e prazo final
                    HStack(spacing: 20) {
                        DatePickerField(title: "Data de início", date: $coreDataVM.startDate)
                        DatePickerField(title: "Prazo Final", date: $coreDataVM.finalDate)
                    }
                    .disabled(isSaved) // Desabilita os campos de data quando estiver no modo de visualização
                }
                .padding()
                .cornerRadius(15)
                
                // Branding Section
                DisclosureGroup("Configurações de Branding", isExpanded: $isBrandingExpanded) {
                    BrandingView()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .animation(.easeInOut, value: isBrandingExpanded)
            }
            .padding()
        }
        .navigationBarItems(
            trailing: Button(action: {
                if isSaved {
                    // Modo de Edição: muda para o modo de edição
                    isSaved = false
                } else {
                    // Modo de Salvamento: salva os dados
                    saveData()
                }
            }) {
                Text(isSaved ? "Editar" : "Salvar")
                    .bold()
                    .foregroundColor(.pink)
            }
        )
        .sheet(isPresented: $isImagePickerPresented) {
            // Apresenta o ImagePicker
            ImagePicker(selectedImages: $selectedImages)
        }
    }
    
    // Função para salvar os dados
    func saveData() {
        // Aqui você pode implementar a lógica de salvar os dados (como uma chamada a CoreData ou API)
        // Exemplo de salvamento de dados:
        print("Dados salvos:")
        print("Tipo: \(coreDataVM.type)")
        print("Objetivo: \(coreDataVM.objective)")
        print("Data de Início: \(coreDataVM.startDate)")
        print("Prazo Final: \(coreDataVM.finalDate)")
        
        // Depois de salvar os dados, altere o estado para 'salvo'
        isSaved = true
    }
}

// Componente para exibir a imagem com texto explicativo
struct ImageView: View {
    @Binding var selectedImages: [UIImage]  // Alteração para um array de UIImage
    
    var body: some View {
        VStack {
            ZStack {
                if let firstImage = selectedImages.first {
                    Image(uiImage: firstImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Image("DefaultImage")
                        .resizable()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                        .frame(width: 200, height: 200)
                }
                
                // Texto explicativo para o usuário
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

//#Preview {
//    EditProjectFormView(selectedImages: .constant([UIImage()]))
//        .environmentObject(ProjectViewModel())
//}
