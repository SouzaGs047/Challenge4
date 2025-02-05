import SwiftUI

struct ProjectView: View {
    @ObservedObject var coreDataVM = ProjectViewModel()
    @ObservedObject var currentProject: ProjectEntity
    
    @State var selectedTab: Int = 1
    
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
                
                EditProjectView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding()
        .navigationTitle(currentProject.name ?? "Sem Título")
    }
}
