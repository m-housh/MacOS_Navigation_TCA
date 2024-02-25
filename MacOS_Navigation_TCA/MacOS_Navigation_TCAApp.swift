import ComposableArchitecture
import SwiftUI

@main
struct MacOS_Navigation_TCAApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(initialState: AppFeature.State()) {
          AppFeature()
        }
      )
    }
  }
}
