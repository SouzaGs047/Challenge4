//import SwiftUI
//import CoreData
//
//struct ContentView2: View {
//    @StateObject var coreDataVM = ProjectViewModel()
//    @State var showAddProjectSheet = false
//    
//    // Define o grid com duas colunas flexíveis
//    let columns = [
//        GridItem(.flexible(), spacing: 16),
//        GridItem(.flexible(), spacing: 16)
//    ]
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                if coreDataVM.savedEntities.isEmpty {
//                    VStack(spacing: 20) {
//                        Image(systemName: "folder.badge.plus")
//                            .font(.system(size: 60))
//                            .foregroundColor(.gray)
//                            .padding(.top, 100)
//                        
//                        Text("Você não está trabalhando em nenhum projeto. Que tal começar um novo?")
//                            .foregroundColor(.gray)
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal, 30)
//                    }
//                } else {
//                    LazyVGrid(columns: columns, spacing: 16) {
//                        ForEach(coreDataVM.savedEntities) { project in
//                            NavigationLink(destination: ProjectView(coreDataVM: coreDataVM, currentProject: project)) {
//                                ProjectCardView(project: project)
//                            }
//                        }
//                    }
//                    .padding()
//                }
//            }
//            .navigationTitle("Projetos")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: { showAddProjectSheet = true }) {
//                        Image(systemName: "plus")
//                            .font(.title3)
//                    }
//                }
//            }
//            .sheet(isPresented: $showAddProjectSheet) {
//                ProjectCreationView(coreDataVM: coreDataVM)
//            }
//        }
//    }
//}
//
//struct ProjectCardView: View {
//    let project: ProjectEntity
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            
//            VStack(alignment: .leading, spacing: 4) {
//                // Nome do projeto
//                Text(project.name ?? "Sem nome")
//                    .font(.headline)
//                    .lineLimit(1)
//                
//            }
//            .padding(.horizontal, 8)
//            .padding(.vertical, 6)
//            
//            // Imagem do projeto
//            if let imageData = project.image, let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: 120)
//                    .clipped()
//            } else {
//                Rectangle()
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(height: 120)
//                    .overlay(
//                        Image(systemName: "photo")
//                            .font(.system(size: 30))
//                            .foregroundColor(.gray)
//                    )
//            }
//            
//   
//        }
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(radius: 2)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
//        )
//    }
//    
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        formatter.locale = Locale(identifier: "pt_BR")
//        return formatter.string(from: date)
//    }
//}
//
////// Preview
////#Preview {
////    ContentView()
////        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
////}
