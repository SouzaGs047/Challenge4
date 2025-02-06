import SwiftUI

struct ProjectView: View {
    @ObservedObject var coreDataVM = ProjectViewModel()
    @ObservedObject var currentProject: ProjectEntity
    
    @State private var selectedTab: Int = 1
    
    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $selectedTab) {
                Text("Logs").tag(1)
                Text("Projeto").tag(2)
            }
            .pickerStyle(.segmented)
            
            .padding(.horizontal)
            .background(Color.white) // Define o fundo como branco para a aba selecionada
            .cornerRadius(10) // Arredonda as bordas
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.accent // Aba selecionada branca
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected) // Texto preto na aba selecionada
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal) // Texto branco na aba não selecionada
            }
            
            if selectedTab == 1 {
                LogProjectView(currentProject: currentProject)
            } else {
                EditProjectView(currentProject: currentProject)
                    .environmentObject(coreDataVM)
            }
        }
        .navigationTitle(currentProject.name ?? "Sem Título")
    }
}
