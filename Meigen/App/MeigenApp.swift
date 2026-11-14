import SwiftUI
import SwiftData
import Observation

@main
struct MeigenApp: App {
    private let container: ModelContainer
    @State private var viewModel: QuoteViewModel

    init() {
        do {
            let container = try SharedModelContainer.create()
            self.container = container
            _viewModel = State(
                initialValue: QuoteViewModel(
                    repository: SwiftDataQuoteRepository(context: container.mainContext)
                )
            )
        } catch {
            fatalError("SwiftData initialization failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            QuoteListView()
                .environment(viewModel)
                .modelContainer(container)
        }
    }
}
