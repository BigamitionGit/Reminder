import SwiftUI
import Root

@main
struct iOSApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: .init(initialState: Root.State(), reducer: { Root() }))
        }
    }
}
