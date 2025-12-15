import SwiftUI
struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        themeToggleView
                        Spacer()
                    }
                    .padding()
                }
                .background(themeManager.backgroundColor.edgesIgnoringSafeArea(.all))
            }
            .navigationBarHidden(true)
            .background(themeManager.backgroundColor.edgesIgnoringSafeArea(.all))
        }
    }
    
    var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Settings")
                    .font(.title2)
                    .foregroundColor(themeManager.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(themeManager.backgroundColor)
    }
    
    var themeToggleView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Appearance")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            HStack {
                Image(systemName: "moon.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 24))
                
                Text("Dark Mode")
                    .foregroundColor(themeManager.textColor)
                    .font(.body)
                
                Spacer()
                
                Toggle("", isOn: $themeManager.isDarkMode)
                    .labelsHidden()
            }
            .padding()
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(12)
        }
    }
}
