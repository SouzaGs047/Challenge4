import SwiftUI

struct ProjectView: View {
    @ObservedObject var coreDataVM = ProjectViewModel()
    @ObservedObject var currentProject: ProjectEntity
    
    @State var selectedTab: Int = 1
    
    var body: some View {
        VStack(spacing: 16) {
       
            Text("Linha")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
                    
                    EditProjectView(currentProject: currentProject)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding()
        .navigationTitle(currentProject.name ?? "Sem Título")
    }
}
