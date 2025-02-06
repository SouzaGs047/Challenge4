import SwiftUI
import PhotosUI

struct EditProjectFormView: View {
    @EnvironmentObject var coreDataVM: ProjectViewModel
    @ObservedObject var currentProject: ProjectEntity // Novo parâmetro
    
    @StateObject private var colorViewModel = ColorViewModel()
    @StateObject private var fontViewModel = FontViewModel()
    
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
                            .foregroundStyle(.accent)
                        
                        Spacer()
                        
                        Picker("Tipo de Projeto", selection: $coreDataVM.type) {
                            ForEach(projectTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .foregroundStyle(.primary)
                        .disabled(!isSaved) // Desabilita o Picker quando estiver no modo de visualização
                    }
                    
                    // Objetivo do Projeto
                    VStack(alignment: .leading) {
                        Text("Objetivo")
                            .foregroundStyle(.accent)
                        
                        TextEditor(text: $coreDataVM.objective)
                            .frame(height: 100)
                            .scrollContentBackground(.hidden)
                            .disabled(!isSaved) // Desabilita o TextEditor quando estiver no modo de visualização
                    }
                    
                    // Data de início e prazo final
                    HStack(spacing: 20) {
                        DatePickerField(title: "Data de início", date: $coreDataVM.startDate)
                        DatePickerField(title: "Prazo Final", date: $coreDataVM.finalDate)
                    }
                    .disabled(!isSaved) // Desabilita os campos de data quando estiver no modo de visualização
                }
                .padding()
                .cornerRadius(15)
                
                // Branding Section
                DisclosureGroup("Configurações de Branding", isExpanded: $isBrandingExpanded) {
                    BrandingView(colorViewModel: colorViewModel, fontViewModel: fontViewModel)
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
                    isSaved.toggle()
                } else {
                    // Modo de Salvamento: salva os dados
                    saveData()
                }
            }) {
                Text(isSaved ? "Salvar" : "Editar")
                    .bold()
                    .foregroundStyle(.accent)
            }
        )
        .sheet(isPresented: $isImagePickerPresented) {
            // Apresenta o ImagePicker
            ImagePicker(selectedImages: $selectedImages)
        }
    }
    
    func saveData() {
         // Converter imagem para Data
         let imageData = selectedImages.first?.jpegData(compressionQuality: 1.0)
         
         // Atualizar o projeto
         coreDataVM.updateProject(
             currentProject,
             type: coreDataVM.type,
             objective: coreDataVM.objective,
             startDate: coreDataVM.startDate,
             finalDate: coreDataVM.finalDate,
             image: imageData
         )
         
         isSaved.toggle()
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
                        .foregroundStyle(.gray)
                        .frame(width: 200, height: 200)
                }
                
                // Texto explicativo para o usuário
                if selectedImages.isEmpty {
                    Text("Clique para adicionar uma foto")
                        .foregroundStyle(.white)
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
                .foregroundStyle(.accent)
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    EditProjectFormView(selectedImages: .constant([UIImage()]))
//        .environmentObject(ProjectViewModel())
//}
