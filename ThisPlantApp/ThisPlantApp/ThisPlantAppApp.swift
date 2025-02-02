import SwiftUI

@main
struct ThisPlantAppApp: App {
    var body: some Scene {
        WindowGroup {
            PlantClassifierView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .preferredColorScheme(.dark)
        }
    }
}
