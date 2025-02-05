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
            .padding(.horizontal)
            .pickerStyle(.segmented)
            .colorMultiply(.pink)
            
            if selectedTab == 1 {
                LogProjectView(currentProject: currentProject)
            } else {
                EditProjectView(currentProject: currentProject)
            }
        }
        
        .navigationTitle(currentProject.name ?? "Sem Título")
    }
}
