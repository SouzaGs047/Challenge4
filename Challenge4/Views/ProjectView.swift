import SwiftUI

struct ProjectView: View {
    @ObservedObject var coreDataVM = ProjectViewModel()
    @ObservedObject var currentProject: ProjectEntity
    
    @State var selectedTab: Int = 1
    @State private var selectedImages: [UIImage] = []  // Adicionado para gerenciar as imagens selecionadas
    
    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $selectedTab) {
                Text("Logs").tag(1)
                Text("Projeto").tag(2)
            }
            .pickerStyle(.segmented)
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.pink)
            }
            
            TabView(selection: $selectedTab) {
                LogProjectView(currentProject: currentProject)
                    .tag(1)
                
                // Passando o currentProject para o EditProjectFormView
                EditProjectFormView(currentProject: currentProject, selectedImages: $selectedImages)
                    .environmentObject(coreDataVM)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding()
        .navigationTitle(currentProject.name ?? "Sem Título")
    }
}
