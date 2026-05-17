import SwiftUI

extension Color {
    static let orangeFluo = Color(red: 1.0, green: 0.55, blue: 0.0)
    static let greenFluo = Color(red: 0.0, green: 0.9, blue: 0.3)
}

struct FluoButtonStyle: ButtonStyle {
    let color: Color
    var isLarge: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: isLarge ? 16 : 14, weight: .semibold, design: .rounded))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, isLarge ? 12 : 8)
            .background(
                configuration.isPressed ?
                LinearGradient(colors: [color.opacity(0.8), color.opacity(0.6)], startPoint: .top, endPoint: .bottom) :
                LinearGradient(colors: [color, color.opacity(0.85)], startPoint: .top, endPoint: .bottom)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: color.opacity(configuration.isPressed ? 0.3 : 0.5), radius: configuration.isPressed ? 4 : 8, x: 0, y: configuration.isPressed ? 1 : 2)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
