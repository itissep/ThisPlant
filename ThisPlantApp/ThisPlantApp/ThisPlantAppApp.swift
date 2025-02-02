import SwiftUI

@main
struct ThisPlantAppApp: App {
    var body: some Scene {
        WindowGroup {
            PlantRecognizerView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .preferredColorScheme(.dark)
        }
    }
}
