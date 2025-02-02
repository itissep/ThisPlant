import SwiftUI

struct BaseButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .monospaced()
            .foregroundStyle(.background)
            .frame(maxWidth: .infinity)
            .frame(height: Style.elementsHeight)
            .background(Color.accentColor)
            .clipShape(.rect(cornerRadius: Style.cornerRadius))
            .opacity(isEnabled ? 1 : 0.64)
    }
}

extension View {
    func baseButtonStyle() -> some View {
        buttonStyle(BaseButtonStyle())
    }
}
