import ComposableArchitecture
import SwiftUI

@Reducer
struct SimpleFeature {
  @ObservableState
  struct State: Equatable {
    var text: String
  }
  
  enum Action { }
}

struct SimpleFeatureView: View {
  let store: StoreOf<SimpleFeature>
  
  var body: some View {
    VStack {
      Text(store.text)
        .font(.title)
    }
  }
}

@Reducer
struct AppFeature: Reducer {
  @ObservableState
  struct State: Equatable {
    @Presents var destination: SimpleFeature.State?
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<SimpleFeature.Action>)
    case buttonTapped
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .destination:
        return .none
      case .buttonTapped:
        state.destination = .init(text: "I'm a simple feature")
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      SimpleFeature()
    }
  }
}

struct ContentView: View {
  @Bindable var store: StoreOf<AppFeature>
  
  var body: some View {
    NavigationStack {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, world!")
        
        Button("Press Me") {
          store.send(.buttonTapped)
        }
      }
      .padding()
      .navigationDestination(
        item: $store.scope(state: \.destination, action: \.destination)
      ) { store in
        SimpleFeatureView(store: store)
      }
    }
  }
}

#Preview {
  ContentView(
    store: Store(initialState: AppFeature.State()) {
      AppFeature()
    }
  )
}
